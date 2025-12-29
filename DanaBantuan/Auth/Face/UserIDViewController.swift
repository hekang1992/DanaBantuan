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
    
    private var locationTool: LocationTool?
    
    private var starttime: String = ""
    
    private let launchViewModel = LaunchViewModel()
    
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
            let stayView = AppAlertStayView(frame: self.view.bounds)
            let alertVc = TYAlertController(alert: stayView, preferredStyle: .alert)
            self.present(alertVc!, animated: true)
            
            stayView.cancelBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            
            stayView.sureBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.backProductPageVc()
                }
            }
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
        
        locationTool = LocationTool(presentingVC: self)
        locationTool?.startLocation { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                print("result====\(result)")
                Task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    AppLocationModel.shared.locationJson = result
                }
            } else {
                
            }
        }
        
        starttime = String(Int(Date().timeIntervalSince1970))
        
        Task {
            await self.getUserMeaageInfo()
        }
        
    }
    
}

extension UserIDViewController {
    
    private func getUserMeaageInfo() async {
        try? await Task.sleep(nanoseconds: 200_000_000)
        do {
            let json = ["spatikin": productID]
            let model = try await viewModel.getUserlInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
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
            if model.mountization == "0" || model.mountization == "00" {
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
            if model.mountization == "0" || model.mountization == "00" {
                self.dismiss(animated: true) {
                    Task {
                        await self.stayApp()
                        await self.getUserMeaageInfo()
                    }
                }
            }else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            
        }
    }
    
    private func stayApp() async {
        let locationJson = AppLocationModel.shared.locationJson ?? [:]
        let amward = locationJson["amward"] ?? ""
        let rhizeur = locationJson["rhizeur"] ?? ""
        do {
            let json = ["cupship": starttime,
                        "laud": String(Int(Date().timeIntervalSince1970)),
                        "amward": amward,
                        "rhizeur": rhizeur,
                        "recordage": "2",
                        "selenality": orderID,
                        "archaeoourster": productID]
            let _ = try await launchViewModel.uploadSnippetInfo(json: json)
        } catch {
            
        }
    }
    
}
