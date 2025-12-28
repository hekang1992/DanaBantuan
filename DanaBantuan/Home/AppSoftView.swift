//
//  AppSoftView.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import FSPagerView

class AppSoftView: UIView {
    
    var modelArray: [clearficModel]? {
        didSet {
            tableView.reloadData()
            pagerView.reloadData()
            setupAutoScroll()
        }
    }
    
    private let disposeBag = DisposeBag()
    private var autoScrollTimer: Timer?
    
    var tapClickBlock: ((haveionModel) -> Void)?
    
    var tapBannerClickBlock: ((haveionModel) -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "mine_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(AppSoftViewCell.self, forCellReuseIdentifier: "AppSoftViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "soft_head_image")
        return headImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = UIImage(named: "mon_e_image")
        return threeImageView
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        applyBtn.setBackgroundImage(UIImage(named: "apply_btn_bg_image"), for: .normal)
        applyBtn.adjustsImageWhenHighlighted = false
        return applyBtn
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        logoImageView.backgroundColor = .gray
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#052861")
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return nameLabel
    }()
    
    lazy var itemLabel: UILabel = {
        let itemLabel = UILabel()
        itemLabel.textAlignment = .right
        itemLabel.textColor = UIColor.init(hex: "#052861")
        itemLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return itemLabel
    }()
    
    lazy var oneStarImageView: UIImageView = {
        let oneStarImageView = UIImageView()
        oneStarImageView.image = UIImage(named: "hone_state_image")
        return oneStarImageView
    }()
    
    lazy var twoStarImageView: UIImageView = {
        let twoStarImageView = UIImageView()
        twoStarImageView.image = UIImage(named: "hone_state_image")
        return twoStarImageView
    }()
    
    lazy var maxLabel: UILabel = {
        let maxLabel = UILabel()
        maxLabel.textAlignment = .center
        maxLabel.textColor = UIColor.init(hex: "#1CC7EF")
        maxLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return maxLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .center
        moneyLabel.textColor = UIColor.init(hex: "#0A1121")
        moneyLabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight(700))
        return moneyLabel
    }()
    
    lazy var rateLabel: UILabel = {
        let rateLabel = UILabel()
        rateLabel.textAlignment = .center
        rateLabel.textColor = UIColor.init(hex: "#759199")
        rateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return rateLabel
    }()
    
    lazy var bannerImageView: UIImageView = {
        let bannerImageView = UIImageView()
        bannerImageView.image = UIImage(named: "soft_ban_a_image")
        bannerImageView.isUserInteractionEnabled = true
        return bannerImageView
    }()
    
    lazy var pagerView: FSPagerView = {
        let pv = FSPagerView()
        pv.dataSource = self
        pv.delegate = self
        pv.register(CustomPagerCell.self, forCellWithReuseIdentifier: "CustomPagerCell")
        pv.interitemSpacing = 5
        pv.transformer = FSPagerViewTransformer(type: .linear)
        pv.isInfinite = true
        pv.automaticSlidingInterval = 3.0
        pv.backgroundColor = .clear
        pv.layer.borderWidth = 0
        return pv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopAutoScroll()
    }
    
    private func setupUI() {
        addSubview(bgImageView)
        addSubview(tableView)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(2.pix())
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupAutoScroll() {
        stopAutoScroll()

        let haveion = modelArray?
            .first(where: { $0.gymn == "vigesimose" })?
            .haveion ?? []
        
        if haveion.count <= 1 {
            pagerView.automaticSlidingInterval = 0
            pagerView.isInfinite = false
            pagerView.isScrollEnabled = false
        } else {
            pagerView.automaticSlidingInterval = 3.0
            pagerView.isInfinite = true
            pagerView.isScrollEnabled = true
        }
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
}

extension AppSoftView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let exists = modelArray?.contains { $0.gymn == "vigesimose" && ($0.haveion?.isEmpty == false) } ?? false
        if exists {
            return (332 + 50 + 80).pix()
        }else {
            return (332 + 50).pix()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let exists = modelArray?.contains { $0.gymn == "vigesimose" && ($0.haveion?.isEmpty == false) } ?? false
        
        let haveion = modelArray?
            .first(where: { $0.gymn == "heartivity" })?
            .haveion ?? []
        
        let model = haveion.first ?? haveionModel()
        
        let headView = UIView()
        headView.addSubview(headImageView)
        
        headImageView.addSubview(threeImageView)
        headImageView.addSubview(logoImageView)
        headImageView.addSubview(nameLabel)
        headImageView.addSubview(itemLabel)
        headImageView.addSubview(oneStarImageView)
        headImageView.addSubview(twoStarImageView)
        headImageView.addSubview(maxLabel)
        headImageView.addSubview(rateLabel)
        threeImageView.addSubview(moneyLabel)
        headView.addSubview(applyBtn)
        headView.addSubview(bannerImageView)
        
        headImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 332.pix()))
        }
        
        threeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(187.pix())
            make.size.equalTo(CGSize(width: 282.pix(), height: 74.pix()))
            make.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(94.pix())
            make.left.equalToSuperview().offset(25.pix())
            make.size.equalTo(CGSize(width: 30.pix(), height: 30.pix()))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(5.pix())
            make.height.equalTo(16)
        }
        itemLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.right.equalToSuperview().offset(-25.pix())
            make.height.equalTo(16)
        }
        oneStarImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(31.pix())
            make.left.equalTo(logoImageView).offset(25.pix())
            make.size.equalTo(CGSize(width: 41, height: 13))
        }
        twoStarImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(31.pix())
            make.right.equalToSuperview().offset(-49.pix())
            make.size.equalTo(CGSize(width: 41, height: 13))
        }
        maxLabel.snp.makeConstraints { make in
            make.centerY.equalTo(oneStarImageView)
            make.left.equalTo(oneStarImageView.snp.right).offset(5.pix())
            make.right.equalTo(twoStarImageView.snp.left).offset(-5.pix())
            make.height.equalTo(15)
        }
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(threeImageView.snp.bottom).offset(12.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
        }
        moneyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(-40.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 282.pix(), height: 60.pix()))
        }
        
        bannerImageView.snp.makeConstraints { make in
            make.top.equalTo(applyBtn.snp.bottom).offset(20.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 345.pix(), height: 80.pix()))
        }
        
        let headClickBtn = UIButton(type: .custom)
        headView.addSubview(headClickBtn)
        
        headClickBtn.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(358.pix())
        }
        
        bannerImageView.addSubview(pagerView)
        pagerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if exists {
            bannerImageView.isHidden = false
            pagerView.itemSize = CGSize(width: 325.pix(), height: 80.pix())
        } else {
            bannerImageView.isHidden = true
        }
        
        let logoUrl = model.vituage ?? ""
        let name = model.tic ?? ""
        
        logoImageView.kf.setImage(with: URL(string: logoUrl))
        nameLabel.text = name
        
        let one = model.relateform ?? ""
        let two = model.paintingsion ?? ""
        itemLabel.text = String(format: "%@: %@", one, two)
        maxLabel.text = model.algics ?? ""
        
        moneyLabel.text = model.persicfier ?? ""
        applyBtn.setTitle(model.penoern ?? "", for: .normal)
        
        let three = model.hydroing ?? ""
        let four = model.oesophagable ?? ""
        
        let threePart = String(format: "%@: ", three)
        let fullText = threePart + four
        
        let attributedText = NSMutableAttributedString(string: fullText)
        
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor.init(hex: "#759199"),
                                    range: NSRange(location: 0, length: threePart.count))
        
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor.init(hex: "#29C1F3"),
                                    range: NSRange(location: threePart.count, length: four.count))
        
        rateLabel.attributedText = attributedText
        
        headClickBtn
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.tapClickBlock?(model)
            })
            .disposed(by: disposeBag)
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let haveion = modelArray?
            .first(where: { $0.gymn == "bettereer" })?
            .haveion ?? []
        return haveion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppSoftViewCell", for: indexPath) as! AppSoftViewCell
        let haveion = modelArray?
            .first(where: { $0.gymn == "bettereer" })?
            .haveion ?? []
        let model = haveion[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let haveion = modelArray?
            .first(where: { $0.gymn == "bettereer" })?
            .haveion ?? []
        let model = haveion[indexPath.row]
        self.tapClickBlock?(model)
    }
    
}

