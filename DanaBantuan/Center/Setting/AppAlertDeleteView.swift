//
//  AppAlertDeleteView.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/26.
//

import UIKit
import SnapKit

class AppAlertDeleteView: UIView {
    
    var cancelBlock: (() -> Void)?
    
    var sureBlock: (() -> Void)?

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        let languageCode = LanguageManager.currentLanguage
        bgImageView.image = languageCode == .id ? UIImage(named: "id_can_app_imge") : UIImage(named: "en_can_app_imge")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return cancelBtn
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
        return twoBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setImage(UIImage(named: "login_nor_image"), for: .normal)
        sureBtn.setImage(UIImage(named: "login_sel_image"), for: .selected)
        sureBtn.addTarget(self, action: #selector(sureMentClick), for: .touchUpInside)
        return sureBtn
    }()
    
    lazy var sureLabel: UILabel = {
        let sureLabel = UILabel()
        sureLabel.textAlignment = .left
        sureLabel.text = "I have read and agree to the above"
        sureLabel.textColor = UIColor.init(hex: "#759199")
        sureLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return sureLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(315.pix())
            make.height.equalTo(420.pix())
        }
        
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(twoBtn)
        bgImageView.addSubview(oneBtn)
        
        bgImageView.addSubview(sureBtn)
        bgImageView.addSubview(sureLabel)
        
        cancelBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.top.right.equalToSuperview()
        }
        twoBtn.snp.makeConstraints { make in
            make.height.equalTo(48.pix())
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.pix())
        }
        oneBtn.snp.makeConstraints { make in
            make.height.equalTo(48.pix())
            make.left.right.equalToSuperview()
            make.bottom.equalTo(twoBtn.snp.top).offset(-14.pix())
        }
        
        sureBtn.snp.makeConstraints { make in
            make.bottom.equalTo(oneBtn.snp.top).offset(-13.pix())
            make.size.equalTo(CGSize(width: 14.pix(), height: 14.pix()))
            make.left.equalToSuperview().offset(45.pix())
        }
        sureLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sureBtn)
            make.left.equalTo(sureBtn.snp.right).offset(5.pix())
            make.height.equalTo(16.pix())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppAlertDeleteView {
    
    @objc func cancelClick() {
        self.cancelBlock?()
    }
    
    @objc func sureClick() {
        self.sureBlock?()
    }
    
    @objc func sureMentClick() {
        self.sureBtn.isSelected.toggle()
    }
}
