//
//  SettingListView.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/26.
//

import UIKit
import SnapKit

class SettingListView: UIView {
    
    var tapClickBlock: (() -> Void)?
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.masksToBounds = true
        return iconImageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "right_icon_image")
        rightImageView.isHidden = true
        return rightImageView
    }()
    
    lazy var rightLabel: UILabel = {
        let rightLabel = UILabel()
        rightLabel.textAlignment = .right
        rightLabel.textColor = UIColor.init(hex: "#759199")
        rightLabel.isHidden = true
        rightLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return rightLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#0A1121")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return nameLabel
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        clickBtn.addTarget(self, action: #selector(tapClick), for: .touchUpInside)
        return clickBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(rightImageView)
        addSubview(rightLabel)
        addSubview(clickBtn)
        
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
        
        rightLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 50, height: 14))
        }
        
        clickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SettingListView {
    
    @objc func tapClick() {
        self.tapClickBlock?()
    }
    
}
