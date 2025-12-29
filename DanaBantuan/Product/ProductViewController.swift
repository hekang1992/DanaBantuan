//
//  ProductViewController.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/26.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import MJRefresh

class ProductViewController: BaseViewController {
    
    var productID: String = ""
    
    private var baseModel: BaseModel?
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = ProductViewModel()
    
    private var locationTool: LocationTool?
    
    private var starttime: String = ""
    
    private let launchViewModel = LaunchViewModel()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        nextBtn.setBackgroundImage(UIImage(named: "list_detai_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
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
        moneyLabel.font = UIFont.systemFont(ofSize: 46, weight: UIFont.Weight(700))
        return moneyLabel
    }()
    
    lazy var rateLabel: UILabel = {
        let rateLabel = UILabel()
        rateLabel.textAlignment = .center
        rateLabel.textColor = UIColor.init(hex: "#759199")
        rateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return rateLabel
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = UIImage(named: "mon_e_image")
        return threeImageView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        let languageCode = LanguageManager.currentLanguage
        fourImageView.image = languageCode == .id ? UIImage(named: "id_com_ad_image") : UIImage(named: "en_com_ad_image")
        fourImageView.contentMode = .scaleAspectFit
        return fourImageView
    }()
    
    lazy var authImageView: UIImageView = {
        let authImageView = UIImageView()
        authImageView.image = UIImage(named: "lis_app_auth_image")
        authImageView.isUserInteractionEnabled = true
        return authImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40.pix())
        }
        
        headView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        let headImageView = UIImageView()
        let languageCode = LanguageManager.currentLanguage
        headImageView.image = languageCode == .id ? UIImage(named: "id_pro_li_image") : UIImage(named: "en_pro_li_image")
        view.addSubview(headImageView)
        headImageView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 60.pix()))
        }
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.size.equalTo(CGSizeMake(345.pix(), 54.pix()))
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(2.pix())
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(nextBtn.snp.top).offset(-10.pix())
        }
        
        scrollView.addSubview(authImageView)
        authImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 354.pix(), height: 610.pix()))
            make.bottom.equalToSuperview().offset(-10.pix())
        }
        
        authImageView.addSubview(logoImageView)
        authImageView.addSubview(nameLabel)
        authImageView.addSubview(itemLabel)
        authImageView.addSubview(oneStarImageView)
        authImageView.addSubview(twoStarImageView)
        authImageView.addSubview(threeImageView)
        authImageView.addSubview(maxLabel)
        authImageView.addSubview(rateLabel)
        threeImageView.addSubview(moneyLabel)
        authImageView.addSubview(fourImageView)
        
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
        threeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(187.pix())
            make.size.equalTo(CGSize(width: 282.pix(), height: 74.pix()))
            make.centerX.equalToSuperview()
        }
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(threeImageView.snp.bottom).offset(12.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
        }
        moneyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        fourImageView.snp.makeConstraints { make in
            make.top.equalTo(rateLabel.snp.bottom).offset(15.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(24.pix())
        }
        
        nextBtn
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                if let baseModel = baseModel {
                    let orderID = baseModel.hairship?.section?.selenality ?? ""
                    let barel = baseModel.hairship?.vovo?.barel ?? ""
                    let jutcommonably = baseModel.hairship?.vovo?.jutcommonably ?? ""
                    if barel.isEmpty || jutcommonably.isEmpty {
                        Task {
                            await self.orderInfo(with: baseModel)
                        }
                    }else {
                        self.clickNoCompleteToNextVc(with: baseModel.hairship?.vovo ?? vovoModel(), orderID: orderID)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        self.scrollView.mj_header = MJRefreshStateHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.getProductDetailInfo()
            }
        })
        
        locationTool = LocationTool(presentingVC: self)
        locationTool?.startLocation { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                print("result====\(result)")
                Task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    AppLocationModel.shared.locationJson = result
                }
            } else {
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            await self.getProductDetailInfo()
        }
    }
    
}

extension ProductViewController {
    
    private func getProductDetailInfo() async {
        do {
            let json = ["spatikin": productID,
                        "preventitude": String(Int(1))
            ]
            let model = try await viewModel.productDetailInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                self.baseModel = model
                configWithMessage(with: model)
            }
            await MainActor.run {
                self.scrollView.mj_header?.endRefreshing()
            }
        } catch {
            await MainActor.run {
                self.scrollView.mj_header?.endRefreshing()
            }
        }
    }
    
}

extension ProductViewController {
    
    private func configWithMessage(with model: BaseModel) {
        let name = model.hairship?.section?.tic ?? ""
        self.headView.configure(withTitle: name)
        self.nextBtn.setTitle(model.hairship?.section?.penoern ?? "", for: .normal)
        
        let logoUrl = model.hairship?.section?.vituage ?? ""
        logoImageView.kf.setImage(with: URL(string: logoUrl))
        nameLabel.text = name
        
        maxLabel.text = model.hairship?.section?.cordeous ?? ""
        moneyLabel.text = model.hairship?.section?.ourability ?? ""
        
        let three = model.hairship?.section?.stereo?.clysmonceit?.jutcommonably ?? ""
        let four = model.hairship?.section?.stereo?.clysmonceit?.futilition ?? ""
        
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
        
        let modelArray = model.hairship?.play ?? []
        createDynamicViews(with: modelArray)
    }
    
