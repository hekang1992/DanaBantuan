//
//  BaseViewController.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    private let detailViewModel = ProductViewModel()
    
    private let launchBViewModel = LaunchViewModel()
    
    lazy var headView: AppHeadView = {
        let headView = AppHeadView(frame: .zero)
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
}

extension BaseViewController {
    
    func changeRootVc() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil
            )
        }
    }
    
    func goWebVc(with pageUrl: String) {
        let webVc = H5WebViewController()
        webVc.pageUrl = pageUrl
        self.navigationController?.pushViewController(webVc, animated: true)
    }
    
    func backProductPageVc() {
        guard let nav = navigationController,
              let productVC = nav.viewControllers.first(where: { $0 is ProductViewController })
        else {
            navigationController?.popToRootViewController(animated: true)
            return
        }
        nav.popToViewController(productVC, animated: true)
    }
    
    
}

extension BaseViewController {
    
    func getDetailInfo(with productID: String) async {
        do {
            let json = ["spatikin": productID,
                        "preventitude": String(Int(1))
            ]
            let model = try await detailViewModel.productDetailInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                let type = model.hairship?.vovo?.barel ?? ""
                let name = model.hairship?.vovo?.jutcommonably ?? ""
                let orderNo = model.hairship?.section?.selenality ?? ""
                goNextVc(with: type, name: name, orderID: orderNo, productID: productID, model: model)
            }
        } catch {
            
        }
    }
    
    func goNextVc(with type: String, name: String, orderID: String, productID: String, model: BaseModel) {
        switch type {
        case "preparefold":
            Task {
                await self.judgeFaceInfo(with: name, orderID: orderID, productID: productID)
            }
            
        case "tapetfilm":
            let personalVc = PersonalViewController()
            personalVc.name = name
            personalVc.orderID = orderID
            personalVc.productID = productID
            self.navigationController?.pushViewController(personalVc, animated: true)
            
        case "tropid":
            let contactVc = ContactViewController()
            contactVc.name = name
            contactVc.orderID = orderID
            contactVc.productID = productID
            self.navigationController?.pushViewController(contactVc, animated: true)
            
        case "montible":
            let bankVc = BankViewController()
            bankVc.name = name
            bankVc.orderID = orderID
            bankVc.productID = productID
            self.navigationController?.pushViewController(bankVc, animated: true)
            
        case "":
            Task {
                await self.orderInfo(with: model, productID: productID)
            }
            break
        default:
            break
        }
    }
    
    private func judgeFaceInfo(with name: String, orderID: String, productID: String) async {
        do {
            let json = ["spatikin": productID]
            let model = try await detailViewModel.getUserlInfo(json: json)
            
            guard model.mountization == "0" || model.mountization == "00" else {
                ToastManager.showMessage(message: model.se ?? "")
                return
            }
            
            guard let hairShip = model.hairship else {
                showCompleteViewController(name: name, orderID: orderID, productID: productID)
                return
            }
            
            let idModel = hairShip.towardsive ?? towardsiveModel()
            let faceModel = hairShip.pilious ?? towardsiveModel()
            
            if idModel.sectionia == 0 {
                showUserIDViewController(name: name, orderID: orderID, productID: productID)
                return
            }
            
            if faceModel.sectionia == 0 {
                showFaceViewController(name: name, orderID: orderID, productID: productID)
                return
            }
            
            showCompleteViewController(name: name, orderID: orderID, productID: productID)
            
        } catch {
            handleError(error)
        }
    }
    
    private func showUserIDViewController(name: String, orderID: String, productID: String) {
        let idVc = UserIDViewController()
        idVc.name = name
        idVc.orderID = orderID
        idVc.productID = productID
        navigationController?.pushViewController(idVc, animated: true)
    }
    
    private func showFaceViewController(name: String, orderID: String, productID: String) {
        let faceVc = FaceViewController()
        faceVc.name = name
        faceVc.orderID = orderID
        faceVc.productID = productID
        navigationController?.pushViewController(faceVc, animated: true)
    }
    
    private func showCompleteViewController(name: String, orderID: String, productID: String) {
        let completeVc = BothCompleteViewController()
        completeVc.name = name
        completeVc.orderID = orderID
        completeVc.productID = productID
        navigationController?.pushViewController(completeVc, animated: true)
    }
    
    private func handleError(_ error: Error) {
        print("judgeFaceInfo error: \(error)")
    }
    
}

extension BaseViewController {
    
    func orderInfo(with model: BaseModel, productID: String) async {
        let last = model.hairship?.section?.selenality ?? ""
        let ourability = model.hairship?.section?.ourability ?? ""
        let acetacy = model.hairship?.section?.acetacy ?? ""
        let quassweightify = String(model.hairship?.section?.quassweightify ?? 0)
        let yourselfibility = LanguageManager.currentLanguage.rawValue
        let starttime = String(Date().timeIntervalSince1970)
        do {
            let json = ["last": last,
                        "ourability": ourability,
                        "acetacy": acetacy,
                        "quassweightify": quassweightify,
                        "yourselfibility": yourselfibility]
            let model = try await detailViewModel.orderInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                Task {
                    await self.stayApp(with: last, starttime: starttime, productID: productID)
                }
                let pageUrl = model.hairship?.orexilike ?? ""
                if pageUrl.hasPrefix(SchemeApiUrl.scheme_url) {
                    URLSchemeParsable.handleSchemeRoute(pageUrl: pageUrl, from: self)
                } else {
                    if pageUrl.isEmpty {
                        return
                    }
                    self.goWebVc(with: pageUrl)
                }
            }else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            
        }
    }
    
    func stayApp(with orderID: String, starttime: String, productID: String) async {
        let locationJson = AppLocationModel.shared.locationJson ?? [:]
        let amward = locationJson["amward"] ?? ""
        let rhizeur = locationJson["rhizeur"] ?? ""
        do {
            let json = ["cupship": starttime,
                        "laud": String(Int(Date().timeIntervalSince1970)),
                        "amward": amward,
                        "rhizeur": rhizeur,
                        "recordage": "8",
                        "selenality": orderID,
                        "archaeoourster": productID]
            let _ = try await launchBViewModel.uploadSnippetInfo(json: json)
        } catch {
            
        }
    }
    
}
