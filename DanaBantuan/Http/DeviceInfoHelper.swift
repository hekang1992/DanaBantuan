//
//  DeviceInfoHelper.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//


import UIKit

final class DeviceInfoHelper {
    
    static func apiParams() -> [String: Any] {
        
        let device = UIDevice.current
        let bundle = Bundle.main
        
        let appVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        
        let deviceName = device.model
        
        let systemVersion = device.systemVersion
        
        let idfv = IDFVManager.shared.getIDFV()
        
        let sessionId = UserLoginConfig.token ?? ""
        
        var ie: String = ""
        
        let savedCode = UserDefaults.standard.string(forKey: "app_language") ?? ""
        
        if savedCode.isEmpty {
            ie = ""
        }else if savedCode == "2" {
            ie = "7641"
        }else if savedCode == "1" {
            ie = "2836"
        }
        
        return [
            "epstoryaneous": "ios",
            "veniess": appVersion,
            "secweit": deviceName,
            "use": idfv,
            "airy": systemVersion,
            "elseence": "dana_bantuan",
            "cotylly": sessionId,
            "scaloon": idfv,
            "ie": ie
        ]
    }
}

class APIHelper {
    static func apiURLString( path: String, extraParams: [String: Any] = [:]) -> String? {
        
        var components = URLComponents(string: path)
        var params = DeviceInfoHelper.apiParams()
        
        extraParams.forEach { params[$0.key] = $0.value }
        
        components?.queryItems = params.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        
        return components?.url?.absoluteString
    }
    
}

