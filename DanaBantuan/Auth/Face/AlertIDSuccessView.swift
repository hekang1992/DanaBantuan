//
//  AlertIDSuccessView.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import BRPickerView

class AlertIDSuccessView: UIView {
    
    var model: BaseModel? {
        didSet {
            guard let model = model else { return }
            oneFiled.text = model.hairship?.waitern ?? ""
            twoFiled.text = model.hairship?.historyo ?? ""
            let day = model.hairship?.dow ?? ""
            let month = model.hairship?.haustly ?? ""
            let year = model.hairship?.landitor ?? ""
            
            if day.isEmpty || month.isEmpty || year.isEmpty {
                threeFiled.text = ""
            }else {
                threeFiled.text = String(format: "%@-%@-%@", day, month, year)
            }
            
        }
    }
    
    private let disposeBag = DisposeBag()
    
    var cancelBlock: (() -> Void)?
    
    var sureBlock: (() -> Void)?
    
    var selectTimeBlock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 24.pix()
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor(hex: "#FDFDF4")
        bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "hea_co_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.setTitle(LanguageManager.localizedString(for: "Confirming"), for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        nextBtn.setBackgroundImage(UIImage(named: "list_detai_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = LanguageManager.localizedString(for: "*Please check your lD information correctly, oncesubmitted it is not changed again")
        nameLabel.numberOfLines = 2
        nameLabel.textColor = UIColor.init(hex: "#EF5045")
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return nameLabel
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "c_cc_image"), for: .normal)
        cancelBtn.adjustsImageWhenHighlighted = false
        return cancelBtn
    }()
    
    lazy var ttleLabel: UILabel = {
        let ttleLabel = UILabel()
        ttleLabel.textAlignment = .center
        ttleLabel.text = LanguageManager.localizedString(for: "Confirm Information")
        ttleLabel.textColor = UIColor.init(hex: "#EF5045")
        ttleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return ttleLabel
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
    
    lazy var oneFiled: UITextField = {
        let oneFiled = UITextField()
        oneFiled.placeholder = LanguageManager.localizedString(for: "Real Name")
        oneFiled.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        oneFiled.textColor = UIColor.init(hex: "#0A1121")
        oneFiled.textAlignment = .right
        return oneFiled
    }()
    
    lazy var twoFiled: UITextField = {
        let twoFiled = UITextField()
        twoFiled.placeholder = LanguageManager.localizedString(for: "ID Number")
        twoFiled.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        twoFiled.textColor = UIColor.init(hex: "#0A1121")
        twoFiled.textAlignment = .right
        return twoFiled
    }()
    
    lazy var threeFiled: UITextField = {
        let threeFiled = UITextField()
        threeFiled.placeholder = LanguageManager.localizedString(for: "Birthday")
        threeFiled.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        threeFiled.textColor = UIColor.init(hex: "#0A1121")
        threeFiled.textAlignment = .right
        return threeFiled
    }()
    
    lazy var rightImagView: UIImageView = {
        let rightImagView = UIImageView()
        rightImagView.image = UIImage(named: "right_icon_image")
        return rightImagView
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        return clickBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(bgImageView)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(ttleLabel)
        bgView.addSubview(nextBtn)
        bgView.addSubview(nameLabel)
        bgView.addSubview(oneView)
        bgView.addSubview(twoView)
        bgView.addSubview(threeView)
        oneView.addSubview(oneLabel)
        twoView.addSubview(twoLabel)
        threeView.addSubview(threeLabel)
        
        oneView.addSubview(oneFiled)
        twoView.addSubview(twoFiled)
        threeView.addSubview(threeFiled)
        threeView.addSubview(rightImagView)
        threeView.addSubview(clickBtn)
        
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(432.pix())
        }
        bgImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50.pix())
        }
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.size.equalTo(CGSize(width: 345.pix(), height: 54.pix()))
        }
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextBtn.snp.top).offset(-10.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 36.pix()))
        }
        cancelBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20.pix())
            make.width.height.equalTo(22.pix())
        }
        ttleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
        
        oneView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(20.pix())
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
        
        oneFiled.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12.pix())
            make.left.equalTo(oneLabel.snp.right).offset(5.pix())
            make.height.equalTo(25.pix())
        }
        
        twoFiled.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12.pix())
            make.left.equalTo(oneLabel.snp.right).offset(5.pix())
            make.height.equalTo(25.pix())
        }
        
        rightImagView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12.pix())
            make.size.equalTo(CGSize(width: 10.pix(), height: 14.pix()))
            make.centerY.equalToSuperview()
        }
        
        threeFiled.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImagView.snp.left).offset(-10.pix())
            make.left.equalTo(oneLabel.snp.right).offset(5.pix())
            make.height.equalTo(25.pix())
        }
        
        clickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cancelBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.cancelBlock?()
            })
            .disposed(by: disposeBag)
        
        nextBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.sureBlock?()
            })
            .disposed(by: disposeBag)
        
        clickBtn
            .rx
            .tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                //                self.selectTimeBlock?()
                tapTimeClick(with: self.threeFiled.text ?? "")
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AlertIDSuccessView {
    
    private func tapTimeClick(with time: String?) {
        let datePickerView = createDatePickerView()
        datePickerView.selectDate = parseDate(from: time)
        datePickerView.pickerStyle = createPickerStyle()
        
        datePickerView.resultBlock = { [weak self] selectDate, selectValue in
            self?.handleDateSelection(selectDate)
        }
        
        datePickerView.show()
    }
    
    private func createDatePickerView() -> BRDatePickerView {
        let datePickerView = BRDatePickerView()
        datePickerView.pickerMode = .YMD
        datePickerView.title = LanguageManager.localizedString(for: "Select Date")
        return datePickerView
    }
    
    private func parseDate(from timeString: String?) -> Date {
        guard let timeString = timeString, !timeString.isEmpty else {
            return getDefaultDate()
        }
        
        let dateFormats = ["dd-MM-yyyy", "yyyy-MM-dd"]
        let dateFormatter = DateFormatter()
        
        for format in dateFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: timeString) {
                return date
            }
        }
        
        return getDefaultDate()
    }
    
    private func getDefaultDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: "11-11-2000") ?? Date()
    }
    
    private func createPickerStyle() -> BRPickerStyle {
        let customStyle = BRPickerStyle()
        customStyle.rowHeight = 44
        customStyle.language = "en"
        customStyle.doneBtnTitle = LanguageManager.localizedString(for: "OK")
        customStyle.cancelBtnTitle = LanguageManager.localizedString(for: "Cancel")
        customStyle.doneTextColor = UIColor(hex: "#1CC7EF")
        customStyle.selectRowTextColor = UIColor(hex: "#1CC7EF")
        customStyle.pickerTextFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        customStyle.selectRowTextFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        return customStyle
    }
    
    private func handleDateSelection(_ selectedDate: Date?) {
        guard let selectedDate = selectedDate else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let resultDateString = dateFormatter.string(from: selectedDate)
        
        threeFiled.text = resultDateString
    }
    
    
}
