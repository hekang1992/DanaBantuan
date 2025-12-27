//
//  FaceViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/27.
//

import UIKit
import SnapKit

class FaceViewController: BaseViewController {
    
    var productID: String = ""
    
    var name: String = ""
    
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
        
        faceView.headImageView.image = languageCode == .id ? UIImage(named: "id_big_ima_face_image") : UIImage(named: "en_big_ima_face_image")
        
        faceView.oneImageView.image = languageCode == .id ? UIImage(named: "id_face_desc_image") : UIImage(named: "en_face_desc_image")
        
        faceView.twoImageView.image = UIImage(named: "face_com_ad_b_image")
        
        faceView.footImageView.image = languageCode == .id ? UIImage(named: "id_face_dfoot_image") : UIImage(named: "en_face_dfoot_image")
        
    }

}
