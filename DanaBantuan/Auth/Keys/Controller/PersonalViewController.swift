//
//  PersonalViewController.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/27.
//

import UIKit
import SnapKit
import TYAlertController
import Kingfisher
import RxSwift
import RxCocoa
import TYAlertController
import BRPickerView

class PersonalViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    var productID: String = ""
    
    var name: String = ""
    
    var orderID: String = ""
    
    private let viewModel = MainViewModel()
    
    private var modelArray = BehaviorRelay<[calidaireModel]>(value: [])
    
    private var locationTool: LocationTool?
    
    private var starttime: String = ""
    
    private let launchViewModel = LaunchViewModel()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.contentMode = .scaleAspectFit
        return headImageView
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 70
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TapClickViewCell.self, forCellReuseIdentifier: "TapClickViewCell")
        tableView.register(EnterTextViewCell.self, forCellReuseIdentifier: "EnterTextViewCell")
        tableView.layer.cornerRadius = 14
        tableView.layer.masksToBounds = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
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
        
        headImageView.image = languageCode == .id ? UIImage(named: "per_nor_id_image") : UIImage(named: "per_nor_en_image")
        
        view.addSubview(headImageView)
        headImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(345.pix())
            make.top.equalTo(headView.snp.bottom).offset(15.pix())
        }
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.size.equalTo(CGSize(width: 345.pix(), height: 54.pix()))
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(10.pix())
            make.centerX.equalToSuperview()
            make.width.equalTo(345.pix())
            make.bottom.equalTo(nextBtn.snp.top).offset(-10.pix())
        }
        
        nextBtn
            .rx
            .tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                var json = ["spatikin": productID]
                for model in modelArray.value {
                    let key = model.mountization ?? ""
                    let name = model.gymn ?? ""
                    json[key] = name
                }
                Task {
                    await self.saveUserInfo(with: json)
                }
            })
            .disposed(by: disposeBag)
        
        modelArray
            .asObservable()
            .bind(to: tableView.rx.items) { tableView, row, model in
                let fetfirmture = model.fetfirmture ?? ""
                let indexPath = IndexPath(row: row, section: 0)
                if fetfirmture == "personalty" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EnterTextViewCell", for: indexPath) as! EnterTextViewCell
                    cell.model = model
                    cell.phoneTextChanged = { name in
                        cell.phoneTextFiled.text = name
                        model.baseenne = name
                        model.gymn = name
                    }
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TapClickViewCell", for: indexPath) as! TapClickViewCell
                    cell.model = model
                    cell.tapClickBlock = { [weak self] in
                        guard let self = self else { return }
                        self.view.endEditing(true)
                        if fetfirmture == "anteitive" {
                            self.tapCityClickCell(with: model, selectCell: cell)
                        }else {
                            self.tapClickCell(with: model, selectCell: cell)
                        }
                    }
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        locationTool = LocationTool(presentingVC: self)
        locationTool?.startLocation { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                print("result====\(result)")
                Task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    AppLocationModel.shared.locationJson = result
                }
            } else {
                
            }
        }
        
        starttime = String(Date().timeIntervalSince1970)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            do {
                try? await Task.sleep(nanoseconds: 200_000_000)
                let json = ["spatikin": productID]
                let model = try await viewModel.userDetailInfo(json: json)
                if model.mountization == "0" || model.mountization == "00" {
                    let modelArray = model.hairship?.calidaire ?? []
                    self.modelArray.accept(modelArray)
                }else {
                    ToastManager.showMessage(message: model.mountization ?? "")
                }
            } catch {
                
            }
        }
    }
    
}

extension PersonalViewController {
    
    private func saveUserInfo(with json: [String: String]) async {
        do {
            let model = try await viewModel.saveUserDetailInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                Task {
                    await self.stayApp()
                    await self.getDetailInfo(with: productID)
                }
            }else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            
        }
    }
    
}

extension PersonalViewController {
    
    private func tapClickCell(with model: calidaireModel,
                              selectCell: TapClickViewCell) {
        
        let popView = AlertPopEnmuView(frame: view.bounds)
        popView.ttleLabel.text = model.jutcommonably ?? ""
        
        let modelArray = model.mal ?? []
        popView.modelArray = modelArray
        
        if let text = selectCell.phoneTextFiled.text,
           let selectedIndex = modelArray.firstIndex(where: { $0.waitern == text }) {
            popView.selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
        }
        
        let alertVC = TYAlertController(alert: popView, preferredStyle: .actionSheet)
        present(alertVC!, animated: true)
        
        popView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        popView.sureBlock = { [weak self] listModel in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                let value = listModel.waitern ?? ""
                selectCell.phoneTextFiled.text = value
                model.baseenne = value
                model.gymn = listModel.gymn ?? ""
            }
        }
    }
    
    private func tapCityClickCell(
        with model: calidaireModel,
        selectCell: TapClickViewCell
    ) {
        guard
            let cityModelArray = AppAddressCityModel.shared.modelArray,
            !cityModelArray.isEmpty
        else {
            return
        }
        
        let listArray = CityDecodeModel.getAddressModelArray(
            dataSourceArr: cityModelArray
        )
        
        let pickerView = BRTextPickerView()
        pickerView.pickerMode = .componentCascade
        pickerView.title = model.jutcommonably ?? ""
        pickerView.dataSourceArr = listArray
        pickerView.pickerStyle = makePickerStyle()
        
        pickerView.multiResultBlock = { models, _ in
            guard let models = models else { return }
            
            let selectText = models
                .compactMap { $0.text }
                .joined(separator: "-")
            
            selectCell.phoneTextFiled.text = selectText
            model.baseenne = selectText
            model.gymn = selectText
        }
        
        pickerView.show()
    }
    
    private func makePickerStyle() -> BRPickerStyle {
        let style = BRPickerStyle()
        style.rowHeight = 44
        style.language = "en"
        style.doneTextColor = UIColor(hex: "#1CC7EF")
        style.selectRowTextColor = UIColor(hex: "#1CC7EF")
        style.pickerTextFont = .systemFont(ofSize: 14, weight: .medium)
        style.selectRowTextFont = .systemFont(ofSize: 14, weight: .medium)
        return style
    }
    
}

extension PersonalViewController {
    
    private func stayApp() async {
        if LanguageManager.currentLanguage == .en {
            return
        }
        let locationJson = AppLocationModel.shared.locationJson ?? [:]
        let amward = locationJson["amward"] ?? ""
        let rhizeur = locationJson["rhizeur"] ?? ""
        do {
            let json = ["cupship": starttime,
                        "laud": String(Int(Date().timeIntervalSince1970)),
                        "amward": amward,
                        "rhizeur": rhizeur,
                        "recordage": "4",
                        "selenality": orderID,
                        "archaeoourster": productID]
            let _ = try await launchViewModel.uploadSnippetInfo(json: json)
        } catch {
            
        }
    }
    
}
