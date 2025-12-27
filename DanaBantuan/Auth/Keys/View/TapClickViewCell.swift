//
//  TapClickViewCell.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TapClickViewCell: UITableViewCell {
    
    var model: calidaireModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.jutcommonably ?? ""
            phoneTextFiled.placeholder = model.bariics ?? ""
            
            let down = model.down ?? ""
            phoneTextFiled.keyboardType = down == "1" ? .numberPad : .default
        }
    }
    
    // MARK: - Public
    var tapClickBlock: (() -> Void)?
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#0A1121")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(hex: "#EFFAFE")
        return view
    }()
    
    /// ⚠️ 保持原命名，避免外部引用受影响
    lazy var phoneTextFiled: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.textColor = UIColor(hex: "#0A1121")
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        return textField
    }()
    
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right_icon_image")
        return imageView
    }()
    
    lazy var tapClickBtn: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension TapClickViewCell {
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(bgView)
        contentView.addSubview(tapClickBtn)
        
        bgView.addSubview(phoneTextFiled)
        bgView.addSubview(bgImageView)
    }
    
    func setupLayout() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.pix())
            make.left.equalToSuperview().inset(15.pix())
            make.height.equalTo(15)
        }
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10.pix())
            make.left.equalTo(nameLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(52.pix())
            make.bottom.equalToSuperview().offset(-5.pix())
        }
        
        phoneTextFiled.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-30.pix())
        }
        
        bgImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15.pix())
            make.size.equalTo(CGSize(width: 10.pix(), height: 14.pix()))
        }
        
        tapClickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindActions() {
        tapClickBtn
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.tapClickBlock?()
            }
            .disposed(by: disposeBag)
    }
}
