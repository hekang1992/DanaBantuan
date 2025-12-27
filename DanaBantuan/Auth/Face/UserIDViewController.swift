//
//  UserIDViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/27.
//

import UIKit
import SnapKit
import TYAlertController
import Kingfisher

class UserIDViewController: BaseViewController {
    
    var productID: String = ""
    
    var name: String = ""
    
    var orderID: String = ""
    
    var baseModel: BaseModel?
    
    private let viewModel = ProductViewModel()
    
    private let camera = CameraOnlyManager()
    
    lazy var faceView: FaceView = {
        let faceView = FaceView(frame: .zero)
        return faceView
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
        headView.configure(withTitle: name)
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40.pix())
        }
        
        headView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            self.backProductPageVc()
        }
        
        view.addSubview(faceView)
        faceView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5.pix())
            make.left.right.bottom.equalToSuperview()
        }
        
        let languageCode = LanguageManager.currentLanguage
        
        faceView.headImageView.image = languageCode == .id ? UIImage(named: "id_big_ima_image") : UIImage(named: "en_big_ima_image")
        
        faceView.oneImageView.image = languageCode == .id ? UIImage(named: "left_id_b_image") : UIImage(named: "left_en_b_image")
        
        faceView.twoImageView.image = UIImage(named: "all_cd_ad_image")
        
        faceView.footImageView.image = languageCode == .id ? UIImage(named: "left_id_fot_image") : UIImage(named: "left_en_fot_image")
        
        /// tap_upload_id_info
        faceView.clickTapBlock = { [weak self] in
            guard let self = self, let model = self.baseModel else { return }
            let idModel = model.hairship?.towardsive ?? towardsiveModel()
            if idModel.sectionia == 1 {
                ToastManager.showMessage(message: LanguageManager.localizedString(for: "The file has been uploaded successfully, no need to submit it again"))
            }else {
                camera.openCamera(from: self, position: .back) { [weak self] image in
                    guard let self = self else { return }
                    let data = image.jpegData(compressionQuality: 0.3)!
                    Task {
                        await self.uploadImageInfo(with: data)
                    }
                }
            }
        }
        
        /// next_upload_id_info
        faceView.nextClickBlock = { [weak self] in
            guard let self = self, let model = self.baseModel else { return }
            let idModel = model.hairship?.towardsive ?? towardsiveModel()
            if idModel.sectionia == 1 {
                let faceVc = FaceViewController()
                faceVc.name = name
                faceVc.orderID = orderID
                faceVc.productID = productID
                self.navigationController?.pushViewController(faceVc, animated: true)
            }else {
                camera.openCamera(from: self, position: .back) { [weak self] image in
                    guard let self = self else { return }
                    let data = image.jpegData(compressionQuality: 0.3)!
                    Task {
                        await self.uploadImageInfo(with: data)
                    }
                }
            }
        }
        
        Task {
            await self.getUserMeaageInfo()
        }
        
    }
    
}

extension UserIDViewController {
    
    private func getUserMeaageInfo() async {
        
        do {
            let json = ["spatikin": productID]
            let model = try await viewModel.getUserlInfo(json: json)
            if model.mountization == "0" {
                self.baseModel = model
                let idModel = model.hairship?.towardsive ?? towardsiveModel()
                if idModel.sectionia == 1 {
                    let logoUrl = idModel.orexilike ?? ""
                    self.faceView.twoImageView.kf.setImage(with: URL(string: logoUrl))
                }
            }else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            
        }
        
    }
    
    private func uploadImageInfo(with data: Data) async {
        do {
            let json = ["gymn": String(Int(9 + 2)),
                        "identifyist": String(Int(2)),
                        "itemon": "",
                        "bari": "1"]
            let model = try await viewModel.uploadImageInfo(json: json, data: data)
            if model.mountization == "0" {
                self.popAlertView(with: model)
            }else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            
        }
    }
    
    private func popAlertView(with model: BaseModel) {
        let popView = AlertIDSuccessView(frame: self.view.bounds)
        popView.model = model
        let alertVc = TYAlertController(alert: popView, preferredStyle: .actionSheet)
        self.present(alertVc!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        popView.sureBlock = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.saveUserInfo(with: popView)
            }
        }
    }
    
    private func saveUserInfo(with listView: AlertIDSuccessView) async {
        let name = listView.oneFiled.text ?? ""
        let num = listView.twoFiled.text ?? ""
        let time = listView.threeFiled.text ?? ""
        do {
            let json = ["waitern": name,
                        "historyo": num,
                        "processal": time,
                        "last": orderID,
                        "spatikin": productID,
                        "dreament": UserLoginConfig.phone ?? ""]
            let model = try await viewModel.saveUserlInfo(json: json)
            if model.mountization == "0" {
                self.dismiss(animated: true) {
                    Task {
                        await self.getUserMeaageInfo()
                    }
                }
            }
            ToastManager.showMessage(message: model.se ?? "")
        } catch {
            
        }
    }
    
}
