//
//  BothCompleteViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/27.
//

import UIKit
import SnapKit
import TYAlertController
import Kingfisher
import RxSwift
import RxCocoa

class BothCompleteViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    var productID: String = ""
    
    var name: String = ""
    
    var orderID: String = ""
    
    var baseModel: BaseModel?
    
    private let viewModel = ProductViewModel()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        return headImageView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 24.pix()
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor(hex: "#FDFDF4")
        return bgView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.setTitle(LanguageManager.localizedString(for: "OK"), for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        nextBtn.setBackgroundImage(UIImage(named: "list_detai_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.layer.cornerRadius = 14
        oneView.layer.masksToBounds = true
        oneView.backgroundColor = UIColor(hex: "#EFFAFE")
        return oneView
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.layer.cornerRadius = 14
        twoView.layer.masksToBounds = true
        twoView.backgroundColor = UIColor(hex: "#EFFAFE")
        return twoView
    }()
    
    lazy var threeView: UIView = {
        let threeView = UIView()
        threeView.layer.cornerRadius = 14
        threeView.layer.masksToBounds = true
        threeView.backgroundColor = UIColor(hex: "#EFFAFE")
        return threeView
    }()
    
    lazy var oneLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = LanguageManager.localizedString(for: "Real Name")
        nameLabel.textColor = UIColor.init(hex: "#759199")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return nameLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.text = LanguageManager.localizedString(for: "ID Number")
        twoLabel.textColor = UIColor.init(hex: "#759199")
        twoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return twoLabel
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.textAlignment = .left
        threeLabel.text = LanguageManager.localizedString(for: "Birthday")
        threeLabel.textColor = UIColor.init(hex: "#759199")
        threeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return threeLabel
    }()
    
    lazy var oneNameLabel: UILabel = {
        let oneNameLabel = UILabel()
        oneNameLabel.numberOfLines = 0
        oneNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        oneNameLabel.textColor = UIColor.init(hex: "#0A1121")
        oneNameLabel.textAlignment = .right
        oneNameLabel.text = LanguageManager.localizedString(for: "Real Name")
        oneNameLabel.textColor = UIColor(hex: "#759199")
        return oneNameLabel
    }()
    
    lazy var twoFiled: UITextField = {
        let twoFiled = UITextField()
        twoFiled.placeholder = LanguageManager.localizedString(for: "ID Number")
        twoFiled.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        twoFiled.textColor = UIColor.init(hex: "#0A1121")
        twoFiled.textAlignment = .right
        twoFiled.isEnabled = false
        return twoFiled
    }()
    
    lazy var threeFiled: UITextField = {
        let threeFiled = UITextField()
        threeFiled.placeholder = LanguageManager.localizedString(for: "Birthday")
        threeFiled.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        threeFiled.textColor = UIColor.init(hex: "#0A1121")
        threeFiled.textAlignment = .right
        threeFiled.isEnabled = false
        return threeFiled
    }()
    
    lazy var typeImageView: UIImageView = {
        let typeImageView = UIImageView()
        typeImageView.contentMode = .scaleAspectFit
        return typeImageView
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
        
        let languageCode = LanguageManager.currentLanguage
        
        headImageView.image = languageCode == .id ? UIImage(named: "com_both_id_image") : UIImage(named: "com_both_en_image")
        typeImageView.image = languageCode == .id ? UIImage(named: "com_desc_id_image") : UIImage(named: "com_desc_en_image")
        
        view.addSubview(headImageView)
        headImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(15.pix())
        }
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.size.equalTo(CGSize(width: 345.pix(), height: 54.pix()))
        }
        
        view.addSubview(bgView)
        bgView.addSubview(typeImageView)
        bgView.addSubview(oneView)
        bgView.addSubview(twoView)
        bgView.addSubview(threeView)
        oneView.addSubview(oneLabel)
        twoView.addSubview(twoLabel)
        threeView.addSubview(threeLabel)
        
        oneView.addSubview(oneNameLabel)
        twoView.addSubview(twoFiled)
        threeView.addSubview(threeFiled)
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(13.pix())
            make.left.right.equalToSuperview().inset(15.pix())
            make.height.equalTo(282.pix())
        }
        typeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.pix())
            make.left.equalToSuperview().offset(17.pix())
            make.height.equalTo(23.pix())
        }
        
        oneView.snp.makeConstraints { make in
            make.top.equalTo(typeImageView.snp.bottom).offset(17.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 54.pix()))
        }
        
        twoView.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(20.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 54.pix()))
        }
        
        threeView.snp.makeConstraints { make in
            make.top.equalTo(twoView.snp.bottom).offset(20.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 54.pix()))
        }
        
        oneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12.pix())
            make.width.equalTo(120)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12.pix())
            make.width.equalTo(90)
        }
        
        threeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12.pix())
            make.width.equalTo(90)
        }
        
        oneNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12.pix())
            make.left.equalTo(oneLabel.snp.right).offset(5.pix())
            
        }
        
        twoFiled.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12.pix())
            make.left.equalTo(oneLabel.snp.right).offset(5.pix())
            make.height.equalTo(25.pix())
        }
        
        threeFiled.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12.pix())
            make.left.equalTo(oneLabel.snp.right).offset(5.pix())
            make.height.equalTo(25.pix())
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            await self.getUserMeaageInfo()
        }
        
        nextBtn
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                Task {
                    await self.getDetailInfo(with: self.productID)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}

extension BothCompleteViewController {
    
    private func getUserMeaageInfo() async {
        
        do {
            let json = ["spatikin": productID]
            let model = try await viewModel.getUserlInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                self.oneNameLabel.textColor = UIColor(hex: "#0A1121")
                self.oneNameLabel.text = model.hairship?.towardsive?.ethm?.waitern ?? ""
                self.twoFiled.text = model.hairship?.towardsive?.ethm?.historyo ?? ""
                self.threeFiled.text = model.hairship?.towardsive?.ethm?.processal ?? ""
            }else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            
        }
        
    }
    
}
