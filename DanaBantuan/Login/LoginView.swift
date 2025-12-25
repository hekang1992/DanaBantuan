//
//  LoginView.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class LoginView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var loginBlock: (() -> Void)?
    var codeBlock: (() -> Void)?
    var agreeBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "login_logo_image")
        return logoImageView
    }()
    
    lazy var typeImageView: UIImageView = {
        let typeImageView = UIImageView()
        let code = LanguageManager.currentLanguage
        typeImageView.image = code == .id ? UIImage(named: "login_id_one_image") : UIImage(named: "login_en_one_image")
        return typeImageView
    }()
    
    lazy var phoneView: UIView = {
        let phoneView = UIView()
        phoneView.layer.cornerRadius = 14
        phoneView.layer.masksToBounds = true
        phoneView.backgroundColor = UIColor.init(hex: "#FFFAFA")
        return phoneView
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.text = LanguageManager.localizedString(for: "+91")
        numLabel.textColor = UIColor.init(hex: "#0A1121")
        numLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        numLabel.textAlignment = .center
        return numLabel
    }()
    
    lazy var phoneFiled: UITextField = {
        let phoneFiled = UITextField()
        phoneFiled.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: LanguageManager.localizedString(for: "Please enter mobile phone number"), attributes: [
            .foregroundColor: UIColor.init(hex: "#759199") as Any,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ])
        phoneFiled.attributedPlaceholder = attrString
        phoneFiled.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        phoneFiled.textColor = UIColor.init(hex: "#0A1121")
        return phoneFiled
    }()
    
    lazy var codeView: UIView = {
        let codeView = UIView()
        codeView.layer.cornerRadius = 14
        codeView.layer.masksToBounds = true
        codeView.backgroundColor = UIColor.init(hex: "#FFFAFA")
        return codeView
    }()
    
    lazy var codeFiled: UITextField = {
        let codeFiled = UITextField()
        codeFiled.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: LanguageManager.localizedString(for: "Please enter verification code"), attributes: [
            .foregroundColor: UIColor.init(hex: "#759199") as Any,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ])
        codeFiled.attributedPlaceholder = attrString
        codeFiled.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        codeFiled.textColor = UIColor.init(hex: "#0A1121")
        return codeFiled
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle(LanguageManager.localizedString(for: "Login"), for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        loginBtn.setBackgroundImage(UIImage(named: "btn_click_image"), for: .normal)
        loginBtn.adjustsImageWhenHighlighted = false
        return loginBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.isSelected = true
        sureBtn.setImage(UIImage(named: "login_nor_image"), for: .normal)
        sureBtn.setImage(UIImage(named: "login_sel_image"), for: .selected)
        return sureBtn
    }()
    
    lazy var agreeLabel: UILabel = {
        let agreeLabel = UILabel()
        agreeLabel.attributedText = createAgreeAttributedText()
        agreeLabel.numberOfLines = 0
        return agreeLabel
    }()
    
    private func createAgreeAttributedText() -> NSAttributedString {
        let fullText = LanguageManager.localizedString(for: "I have read and agree to the <Privacy Policy>")
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let defaultColor = UIColor(hex: "#759199")
        attributedString.addAttribute(
            .foregroundColor,
            value: defaultColor,
            range: NSRange(location: 0, length: fullText.count)
        )
        
        attributedString.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: 12),
            range: NSRange(location: 0, length: fullText.count)
        )
        
        let privacyPolicyColor = UIColor(hex: "#0A1121")
        let privacyPolicyRange = (fullText as NSString).range(of: LanguageManager.localizedString(for: "<Privacy Policy>"))
        
        if privacyPolicyRange.location != NSNotFound {
            attributedString.addAttribute(
                .foregroundColor,
                value: privacyPolicyColor,
                range: privacyPolicyRange
            )
        }
        
        return attributedString
    }
    
    lazy var codeBtn: UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.setTitle(LanguageManager.localizedString(for: "Get Code"), for: .normal)
        codeBtn.setTitleColor(UIColor.init(hex: "#1CC7EF"), for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return codeBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hex: "#1CC7EF")
        lineView.layer.cornerRadius = 2
        lineView.layer.masksToBounds = true
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(logoImageView)
        addSubview(typeImageView)
        addSubview(phoneView)
        addSubview(codeView)
        addSubview(loginBtn)
        addSubview(sureBtn)
        addSubview(agreeLabel)
        phoneView.addSubview(numLabel)
        phoneView.addSubview(phoneFiled)
        codeView.addSubview(codeFiled)
        codeView.addSubview(codeBtn)
        codeView.addSubview(lineView)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 88.pix(), height: 88.pix()))
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(33)
        }
        typeImageView.snp.makeConstraints { make in
            make.left.equalTo(logoImageView)
            make.top.equalTo(logoImageView.snp.bottom).offset(14)
            make.height.equalTo(24.pix())
            make.width.equalTo(250.pix())
        }
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(typeImageView.snp.bottom).offset(38)
            make.left.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
        }
        codeView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(31)
            make.left.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
        }
        loginBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(315.pix())
            make.height.equalTo(54.pix())
            make.top.equalTo(codeView.snp.bottom).offset(58)
        }
        sureBtn.snp.makeConstraints { make in
            make.top.equalTo(loginBtn.snp.bottom).offset(21)
            make.size.equalTo(CGSize(width: 14.pix(), height: 14.pix()))
            make.left.equalToSuperview().offset(47)
        }
        agreeLabel.snp.makeConstraints { make in
            make.top.equalTo(sureBtn).offset(-2)
            make.left.equalTo(sureBtn.snp.right).offset(5.pix())
            make.right.equalToSuperview().offset(-30)
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 52.pix(), height: 40))
        }
        phoneFiled.snp.makeConstraints { make in
            make.left.equalTo(numLabel.snp.right)
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
        codeFiled.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15.pix())
            make.right.equalToSuperview().offset(-85.pix())
            make.height.equalTo(50)
        }
        codeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(1)
            make.right.equalToSuperview().offset(-18)
            make.height.equalTo(14.pix())
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalTo(codeBtn).inset(-0.5)
            make.bottom.equalTo(codeBtn).offset(1)
            make.height.equalTo(1)
        }
        
        sureBtn
            .rx
            .tap
            .debounce(.microseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                sureBtn.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        loginBtn
            .rx
            .tap
            .debounce(.microseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.loginBlock?()
            })
            .disposed(by: disposeBag)
        
        codeBtn
            .rx
            .tap
            .debounce(.microseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.codeBlock?()
            })
            .disposed(by: disposeBag)
        
        agreeLabel
            .rx
            .tapGesture()
            .when(.recognized)
            .debounce(.microseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.agreeBlock?()
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginView {
    
}
