//
//  CenterView.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit

class CenterView: UIView {
    
    var tapClickBlock: ((String) -> Void)?
    
    var modelArray: [odontardModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "mine_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "logo_icon_image")
        return iconImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .left
        let phone = UserLoginConfig.phone ?? ""
        phoneLabel.text = PhoneFormatter.formatPhoneNumber(phone)
        phoneLabel.textColor = UIColor.init(hex: "#0A1121")
        phoneLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        return phoneLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = "Dana Bantuan"
        nameLabel.textColor = UIColor.init(hex: "#0A1121")
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return nameLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CenterListViewCell.self, forCellReuseIdentifier: "CenterListViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(iconImageView)
        addSubview(phoneLabel)
        addSubview(nameLabel)
        addSubview(tableView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(35)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(68)
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView).offset(6)
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.height.equalTo(24)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(8)
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.height.equalTo(22)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CenterView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CenterListViewCell", for: indexPath) as! CenterListViewCell
        if let model = self.modelArray?[indexPath.row] {
            cell.configWithCell(with: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.modelArray?[indexPath.row] {
            let pageUrl = model.goodard ?? ""
            self.tapClickBlock?(pageUrl)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 14
        cell.contentView.layer.masksToBounds = true
    }
    
}
