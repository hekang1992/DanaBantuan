//
//  LoginViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
    private var timer: Timer?
    
    private var countDown: Int = 60
    
    private let viewModel = LoginViewModel()
    
    lazy var loginView: LoginView = {
        let loginView = LoginView(frame: .zero)
        return loginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginView.codeBlock = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.toCode()
            }
        }
        
        loginView.loginBlock = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.tologin()
            }
        }
        
        loginView.agreeBlock = { [weak self] in
            guard let self = self else { return }
        }
        
    }
    
    @MainActor
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
}

extension LoginViewController {
    
    private func toCode() async {
        let phone = self.loginView.phoneFiled.text ?? ""
        if phone.isEmpty {
            ToastManager.showMessage(message: LanguageManager.localizedString(for: "Please enter mobile phone number"))
            return
        }
        do {
            let json = ["sors": phone, "spirness": "1", "emness": "0"]
            let model = try await viewModel.codeInfo(json: json)
            if model.mountization == "0" {
                startCountDown()
                DispatchQueue.main.async {
                    self.loginView.codeFiled.becomeFirstResponder()
                }
            }
            ToastManager.showMessage(message: model.se ?? "")
        } catch {
            
        }
    }
    
    private func tologin() async {
        let phone = self.loginView.phoneFiled.text ?? ""
        let code = self.loginView.codeFiled.text ?? ""
        let isAgreeMent = self.loginView.sureBtn.isSelected
        if phone.isEmpty {
            ToastManager.showMessage(message: LanguageManager.localizedString(for: "Please enter mobile phone number"))
            return
        }
        if code.isEmpty {
            ToastManager.showMessage(message: LanguageManager.localizedString(for: "Please enter verification code"))
            return
        }
        if isAgreeMent == false {
            ToastManager.showMessage(message: LanguageManager.localizedString(for: "Please confirm and read the agreement"))
            return
        }
        do {
            let json = ["interency": phone,
                        "lenal": code,
                        "inproof": "1",
                        "pungsion": code]
            let model = try await viewModel.loginInfo(json: json)
            if model.mountization == "0" {
                let phone = model.hairship?.interency ?? ""
                let token = model.hairship?.cotylly ?? ""
                UserLoginConfig.saveUserInformation(phone: phone, token: token)
                DispatchQueue.main.async {
                    self.loginView.codeFiled.resignFirstResponder()
                    self.loginView.phoneFiled.resignFirstResponder()
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil
                        )
                    }
                }
            }
            ToastManager.showMessage(message: model.se ?? "")
        } catch {
            
        }
    }
    
}

extension LoginViewController {
    
    private func startCountDown() {
        countDown = 60
        loginView.codeBtn.isEnabled = false
        loginView.codeBtn.setTitle("\(countDown)s", for: .disabled)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateCountDown),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func updateCountDown() {
        countDown -= 1
        
        if countDown <= 0 {
            timer?.invalidate()
            timer = nil
            loginView.codeBtn.isEnabled = true
            loginView.codeBtn.setTitle(LanguageManager.localizedString(for: "Get Code"), for: .normal)
        } else {
            loginView.codeBtn.setTitle("\(countDown)s", for: .disabled)
        }
    }
}

