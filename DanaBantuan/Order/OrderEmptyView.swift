//
//  OrderEmptyView.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/28.
//

import UIKit
import SnapKit

class OrderEmptyView: UIView {
    
    var tapClickBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "em_c_ic_image")
        return bgImageView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .center
        oneLabel.text = LanguageManager.localizedString(for: "No orders yet…")
        oneLabel.textColor = UIColor.init(hex: "#0A1121")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .center
        twoLabel.text = LanguageManager.localizedString(for: "No order record? Go apply now!")
        twoLabel.textColor = UIColor.init(hex: "#0A1121")
        twoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return twoLabel
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitle(LanguageManager.localizedString(for: "Start Apply"), for: .normal)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        applyBtn.setBackgroundImage(UIImage(named: "emp_oe_a_image"), for: .normal)
        applyBtn.adjustsImageWhenHighlighted = false
        applyBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return applyBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneLabel)
        addSubview(bgImageView)
        addSubview(twoLabel)
        addSubview(applyBtn)
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(14.pix())
        }
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(14.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 122.pix(), height: 59.pix()))
        }
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(15.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(14.pix())
        }
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(twoLabel.snp.bottom).offset(15.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 130.pix(), height: 44.pix()))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OrderEmptyView {
    
    @objc func btnClick() {
        self.tapClickBlock?()
    }
}
