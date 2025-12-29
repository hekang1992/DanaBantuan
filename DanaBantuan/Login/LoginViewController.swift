//
//  LoginViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit
import AppTrackingTransparency

class LoginViewController: BaseViewController {
    
    private var timer: Timer?
    
    private var countDown: Int = 60
    
    /// login_view_model
    private let viewModel = LoginViewModel()
    
    /// lanunch_view_model
    private let launchViewModel = LaunchViewModel()
    
//    private var locationTool: LocationTool?
    
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
            ToastManager.showMessage(message: "agreeBlock")
        }
        
//        locationTool = LocationTool(presentingVC: self)
//        locationTool?.startLocation { [weak self] result, error in
//            guard let self = self else { return }
//            if let result = result {
//                print("result====\(result)")
//                Task {
//                    try? await Task.sleep(nanoseconds: 3_000_000_000)
//                    await self.uploadLocationInfo(with: result)
//                }
//            } else {
//                print("error====\(error!)")
//            }
//            
//            DeviceInfoManager.shared.collect { json in
//                Task {
//                    do {
//                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
//                        let base64String = jsonData.base64EncodedString()
//                        let json = ["hairship": base64String]
//                        await self.uploadDeviceInfo(with: json)
//                    } catch {
//                        print("error：\(error)")
//                    }
//                }
//            }
//        }
        
        Task {
            await self.getAppIDFA()
        }
        
        StayPointConfig.saveStartInfo(start: String(Int(Date().timeIntervalSince1970)))
    }
    
    @MainActor
    deinit {
        timer?.invalidate()
        timer = nil
        print("LoginViewController====deinit======")
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
            if model.mountization == "0" || model.mountization == "00" {
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
        self.loginView.codeFiled.resignFirstResponder()
        self.loginView.phoneFiled.resignFirstResponder()
        StayPointConfig.saveLeaveInfo(leave: String(Int(Date().timeIntervalSince1970)))
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
            if model.mountization == "0" || model.mountization == "00" {
                let phone = model.hairship?.interency ?? ""
                let token = model.hairship?.cotylly ?? ""
                UserLoginConfig.saveUserInformation(phone: phone, token: token)
                self.changeRootVc()
            }
            ToastManager.showMessage(message: model.se ?? "")
        } catch {
            
        }
    }
    
//    private func uploadLocationInfo(with json: [String: String]) async {
//        do {
//            let _ = try await launchViewModel.uploadLocationinfo(json: json)
//        } catch {
//            
//        }
//    }
//    
//    private func uploadDeviceInfo(with json: [String: String]) async {
//        do {
//            let _ = try await launchViewModel.uploadDeviceinfo(json: json)
//        } catch {
//            
//        }
//    }
    
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

extension LoginViewController {
    
    private func getAppIDFA() async {
        guard #available(iOS 14, *) else { return }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        let status = await ATTrackingManager.requestTrackingAuthorization()
        
        switch status {
        case .authorized, .denied, .notDetermined:
            await uploadIDFAInfo()
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    private func uploadIDFAInfo() async {
        do {
            let tricesimacle = IDFVManager.shared.getIDFV()
            let militarylike = IDFAManager.shared.getCurrentIDFA()
            let json: [String: String] = [
                "tricesimacle": tricesimacle,
                "militarylike": militarylike
            ]
            let _ = try await launchViewModel.uploadIDFAinfo(json: json)
        } catch {
            print("uploadIDFAInfo error: \(error)")
        }
    }
    
}
