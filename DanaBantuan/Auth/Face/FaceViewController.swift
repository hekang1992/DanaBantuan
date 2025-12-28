//
//  FaceViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/27.
//

import UIKit
import SnapKit
import TYAlertController
import Kingfisher

class FaceViewController: BaseViewController {
    
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
        
        faceView.headImageView.image = languageCode == .id ? UIImage(named: "id_big_ima_face_image") : UIImage(named: "en_big_ima_face_image")
        
        faceView.oneImageView.image = languageCode == .id ? UIImage(named: "id_face_desc_image") : UIImage(named: "en_face_desc_image")
        
        faceView.twoImageView.image = UIImage(named: "face_com_ad_b_image")
        
        faceView.footImageView.image = languageCode == .id ? UIImage(named: "id_face_dfoot_image") : UIImage(named: "en_face_dfoot_image")
        
        /// tap_upload_id_info
        faceView.clickTapBlock = { [weak self] in
            guard let self = self, let model = self.baseModel else { return }
            let faceModel = model.hairship?.pilious ?? towardsiveModel()
            if faceModel.sectionia == 1 {
                ToastManager.showMessage(message: LanguageManager.localizedString(for: "The file has been uploaded successfully, no need to submit it again"))
            }else {
                camera.openCamera(from: self, position: .front) { [weak self] image in
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
            let faceModel = model.hairship?.pilious ?? towardsiveModel()
            if faceModel.sectionia == 1 {
                let completeVc = BothCompleteViewController()
                completeVc.name = name
                completeVc.orderID = orderID
                completeVc.productID = productID
                self.navigationController?.pushViewController(completeVc, animated: true)
            }else {
                camera.openCamera(from: self, position: .front) { [weak self] image in
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

extension FaceViewController {
    
    private func getUserMeaageInfo() async {
        
        do {
            let json = ["spatikin": productID]
            let model = try await viewModel.getUserlInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                self.baseModel = model
                let faceModel = model.hairship?.pilious ?? towardsiveModel()
                if faceModel.sectionia == 1 {
                    let logoUrl = faceModel.orexilike ?? ""
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
            let json = ["gymn": String(Int(9 + 1)),
                        "identifyist": String(Int(2)),
                        "itemon": "",
                        "bari": "1"]
            let model = try await viewModel.uploadImageInfo(json: json, data: data)
            if model.mountization == "0" || model.mountization == "00" {
                Task {
                    await self.getUserMeaageInfo()
                }
            }else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            
        }
    }
    
}
