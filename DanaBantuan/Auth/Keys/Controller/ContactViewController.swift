//
//  ContactViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/27.
//

import UIKit
import SnapKit
import TYAlertController
import Kingfisher
import RxSwift
import RxCocoa
import TYAlertController

class ContactViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    var productID: String = ""
    
    var name: String = ""
    
    var orderID: String = ""
    
    var dictArray: [[String: String]] = []
    
    private let viewModel = MainViewModel()
    
    private var modelArray = BehaviorRelay<[clearficModel]>(value: [])
    
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
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 70
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ContactViewCell.self, forCellReuseIdentifier: "ContactViewCell")
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
        
        nextBtn.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                guard let self = self else { return }
                
                dictArray = self.modelArray.value.map { model in
                    [
                        "dreament": model.dreament ?? "",
                        "waitern": model.waitern ?? "",
                        "managerness": model.managerness ?? "",
                        "roborexpertety": model.roborexpertety ?? ""
                    ]
                }
                Task {
                    await self.saveUserInfo(with: self.dictArray)
                }
            }
            .disposed(by: disposeBag)
        
        modelArray
            .asObservable()
            .bind(to: tableView.rx.items) { tableView, row, model in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactViewCell", for: indexPath) as! ContactViewCell
                cell.model = model
                cell.tapClickBlock = { [weak self] in
                    guard let self = self else { return }
                    self.tapClickCell(with: model, selectCell: cell)
                }
                cell.tapPhoneClickBlock = { [weak self] in
                    guard let self = self else { return }
                    ContactManager.shared.pickSingleContact(from: self) { result in
                        let name = result["waitern"] ?? ""
                        let phone = result["sors"] ?? ""
                        model.dreament = phone
                        model.waitern = name
                        cell.twoTextField.text = String(format: "%@-%@", name, phone)
                    }
                    ContactManager.shared.fetchAllContacts(from: self) { list in
                        if list.isEmpty {
                            return
                        }
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: list, options: [])
                            let base64String = jsonData.base64EncodedString()
                            Task {
                                do {
                                    let json = ["gymn": "3", "hairship": base64String]
                                    let _ = try await self.viewModel.uploadContactDetailInfo(json: json)
                                } catch {
                                    
                                }
                            }
                        } catch {
                            print("error：\(error)")
                        }
                    }
                    
                }
                return cell
            }
            .disposed(by: disposeBag)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            do {
                let json = ["spatikin": productID]
                let model = try await viewModel.userContactDetailInfo(json: json)
                if model.mountization == "0" || model.mountization == "00" {
                    let modelArray = model.hairship?.terg?.clearfic ?? []
                    self.modelArray.accept(modelArray)
                }else {
                    ToastManager.showMessage(message: model.mountization ?? "")
                }
            } catch {
                
            }
        }
    }
    
}

extension ContactViewController {
    
    private func saveUserInfo(with jsonArray: [[String: String]]) async {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("Failed JSON serialization")
            return
        }
        
        let params: [String: String] = [
            "spatikin": productID,
            "hairship": jsonString
        ]
        
        do {
            let model = try await viewModel.saveUserContactDetailInfo(json: params)
            
            if model.mountization == "0" || model.mountization == "00" {
                await getDetailInfo(with: productID)
            } else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            print("saveUserInfo error: \(error)")
        }
    }
    
}

extension ContactViewController {
    
    private func tapClickCell(with model: clearficModel,
                              selectCell: ContactViewCell) {
        
        let popView = AlertPopEnmuView(frame: view.bounds)
        popView.ttleLabel.text = model.lexular ?? ""
        
        let modelArray = model.logo ?? []
        popView.modelArray = modelArray
        
        if let text = selectCell.oneTextField.text,
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
                selectCell.oneTextField.text = value
                model.managerness = listModel.gymn ?? ""
            }
        }
    }
    
    
}
