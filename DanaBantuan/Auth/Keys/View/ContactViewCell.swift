//
//  ContactViewCell.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ContactViewCell: UITableViewCell {
    
    var model: clearficModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.futilition ?? ""
            oneLabel.text = model.lexular ?? ""
            twoLabel.text = model.authcontaino ?? ""
            
            oneTextFiled.placeholder = model.cubitude ?? ""
            twoTextFiled.placeholder = model.closdemocraticeous ?? ""
        }
    }
    
    private let disposeBag = DisposeBag()
    
    var tapClickBlock: (() -> Void)?
    
    var tapPhoneClickBlock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 14
        bgView.layer.masksToBounds = true
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "cont_des_ed_image")
        return bgImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#0A1121")
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return nameLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#0A1121")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var oneView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(hex: "#EFFAFE")
        return view
    }()
    
    lazy var oneTextFiled: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.textColor = UIColor(hex: "#0A1121")
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        return textField
    }()
    
    lazy var oneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right_icon_image")
        return imageView
    }()
    
    lazy var twoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#0A1121")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var twoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(hex: "#EFFAFE")
        return view
    }()
    
    lazy var twoTextFiled: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.textColor = UIColor(hex: "#0A1121")
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        return textField
    }()
    
    lazy var twoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right_icon_image")
        return imageView
    }()
    
    lazy var oneClickBtn: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    lazy var twoClickBtn: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.addSubview(bgImageView)
        bgView.addSubview(nameLabel)
        
        bgView.addSubview(oneLabel)
        bgView.addSubview(oneView)
        oneView.addSubview(oneTextFiled)
        oneView.addSubview(oneImageView)
        bgView.addSubview(oneClickBtn)
        
        bgView.addSubview(twoLabel)
        bgView.addSubview(twoView)
        twoView.addSubview(twoTextFiled)
        twoView.addSubview(twoImageView)
        bgView.addSubview(twoClickBtn)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 345.pix(), height: 257.pix()))
            make.bottom.equalToSuperview()
        }
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.pix())
            make.left.equalToSuperview().offset(12.pix())
            make.size.equalTo(CGSize(width: 188.pix(), height: 18.pix()))
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.pix())
            make.left.equalToSuperview().offset(12.pix())
            make.height.equalTo(18.pix())
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20.pix())
            make.left.equalToSuperview().inset(15.pix())
            make.height.equalTo(15)
        }
        
        oneView.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(15.pix())
            make.left.equalTo(nameLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(52.pix())
        }
        
        oneTextFiled.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-30.pix())
        }
        
        oneImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15.pix())
            make.size.equalTo(CGSize(width: 10.pix(), height: 14.pix()))
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(20.pix())
            make.left.equalToSuperview().inset(15.pix())
            make.height.equalTo(15)
        }
        
        twoView.snp.makeConstraints { make in
            make.top.equalTo(twoLabel.snp.bottom).offset(15.pix())
            make.left.equalTo(nameLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(52.pix())
        }
        
        twoTextFiled.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-30.pix())
        }
        
        twoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15.pix())
            make.size.equalTo(CGSize(width: 10.pix(), height: 14.pix()))
        }
        
        oneClickBtn.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(oneView.snp.bottom)
        }
        
        twoClickBtn.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(twoView.snp.bottom)
        }
        
        oneClickBtn
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.tapClickBlock?()
            })
            .disposed(by: disposeBag)
        
        twoClickBtn
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.tapPhoneClickBlock?()
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
