//
//  EnterTextViewCell.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class EnterTextViewCell: UITableViewCell {
    
    var model: calidaireModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.jutcommonably ?? ""
            phoneTextFiled.placeholder = model.bariics ?? ""
            
            let down = model.down ?? ""
            phoneTextFiled.keyboardType = down == "1" ? .numberPad : .default
            
            phoneTextFiled.text = model.baseenne ?? ""
        }
    }
    
    var phoneTextChanged: ((String?) -> Void)?
    
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
    
    lazy var phoneTextFiled: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.textColor = UIColor(hex: "#0A1121")
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        return textField
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension EnterTextViewCell {
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(phoneTextFiled)
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
        
        phoneTextFiled
            .rx
            .text
            .subscribe(onNext: { [weak self] text in
                self?.phoneTextChanged?(text)
            })
            .disposed(by: disposeBag)
        
    }
}