    private func createDynamicViews(with modelArray: [playModel]) {
        removeExistingDynamicViews()
        let referenceView = fourImageView
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        authImageView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(referenceView.snp.bottom).offset(20.pix())
            make.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10.pix())
        }
        
        var previousView: UIView?
        let itemHeight = 54.pix()
        let spacing = 10.pix()
        
        for (index, model) in modelArray.enumerated() {
            let itemView = createItemView(for: model, index: index)
            containerView.addSubview(itemView)
            
            itemView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(itemHeight)
                
                if let previous = previousView {
                    make.top.equalTo(previous.snp.bottom).offset(spacing)
                } else {
                    make.top.equalToSuperview()
                }
                
                if index == modelArray.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
            
            previousView = itemView
        }
        
        if modelArray.isEmpty {
            containerView.snp.makeConstraints { make in
                make.height.equalTo(0)
            }
        }
        
        DispatchQueue.main.async {
            self.updateScrollViewContentSize()
        }
    }
    
    private func createItemView(for model: playModel, index: Int) -> UIView {
        let itemView = CompleteListView()
        let barel = model.barel ?? ""
        let sectionia = model.sectionia ?? 0
        itemView.numLabel.text = String(format: "%@:", String(index + 1))
        itemView.nameLabel.text = model.jutcommonably ?? ""
        if sectionia == 1 {
            itemView.numLabel.textColor = UIColor.init(hex: "#96EF24")
            itemView.nameLabel.textColor = UIColor.init(hex: "#96EF24")
            itemView.iconImageView.image = UIImage(named: "\(barel)_sel_image")
            itemView.bgView.layer.borderWidth = 2
            itemView.bgView.layer.borderColor = UIColor.init(hex: "#96EF24").cgColor
            itemView.authImageView.isHidden = false
            itemView.rightImageView.isHidden = true
        }else {
            itemView.numLabel.textColor = UIColor.init(hex: "#759199")
            itemView.nameLabel.textColor = UIColor.init(hex: "#759199")
            itemView.iconImageView.image = UIImage(named: "\(barel)_nor_image")
            itemView.authImageView.isHidden = true
            itemView.rightImageView.isHidden = false
        }
        itemView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            let orderID = self.baseModel?.hairship?.section?.selenality ?? ""
            if sectionia == 1 {
                self.clickCompleteToNextVc(with: model, orderID: orderID)
            }else {
                if let baseModel = baseModel {
                    self.clickNoCompleteToNextVc(with: baseModel.hairship?.vovo ?? vovoModel(), orderID: orderID)
                }
            }
        }
        return itemView
    }
    
    private func removeExistingDynamicViews() {
        for view in authImageView.subviews {
            if view != logoImageView && view != nameLabel && view != itemLabel &&
                view != oneStarImageView && view != twoStarImageView && view != threeImageView &&
                view != maxLabel && view != rateLabel && view != moneyLabel && view != fourImageView {
                view.removeFromSuperview()
            }
        }
    }
    
    private func updateScrollViewContentSize() {
        view.layoutIfNeeded()
        var totalHeight: CGFloat = 0
        for view in authImageView.subviews {
            totalHeight = max(totalHeight, view.frame.maxY)
        }
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: totalHeight + 20)
    }
}

extension ProductViewController {
    
    /// complete_auth_info
    private func clickCompleteToNextVc(with model: playModel, orderID: String) {
        let barel = model.barel ?? ""
        let jutcommonably = model.jutcommonably ?? ""
        self.goNextVc(with: barel, name: jutcommonably, orderID: orderID, productID: productID)
    }
    
    /// nocomp_auth_info
    private func clickNoCompleteToNextVc(with model: vovoModel, orderID: String) {
        let barel = model.barel ?? ""
        let jutcommonably = model.jutcommonably ?? ""
        self.goNextVc(with: barel, name: jutcommonably, orderID: orderID, productID: productID)
    }
}

extension ProductViewController {
    
    private func orderInfo(with model: BaseModel) async {
        let last = model.hairship?.section?.selenality ?? ""
        let ourability = model.hairship?.section?.ourability ?? ""
        let acetacy = model.hairship?.section?.acetacy ?? ""
        let quassweightify = String(model.hairship?.section?.quassweightify ?? 0)
        let yourselfibility = LanguageManager.currentLanguage.rawValue
        starttime = String(Date().timeIntervalSince1970)
        do {
            let json = ["last": last,
                        "ourability": ourability,
                        "acetacy": acetacy,
                        "quassweightify": quassweightify,
                        "yourselfibility": yourselfibility]
            let model = try await viewModel.orderInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                Task {
                    await self.stayApp(with: last)
                }
                let pageUrl = model.hairship?.orexilike ?? ""
                if pageUrl.hasPrefix(SchemeApiUrl.scheme_url) {
                    URLSchemeParsable.handleSchemeRoute(pageUrl: pageUrl, from: self)
                } else {
                    if pageUrl.isEmpty {
                        return
                    }
                    self.goWebVc(with: pageUrl)
                }
            }else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            
        }
    }
    
}

extension ProductViewController {
    
    private func stayApp(with orderID: String) async {
        let locationJson = AppLocationModel.shared.locationJson ?? [:]
        let amward = locationJson["amward"] ?? ""
        let rhizeur = locationJson["rhizeur"] ?? ""
        do {
            let json = ["cupship": starttime,
                        "laud": String(Int(Date().timeIntervalSince1970)),
                        "amward": amward,
                        "rhizeur": rhizeur,
                        "recordage": "8",
                        "selenality": orderID,
                        "archaeoourster": productID]
            let _ = try await launchViewModel.uploadSnippetInfo(json: json)
        } catch {
            
        }
    }
    
}
