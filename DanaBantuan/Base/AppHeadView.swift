//
//  AppHeadView.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AppHeadView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var tapClickBlock: (() -> Void)?
    
    private enum Constants {
        static let backButtonSize: CGFloat = 20
        static let backButtonLeftMargin: CGFloat = 20
        static let nameLabelWidth: CGFloat = 200
        static let nameLabelHeight: CGFloat = 20
        static let nameLabelFontSize: CGFloat = 16
        static let nameLabelTextColor = UIColor(hex: "#0A1121")
    }
    
    private lazy var bgView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back_left_icon_image"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.accessibilityIdentifier = "appHeadView_backButton"
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.nameLabelTextColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constants.nameLabelFontSize, weight: .medium)
        label.accessibilityIdentifier = "appHeadView_nameLabel"
        return label
    }()
    
    var title: String? {
        get { nameLabel.text }
        set { nameLabel.text = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(bgView)
        addSubview(backButton)
        addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.backButtonLeftMargin)
            make.size.equalTo(Constants.backButtonSize)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(
                width: Constants.nameLabelWidth,
                height: Constants.nameLabelHeight
            ))
        }
    }
    
    private func setupBindings() {
        backButton.rx.tap
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.tapClickBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    func configure(withTitle title: String?) {
        self.title = title
    }
    
    func setBackButtonHidden(_ hidden: Bool) {
        backButton.isHidden = hidden
    }
}

