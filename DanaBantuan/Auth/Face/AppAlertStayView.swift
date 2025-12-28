//
//  AppAlertStayView.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/28.
//


import UIKit
import SnapKit

class AppAlertStayView: UIView {
    
    var cancelBlock: (() -> Void)?
    var sureBlock: (() -> Void)?

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        let languageCode = LanguageManager.currentLanguage
        bgImageView.image = languageCode == .id ? UIImage(named: "id_stay_pop_image") : UIImage(named: "en_stay_pop_image")
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(315.pix())
            make.height.equalTo(460.pix())
        }
        
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(twoBtn)
        bgImageView.addSubview(oneBtn)
        
        cancelBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(20.pix())
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
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppAlertStayView {
    
    @objc func cancelClick() {
        self.cancelBlock?()
    }
    
    @objc func sureClick() {
        self.sureBlock?()
    }
}
