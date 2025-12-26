//
//  ProductViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import UIKit
import SnapKit

class ProductViewController: BaseViewController {
    
    var productID: String = ""
    
    private let viewModel = ProductViewModel()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        nextBtn.setBackgroundImage(UIImage(named: "list_detai_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
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
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40.pix())
        }
        
        headView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        let headImageView = UIImageView()
        let languageCode = LanguageManager.currentLanguage
        headImageView.image = languageCode == .id ? UIImage(named: "id_pro_li_image") : UIImage(named: "en_pro_li_image")
        view.addSubview(headImageView)
        headImageView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 60.pix()))
        }
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.size.equalTo(CGSizeMake(345.pix(), 54.pix()))
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(nextBtn.snp.top).offset(-10.pix())
        }
        
        let authImageView = UIImageView()
        authImageView.image = UIImage(named: "lis_app_auth_image")
        scrollView.addSubview(authImageView)
        authImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 354.pix(), height: 610.pix()))
            make.bottom.equalToSuperview().offset(-10.pix())
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getProductDetailInfo()
        }
    }
    
}

extension ProductViewController {
    
    private func getProductDetailInfo() async {
        do {
            let json = ["spatikin": productID,
                        "preventitude": String(Int(1))
            ]
            let model = try await viewModel.productDetailInfo(json: json)
            if model.mountization == "0" {
                self.headView.configure(withTitle: model.hairship?.section?.tic ?? "")
                self.nextBtn.setTitle(model.hairship?.section?.penoern ?? "", for: .normal)
            }
        } catch {
            
        }
    }
    
}
