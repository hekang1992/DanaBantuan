//
//  HomeViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit
import MJRefresh
import CoreLocation

class HomeViewController: BaseViewController {
    
    private let viewModel = HomeViewModel()
    
    private var baseModel: BaseModel?
    
    private let launchViewModel = LaunchViewModel()
    
    private var locationTool: LocationTool?
    
    lazy var oneView: AppOneView = {
        let oneView = AppOneView(frame: .zero)
        oneView.isHidden = true
        return oneView
    }()
    
    lazy var softView: AppSoftView = {
        let softView = AppSoftView(frame: .zero)
        softView.isHidden = true
        return softView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(softView)
        softView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.oneView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.homeInfo()
            }
        })
        
        self.softView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.homeInfo()
            }
        })
        
        self.oneView.applyBlock = { [weak self] model in
            guard let self = self else { return }
            Task {
                await self.applyProduct(with: model)
            }
        }
        
        self.softView.tapClickBlock = { [weak self] model in
            guard let self = self else { return }
            Task {
                await self.applyProduct(with: model)
            }
        }
        
        self.softView.tapBannerClickBlock = { [weak self] model in
            guard let self = self else { return }
            let pageUrl = model.orexilike ?? ""
            if pageUrl.hasPrefix(SchemeApiUrl.scheme_url) {
                URLSchemeParsable.handleSchemeRoute(pageUrl: pageUrl, from: self)
            } else {
                if pageUrl.isEmpty {
                    return
                }
                self.goWebVc(with: pageUrl)
            }
        }
        
        Task {
            do {
                let model = try await viewModel.getAddresslInfo()
                if model.mountization == "0" || model.mountization == "00" {
                    AppAddressCityModel.shared.modelArray = model.hairship?.clearfic ?? []
                }
            } catch {
                
            }
        }
        
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
                print("error====\(error!)")
                if UserLoginConfig.isLoggedIn && LanguageManager.currentLanguage == .id {
                    showSettingAlert()
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.homeInfo()
        }
    }
    
}

extension HomeViewController {
    
    private func showSettingAlert() {
        
        let alert = UIAlertController(
            title: "定位权限未开启",
            message: "请在系统设置中开启定位权限",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        self.present(alert, animated: true)
    }
    
    private func homeInfo() async {
        do {
            let json = ["se": "1"]
            let model = try await viewModel.homeInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                self.baseModel = model
                let modelArray = model.hairship?.clearfic ?? []
                let pulmonainItems = modelArray.filter { $0.gymn == "pulmonain" }
                
                if !pulmonainItems.isEmpty {
                    for item in pulmonainItems {
                        oneViewModel(with: item.haveion?.first ?? haveionModel())
                    }
                } else {
                    softViewModel(with: modelArray)
                }
            }
            
            await MainActor.run {
                self.oneView.scrollView.mj_header?.endRefreshing()
                self.softView.tableView.mj_header?.endRefreshing()
            }
        } catch {
            await MainActor.run {
                self.oneView.scrollView.mj_header?.endRefreshing()
                self.softView.tableView.mj_header?.endRefreshing()
            }
        }
    }
    
}

extension HomeViewController {
    
    private func oneViewModel(with model: haveionModel) {
        self.oneView.model = model
        self.oneView.isHidden = false
        self.softView.isHidden = true
    }
    
    private func softViewModel(with modelArray: [clearficModel]) {
        self.softView.modelArray = modelArray
        self.oneView.isHidden = true
        self.softView.isHidden = false
    }
    
    private func applyProduct(with model: haveionModel) async {
        
        if LanguageManager.currentLanguage == .id {
            let status = CLLocationManager().authorizationStatus
            if status != .authorizedAlways && status != .authorizedWhenInUse  {
                self.showSettingAlert()
                return
            }
        }
        
        if LanguageManager.currentLanguage == .id {
            Task {
                await self.clickHomeProductInfo()
            }
        }
        
        let productID = String(model.cunely ?? 0)
        
        let json = [
            "quintarian": "1001",
            "vigenclearlyence": "1000",
            "windowship": "1000",
            "spatikin": productID,
            "susment": "1001"
        ]
        
        do {
            let model = try await viewModel.applyProductInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                let pageUrl = model.hairship?.orexilike ?? ""
                if pageUrl.hasPrefix(SchemeApiUrl.scheme_url) {
                    URLSchemeParsable.handleSchemeRoute(pageUrl: pageUrl, from: self)
                } else {
                    if pageUrl.isEmpty {
                        return
                    }
                    self.goWebVc(with: pageUrl)
                }
            } else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            
        }
    }
    
}

extension HomeViewController {
    
    private func clickHomeProductInfo() async {
        Task.detached {
            await self.stayApp()
        }
        
        Task.detached {
            let locationJson = await AppLocationModel.shared.locationJson ?? [:]
            await self.uploadLocationInfo(with: locationJson)
        }
        
        DeviceInfoManager.shared.collect { json in
            Task.detached {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let base64String = jsonData.base64EncodedString()
                    let json = ["hairship": base64String]
                    await self.uploadDeviceInfo(with: json)
                } catch {
                    print("error：\(error)")
                }
            }
        }
    }
    
    private func uploadLocationInfo(with json: [String: String]) async {
        do {
            let _ = try await launchViewModel.uploadLocationinfo(json: json)
        } catch {
            
        }
    }
    
    private func uploadDeviceInfo(with json: [String: String]) async {
        do {
            let _ = try await launchViewModel.uploadDeviceinfo(json: json)
        } catch {
            
        }
    }
    
    private func stayApp() async {
        if LanguageManager.currentLanguage == .en {
            return
        }
        let starttime = StayPointConfig.starttime ?? ""
        let leavetime = StayPointConfig.leavetime ?? ""
        let locationJson = AppLocationModel.shared.locationJson ?? [:]
        let amward = locationJson["amward"] ?? ""
        let rhizeur = locationJson["rhizeur"] ?? ""
        do {
            if starttime.isEmpty && leavetime.isEmpty {
                return
            }
            let json = ["cupship": starttime,
                        "laud": leavetime,
                        "amward": amward,
                        "rhizeur": rhizeur,
                        "recordage": "1",
                        "selenality": "",
                        "archaeoourster": ""]
            let model = try await launchViewModel.uploadSnippetInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                StayPointConfig.deleteTrackInformation()
            }
        } catch {
            
        }
        
    }
    
}