extension AppSoftView: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        let haveion = modelArray?
            .first(where: { $0.gymn == "vigesimose" })?
            .haveion ?? []
        return haveion.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let haveion = modelArray?
            .first(where: { $0.gymn == "vigesimose" })?
            .haveion ?? []
        let model = haveion[index]
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "CustomPagerCell", at: index) as! CustomPagerCell
        cell.titleLabel.text = model.se ?? ""
        
        cell.contentView.layer.shadowColor = UIColor.clear.cgColor
        cell.contentView.layer.shadowRadius = 0
        cell.contentView.layer.shadowOpacity = 0
        cell.contentView.layer.shadowOffset = .zero
        
        cell.contentView.transform = CGAffineTransform.identity
        
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let haveion = modelArray?
            .first(where: { $0.gymn == "vigesimose" })?
            .haveion ?? []
        let model = haveion[index]
        self.tapBannerClickBlock?(model)
    }
    
}

class CustomPagerCell: FSPagerViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hex: "#0A1121")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        let text = LanguageManager.localizedString(for: "Repayment")
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: text.count)
        )
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.init(hex: "#1CC7EF"),
            range: NSRange(location: 0, length: text.count)
        )
        
        label.attributedText = attributedString
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bottomLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5.pix(), left: 5.pix(), bottom: 10.pix(), right: 5.pix()))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomLabel.snp.top).offset(-5)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15)
        }
    }
}
