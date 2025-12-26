//
//  AppOneView.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import UIKit
import SnapKit
import Kingfisher

class AppOneView: UIView {
    
    var applyBlock: ((haveionModel) -> Void)?
    
    var model: haveionModel? {
        didSet {
            guard let model = model else { return }
            
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
            
            rateLabel.text = String(format: "%@: %@", three, four)
        }
    }

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "mine_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        let languageCode = LanguageManager.currentLanguage
        oneImageView.image = languageCode == .id ? UIImage(named: "home_ban_id_image") : UIImage(named: "home_ban_en_image")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "home_main_image")
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = UIImage(named: "mon_e_image")
        return threeImageView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        let languageCode = LanguageManager.currentLanguage
        fourImageView.image = languageCode == .id ? UIImage(named: "home_apply_idsc_image") : UIImage(named: "home_apply_ensc_image")
        return fourImageView
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        applyBtn.setBackgroundImage(UIImage(named: "apply_btn_bg_image"), for: .normal)
        applyBtn.adjustsImageWhenHighlighted = false
        return applyBtn
    }()
    
    lazy var footerImageView: UIImageView = {
        let footerImageView = UIImageView()
        let languageCode = LanguageManager.currentLanguage
        footerImageView.image = languageCode == .id ? UIImage(named: "mine_foot_id_image") : UIImage(named: "home_footer_id_image")
        return footerImageView
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
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        clickBtn.addTarget(self, action: #selector(applyClick), for: .touchUpInside)
        return clickBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(scrollView)
        scrollView.addSubview(oneImageView)
        scrollView.addSubview(twoImageView)
        
        twoImageView.addSubview(threeImageView)
        twoImageView.addSubview(fourImageView)
        twoImageView.addSubview(logoImageView)
        twoImageView.addSubview(nameLabel)
        twoImageView.addSubview(itemLabel)
        twoImageView.addSubview(oneStarImageView)
        twoImageView.addSubview(twoStarImageView)
        twoImageView.addSubview(maxLabel)
        twoImageView.addSubview(rateLabel)
        threeImageView.addSubview(moneyLabel)
        
        scrollView.addSubview(applyBtn)
        scrollView.addSubview(footerImageView)
        scrollView.addSubview(clickBtn)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(15)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        oneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 110.pix()))
        }
        twoImageView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom)
            make.size.equalTo(CGSize(width: 375.pix(), height: 405.pix()))
            make.centerX.equalToSuperview()
        }
        threeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(187.pix())
            make.size.equalTo(CGSize(width: 282.pix(), height: 74.pix()))
            make.centerX.equalToSuperview()
        }
        fourImageView.snp.makeConstraints { make in
            make.top.equalTo(threeImageView.snp.bottom).offset(43.pix())
            make.size.equalTo(CGSize(width: 282.pix(), height: 43.pix()))
            make.centerX.equalToSuperview()
        }
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(twoImageView.snp.bottom).offset(-40.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 282.pix(), height: 60.pix()))
        }
        footerImageView.snp.makeConstraints { make in
            make.top.equalTo(applyBtn.snp.bottom).offset(15)
            make.width.equalTo(345.pix())
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.pix())
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(94.pix())
            make.left.equalToSuperview().offset(25.pix())
            make.size.equalTo(CGSize(width: 34.pix(), height: 34.pix()))
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
        clickBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(applyBtn)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AppOneView {
    
    @objc func applyClick() {
        if let model = model {
            self.applyBlock?(model)
        }
    }
    
}
