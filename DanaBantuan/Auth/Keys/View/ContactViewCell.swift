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
    
    // MARK: - Public
    
    var model: clearficModel? {
        didSet { configModel() }
    }
    
    var tapClickBlock: (() -> Void)?
    var tapPhoneClickBlock: (() -> Void)?
    
    // MARK: - Private
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    
    private lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 14
        v.layer.masksToBounds = true
        return v
    }()
    
    private lazy var bgImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "cont_des_ed_image")
        return v
    }()
    
    private lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor(hex: "#0A1121")
        l.font = .systemFont(ofSize: 18, weight: .medium)
        return l
    }()
    
    private lazy var oneLabel = makeSubTitleLabel()
    private lazy var oneView = makeInputBgView()
    lazy var oneTextField = makeTextField()
    private lazy var oneArrow = makeArrowImageView()
    private lazy var oneButton = UIButton(type: .custom)
    
    private lazy var twoLabel = makeSubTitleLabel()
    private lazy var twoView = makeInputBgView()
    lazy var twoTextField = makeTextField()
    private lazy var twoArrow = makeArrowImageView()
    private lazy var twoButton = UIButton(type: .custom)
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        setupUI()
        setupConstraints()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup

private extension ContactViewCell {
    
    func setupUI() {
        
        contentView.addSubview(bgView)
        
        bgView.addSubview(bgImageView)
        bgView.addSubview(nameLabel)
        
        bgView.addSubview(oneLabel)
        bgView.addSubview(oneView)
        bgView.addSubview(oneButton)
        
        bgView.addSubview(twoLabel)
        bgView.addSubview(twoView)
        bgView.addSubview(twoButton)
        
        oneView.addSubview(oneTextField)
        oneView.addSubview(oneArrow)
        
        twoView.addSubview(twoTextField)
        twoView.addSubview(twoArrow)
    }
}

// MARK: - Constraints

private extension ContactViewCell {
    
    func setupConstraints() {
        
        bgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15.pix())
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 345.pix(), height: 257.pix()))
            $0.bottom.equalToSuperview()
        }
        
        bgImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20.pix())
            $0.left.equalToSuperview().offset(12.pix())
            $0.size.equalTo(CGSize(width: 188.pix(), height: 18.pix()))
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15.pix())
            $0.left.equalToSuperview().offset(12.pix())
            $0.height.equalTo(18.pix())
        }
        
        layoutInput(
            label: oneLabel,
            container: oneView,
            textField: oneTextField,
            arrow: oneArrow,
            topView: nameLabel
        )
        
        layoutInput(
            label: twoLabel,
            container: twoView,
            textField: twoTextField,
            arrow: twoArrow,
            topView: oneView
        )
        
        oneButton.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(oneView)
        }
        
        twoButton.snp.makeConstraints {
            $0.top.equalTo(oneView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(twoView)
        }
    }
    
    func layoutInput(
        label: UILabel,
        container: UIView,
        textField: UITextField,
        arrow: UIImageView,
        topView: UIView
    ) {
        
        label.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(20.pix())
            $0.left.equalToSuperview().inset(15.pix())
            $0.height.equalTo(15)
        }
        
        container.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(15.pix())
            $0.left.equalTo(nameLabel)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52.pix())
        }
        
        textField.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-30.pix())
        }
        
        arrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15.pix())
            $0.size.equalTo(CGSize(width: 10.pix(), height: 14.pix()))
        }
    }
}

// MARK: - Bind Actions

private extension ContactViewCell {
    
    func bindActions() {
        
        oneButton.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.tapClickBlock?()
            }
            .disposed(by: disposeBag)
        
        twoButton.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.tapPhoneClickBlock?()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Model

private extension ContactViewCell {
    
    func configModel() {
        guard let model else { return }
        nameLabel.text = model.futilition ?? ""
        oneLabel.text = model.lexular ?? ""
        twoLabel.text = model.authcontaino ?? ""
        oneTextField.placeholder = model.cubitude ?? ""
        twoTextField.placeholder = model.closdemocraticeous ?? ""
        
        let name = model.waitern ?? ""
        let phone = model.dreament ?? ""
        
        if name.isEmpty || phone.isEmpty {
            twoTextField.text = ""
        }else {
            twoTextField.text = String(format: "%@-%@", name, phone)
        }
        
        let managerness = model.managerness ?? ""
        let modelArray = model.logo ?? []
        for item in modelArray {
            let target = item.gymn ?? ""
            if managerness == target {
                oneTextField.text = item.waitern ?? ""
            }
        }
        
    }
}

// MARK: - Factory Methods

private extension ContactViewCell {
    
    func makeSubTitleLabel() -> UILabel {
        let l = UILabel()
        l.textColor = UIColor(hex: "#0A1121")
        l.font = .systemFont(ofSize: 14, weight: .medium)
        return l
    }
    
    func makeInputBgView() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#EFFAFE")
        v.layer.cornerRadius = 14
        v.layer.masksToBounds = true
        return v
    }
    
    func makeTextField() -> UITextField {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 14, weight: .medium)
        tf.textColor = UIColor(hex: "#0A1121")
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tf.leftViewMode = .always
        return tf
    }
    
    func makeArrowImageView() -> UIImageView {
        let iv = UIImageView()
        iv.image = UIImage(named: "right_icon_image")
        return iv
    }
}

