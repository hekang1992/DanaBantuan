//
//  CenterListViewCell.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import UIKit
import SnapKit
import Kingfisher

class CenterListViewCell: UITableViewCell {

    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.masksToBounds = true
        iconImageView.backgroundColor = .gray
        return iconImageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "right_icon_image")
        return rightImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#0A1121")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return nameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rightImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(26.pix())
            make.bottom.equalToSuperview().offset(-18.pix())
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.height.equalTo(18)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 10, height: 14))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CenterListViewCell {
    
    func configWithCell(with model: odontardModel) {
        let logoUrl = model.pung ?? ""
        iconImageView.kf.setImage(with: URL(string: logoUrl))
        
        nameLabel.text = model.jutcommonably ?? ""
    }
    
}
