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
            startCountDown()
        }
        
        loginView.loginBlock = { [weak self] in
            guard let self = self else { return }
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
