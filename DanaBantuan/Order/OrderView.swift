//
//  OrderView.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/28.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class OrderView: UIView {
    
    var modelArray: [clearficModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            emptyView.isHidden = modelArray.count > 0 ? true : false
            tableView.reloadData()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private var itemViews: [SelectableItemView] = []
    
    var orderTypeBlock: ((String) -> Void)?
    
    var tapClickBlock: (() -> Void)?
    
    var tapCellClickBlock: ((clearficModel) -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "mine_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var bannerImageView: UIImageView = {
        let bannerImageView = UIImageView()
        let languageCode = LanguageManager.currentLanguage
        bannerImageView.image = languageCode == .id ? UIImage(named: "id_dd_banner") : UIImage(named: "en_dd_banner")
        return bannerImageView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.layer.cornerRadius = 14
        whiteView.layer.masksToBounds = true
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var oneView = SelectableItemView()
    lazy var twoView = SelectableItemView()
    lazy var threeView = SelectableItemView()
    lazy var fourView = SelectableItemView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(OrderViewCell.self, forCellReuseIdentifier: "OrderViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var emptyView: OrderEmptyView = {
        let emptyView = OrderEmptyView(frame: .zero)
        emptyView.isHidden = true
        return emptyView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupItems()
        setupActions()
        updateSelection(index: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(bannerImageView)
        bannerImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 69.pix()))
        }
        
        addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(10.pix())
            make.centerX.equalToSuperview()
            make.width.equalTo(345.pix())
            make.height.equalTo(150.pix())
        }
        
        [oneView, twoView, threeView, fourView].forEach {
            whiteView.addSubview($0)
            itemViews.append($0)
        }
        
        oneView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(15.pix())
            make.width.equalTo(152.pix())
            make.height.equalTo(54.pix())
        }
        
        twoView.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(15.pix())
            make.width.equalTo(oneView)
            make.height.equalTo(oneView)
        }
        
        threeView.snp.makeConstraints { make in
            make.left.equalTo(oneView)
            make.top.equalTo(oneView.snp.bottom).offset(15.pix())
            make.width.height.equalTo(oneView)
        }
        
        fourView.snp.makeConstraints { make in
            make.left.equalTo(twoView)
            make.top.equalTo(twoView.snp.bottom).offset(15.pix())
            make.width.height.equalTo(oneView)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(whiteView.snp.bottom).offset(5.pix())
            make.left.right.bottom.equalToSuperview()
        }
        
        addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(whiteView.snp.bottom).offset(5.pix())
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupItems() {
        let norBg = UIImage(named: "orc_nor_btn_image")!
        let selBg = UIImage(named: "orc_sel_btn_image")!
        
        oneView.configure(
            title: LanguageManager.localizedString(for: "All"),
            normalBg: norBg,
            selectedBg: selBg,
            normalLogo: UIImage(named: "rep_nor_image")!,
            selectedLogo: UIImage(named: "rep_sel_image")!
        )
        
        twoView.configure(
            title: LanguageManager.localizedString(for: "Applying"),
            normalBg: norBg,
            selectedBg: selBg,
            normalLogo: UIImage(named: "all_nor_image")!,
            selectedLogo: UIImage(named: "all_sel_image")!
        )
        
        threeView.configure(
            title: LanguageManager.localizedString(for: "Repayment"),
            normalBg: norBg,
            selectedBg: selBg,
            normalLogo: UIImage(named: "apply_nor_image")!,
            selectedLogo: UIImage(named: "apply_sel_image")!
        )
        
        fourView.configure(
            title: LanguageManager.localizedString(for: "Finish"),
            normalBg: norBg,
            selectedBg: selBg,
            normalLogo: UIImage(named: "fin_nor_image")!,
            selectedLogo: UIImage(named: "fin_sel_image")!
        )
        
        emptyView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            self.tapClickBlock?()
        }
    }
    
    private func setupActions() {
        for (index, view) in itemViews.enumerated() {
            view.tag = index
            view.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func itemTapped(_ sender: SelectableItemView) {
        updateSelection(index: sender.tag)
    }
    
    private func updateSelection(index: Int) {
        switch index {
        case 0:
            self.orderTypeBlock?("4")
        case 1:
            self.orderTypeBlock?("7")
        case 2:
            self.orderTypeBlock?("6")
        case 3:
            self.orderTypeBlock?("5")
        default:
            break
        }
        
        for (i, view) in itemViews.enumerated() {
            view.isSelected = (i == index)
        }
    }
}

extension OrderView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderViewCell", for: indexPath) as! OrderViewCell
        let model = self.modelArray?[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.modelArray?[indexPath.row] {
            self.tapCellClickBlock?(model)
        }
    }
    
}
