//
//  BaseViewController.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    private let detailViewModel = ProductViewModel()
    
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
                goNextVc(with: type, name: name, orderID: orderNo, productID: productID)
            }
        } catch {
            
        }
    }
    
    func goNextVc(with type: String, name: String, orderID: String, productID: String) {
        switch type {
        case "preparefold":
            Task {
                await self.judgeFaceInfo(with: name, orderID: orderID, productID: productID)
            }
            break
        case "tapetfilm":
            let personalVc = PersonalViewController()
            personalVc.name = name
            personalVc.orderID = orderID
            personalVc.productID = productID
            self.navigationController?.pushViewController(personalVc, animated: true)
            break
        case "tropid":
            let contactVc = ContactViewController()
            contactVc.name = name
            contactVc.orderID = orderID
            contactVc.productID = productID
            self.navigationController?.pushViewController(contactVc, animated: true)
            break
        case "montible":
            let bankVc = BankViewController()
            bankVc.name = name
            bankVc.orderID = orderID
            bankVc.productID = productID
            self.navigationController?.pushViewController(bankVc, animated: true)
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
