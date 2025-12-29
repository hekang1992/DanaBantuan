//
//  AlertPopEnmuView.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import BRPickerView

class AlertPopEnmuView: UIView {
    
    var modelArray: [malModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedIndexPath: IndexPath?
    
    private let disposeBag = DisposeBag()
    
    var cancelBlock: (() -> Void)?
    
    var sureBlock: ((malModel) -> Void)?
    
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
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "c_cc_image"), for: .normal)
        cancelBtn.adjustsImageWhenHighlighted = false
        return cancelBtn
    }()
    
    lazy var ttleLabel: UILabel = {
        let ttleLabel = UILabel()
        ttleLabel.textAlignment = .center
        ttleLabel.textColor = UIColor(hex: "#0A1121")
        ttleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return ttleLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(bgImageView)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(ttleLabel)
        bgView.addSubview(nextBtn)
        
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
        cancelBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20.pix())
            make.width.height.equalTo(22.pix())
        }
        ttleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom)
            make.left.right.equalToSuperview().inset(25.pix())
            make.bottom.equalTo(nextBtn.snp.top).offset(-5.pix())
        }
        
        cancelBtn.rx.tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.cancelBlock?()
            })
            .disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                if let modelArray = modelArray, let selectedIndexPath = selectedIndexPath {
                    self.sureBlock?(modelArray[selectedIndexPath.row])
                }else {
                    ToastManager.showMessage(message: LanguageManager.localizedString(for: "Please select an option first"))
                }
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlertPopEnmuView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.pix()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let model = modelArray?[indexPath.row]
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.textLabel?.text = model?.waitern ?? ""
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        if selectedIndexPath == indexPath {
            cell.contentView.layer.cornerRadius = 14
            cell.contentView.layer.masksToBounds = true
            cell.contentView.backgroundColor = UIColor(hex: "#EFFAFE")
            cell.textLabel?.textColor = UIColor(hex: "#1CC7EF")
        } else {
            cell.contentView.backgroundColor = .clear
            cell.textLabel?.textColor = UIColor(hex: "#759199")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        tableView.reloadData()
    }
}
