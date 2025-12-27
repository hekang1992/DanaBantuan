//
//  SettingViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import UIKit
import SnapKit
import TYAlertController

class SettingViewController: BaseViewController {
    
    private let viewModel = CenterViewModel()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "login_logo_image")
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = "Dana Bantuan"
        nameLabel.textColor = UIColor.init(hex: "#0A1121")
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return nameLabel
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 14
        whiteView.layer.masksToBounds = true
        return whiteView
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setTitle(LanguageManager.localizedString(for: "Cancel Account"), for: .normal)
        deleteBtn.setTitleColor(UIColor.init(hex: "#759199"), for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return deleteBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hex: "#759199")
        lineView.layer.cornerRadius = 2
        lineView.layer.masksToBounds = true
        return lineView
    }()
    
    lazy var oneView: SettingListView = {
        let oneView = SettingListView()
        oneView.rightImageView.isHidden = true
        oneView.rightLabel.isHidden = false
        oneView.rightLabel.text = "1.0.0"
        oneView.nameLabel.text = LanguageManager.localizedString(for: "Version")
        oneView.iconImageView.image = UIImage(named: "version_app_image")
        return oneView
    }()
    
    lazy var twoView: SettingListView = {
        let twoView = SettingListView()
        twoView.rightImageView.isHidden = false
        twoView.rightLabel.isHidden = true
        twoView.nameLabel.text = LanguageManager.localizedString(for: "Log Out")
        twoView.iconImageView.image = UIImage(named: "app_logout_bg_image")
        return twoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(headView)
        headView.configure(withTitle: LanguageManager.localizedString(for: "Set Up"))
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40.pix())
        }
        
        headView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        view.addSubview(logoImageView)
        view.addSubview(nameLabel)
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(30)
            make.width.height.equalTo(88)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(14)
            make.width.equalTo(200)
            make.height.equalTo(24)
        }
        
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(25)
            make.size.equalTo(CGSize(width: 335.pix(), height: 130))
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom).offset(50.pix())
            make.height.equalTo(18)
        }
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalTo(deleteBtn).inset(-0.5)
            make.bottom.equalTo(deleteBtn).offset(1)
            make.height.equalTo(1)
        }
        
        let isShow = LanguageManager.currentLanguage == .id
        
        [deleteBtn, lineView].forEach { $0.isHidden = isShow }
        
        
        whiteView.addSubview(oneView)
        whiteView.addSubview(twoView)
        oneView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(65)
        }
        twoView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(65)
        }
        
        deleteBtn.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
        
        tapClick()
    }
    
}

extension SettingViewController {
    
    private func tapClick() {
        twoView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            alertLogoutView()
        }
    }
    
    @objc func deleteBtnClick() {
        alertDeleteView()
    }
    
    /// logout_info
    private func alertLogoutView() {
        let popView = AppAlertLogoutView(frame: self.view.bounds)
        let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        popView.sureBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                Task {
                    await self.logoutInfo()
                }
            }
        }
    }
    
    /// delete_account_info
    private func alertDeleteView() {
        let popView = AppAlertDeleteView(frame: self.view.bounds)
        let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        popView.sureBlock = { [weak self] in
            guard let self = self else { return }
            if popView.sureBtn.isSelected == false {
                ToastManager.showMessage(message: "Please confirm the agreement")
                return
            }
            self.dismiss(animated: true) {
                Task {
                    await self.deleteInfo()
                }
            }
        }
    }
    
    private func logoutInfo() async {
        do {
            let json = ["nothfic": LanguageManager.currentLanguage.rawValue]
            let model = try await viewModel.logoutInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                UserLoginConfig.deleteUserInformation()
                self.changeRootVc()
            }
            ToastManager.showMessage(message: model.se ?? "")
        } catch {
        
        }
    }
    
    private func deleteInfo() async {
        do {
            let json = ["consumeraneous": LanguageManager.currentLanguage.rawValue]
            let model = try await viewModel.deleteInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                UserLoginConfig.deleteUserInformation()
                self.changeRootVc()
            }
            ToastManager.showMessage(message: model.se ?? "")
        } catch {
        
        }
    }
    
}
