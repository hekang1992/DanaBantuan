//
//  AppSchemeUrlConfig.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import UIKit

class SchemeApiUrl {
    static let scheme_url = "tard://lepoability.queristic.financial"
    static let home_scheme_url = "tard://lepoability.queristic.financial/cleithran"
    static let setting_scheme_url = "tard://lepoability.queristic.financial/mericenturyaceous"
    static let login_scheme_url = "tard://lepoability.queristic.financial/lyzify"
    static let order_scheme_url = "tard://lepoability.queristic.financial/torpeization"
    static let product_scheme_url = "tard://lepoability.queristic.financial/postulial"
    static let contact_scheme_url = "tard://lepoability.queristic.financial/oscillatprocessfier"
}

struct RouteParameters {
    let path: String
    let queryParams: [String: String]
    
    init?(url: URL) {
        guard url.scheme == "tard",
              url.host == "lepoability.queristic.financial" else {
            return nil
        }
        
        self.path = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
        var params: [String: String] = [:]
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            for item in queryItems {
                params[item.name] = item.value
            }
        }
        self.queryParams = params
    }
}

class URLSchemeParsable: NSObject {
    
    static func handleSchemeRoute(pageUrl: String, from viewController: BaseViewController) {
        guard let url = URL(string: pageUrl) else {
            return
        }
        
        guard let route = RouteParameters(url: url) else {
            print("URL格式不符合要求: \(pageUrl)")
            return
        }
        
        switch route.path {
        case "cleithran":
            navigateToHome(from: viewController)
            
        case "mericenturyaceous":
            navigateToSettings(from: viewController)
            
        case "lyzify":
            navigateToLogin(from: viewController)
            
        case "torpeization":
            navigateToOrders(from: viewController)
            
        case "postulial":
            navigateToProductDetail(from: viewController, parameters: route.queryParams)
            
        case "oscillatprocessfier":
            navigateToContact(from: viewController)
            
        default:
            break
        }
    }
    
    private static func navigateToHome(from viewController: BaseViewController) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil
            )
        }
    }
    
    private static func navigateToSettings(from viewController: BaseViewController) {
        let settingVc = SettingViewController()
        viewController.navigationController?.pushViewController(settingVc, animated: true)
    }
    
    private static func navigateToLogin(from viewController: BaseViewController) {
        UserLoginConfig.deleteUserInformation()
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil
            )
        }
    }
    
    private static func navigateToOrders(from viewController: BaseViewController) {
        // 跳转到订单页
        
    }
    
    private static func navigateToProductDetail(from viewController: BaseViewController, parameters: [String: String]) {
        guard let productId = parameters["spatikin"] else {
            return
        }
        print("productId====\(productId)")
        
    }
    
    private static func navigateToContact(from viewController: BaseViewController) {
        // 跳转到联系页
        
    }
    
    
}

