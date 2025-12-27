//
//  CompleteListView.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CompleteListView: UIView {
    
    var tapClickBlock: (() -> Void)?
    
    let disposeBag = DisposeBag()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 22.pix()
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hex: "#EFFAFE")
        return bgView
    }()
    
    lazy var authImageView: UIImageView = {
        let authImageView = UIImageView()
        authImageView.image = UIImage(named: "auth_come_w_image")
        authImageView.isHidden = true
        return authImageView
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .left
        numLabel.textColor = UIColor.init(hex: "#759199")
        numLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return numLabel
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#96EF24")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return nameLabel
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "right_icon_image")
        return rightImageView
    }()
    
    lazy var tapBtn: UIButton = {
        let tapBtn = UIButton(type: .custom)
        return tapBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(authImageView)
        addSubview(tapBtn)
        bgView.addSubview(numLabel)
        bgView.addSubview(iconImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(rightImageView)
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(34.pix())
            make.height.equalTo(48.pix())
        }
        authImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-36.pix())
            make.top.equalToSuperview().offset(20.pix())
            make.width.height.equalTo(34.pix())
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15.pix())
            make.size.equalTo(CGSize(width: 20.pix(), height: 14.pix()))
        }
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(numLabel.snp.right).offset(5.pix())
            make.width.height.equalTo(28.pix())
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(10.pix())
            make.height.equalTo(20.pix())
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 10.pix(), height: 14.pix()))
        }
        tapBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapBtn
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.tapClickBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
