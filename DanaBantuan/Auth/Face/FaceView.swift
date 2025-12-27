//
//  FaceView.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FaceView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var clickTapBlock: (() -> Void)?
    
    var nextClickBlock: (() -> Void)?
    
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
        nextBtn.setTitle(LanguageManager.localizedString(for: "Next Step"), for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        nextBtn.setBackgroundImage(UIImage(named: "list_detai_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        return headImageView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 14.pix()
        whiteView.layer.masksToBounds = true
        return whiteView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        return oneImageView
    }()
    
    lazy var coeView: UIView = {
        let coeView = UIView()
        coeView.backgroundColor = UIColor.init(hex: "#EFFAFE")
        coeView.layer.cornerRadius = 22
        coeView.layer.masksToBounds = true
        return coeView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = UIImage(named: "came_adc_a_image")
        return threeImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = LanguageManager.localizedString(for: "Click to upload")
        nameLabel.textColor = UIColor.init(hex: "#0A1121")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return nameLabel
    }()
    
    lazy var footImageView: UIImageView = {
        let footImageView = UIImageView()
        return footImageView
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        return clickBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nextBtn)
        addSubview(scrollView)
        scrollView.addSubview(headImageView)
        scrollView.addSubview(whiteView)
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10.pix())
            make.size.equalTo(CGSize(width: 345.pix(), height: 54.pix()))
            make.centerX.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5.pix())
        }
        headImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.pix())
            make.centerX.equalToSuperview()
            make.width.equalTo(345.pix())
        }
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(15.pix())
            make.size.equalTo(CGSize(width: 345.pix(), height: 429.pix()))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.pix())
        }
        
        whiteView.addSubview(oneImageView)
        whiteView.addSubview(coeView)
        coeView.addSubview(twoImageView)
        coeView.addSubview(threeImageView)
        coeView.addSubview(nameLabel)
        whiteView.addSubview(footImageView)
        
        oneImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20.pix())
            make.height.equalTo(23.pix())
        }
        coeView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(13.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 297.pix(), height: 235.pix()))
        }
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24.pix())
            make.size.equalTo(CGSize(width: 252.pix(), height: 160.pix()))
        }
        threeImageView.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.width.height.equalTo(44.pix())
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(twoImageView.snp.bottom).offset(15.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(16.pix())
        }
        footImageView.snp.makeConstraints { make in
            make.top.equalTo(coeView.snp.bottom).offset(15.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 301.pix(), height: 103.pix()))
        }
        
        whiteView.addSubview(clickBtn)
        clickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        clickBtn
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.clickTapBlock?()
            })
            .disposed(by: disposeBag)
        
        nextBtn
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.nextClickBlock?()
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
