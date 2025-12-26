//
//  IDFAManager.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class IDFAManager {
    
    static let shared = IDFAManager()
    private init() {}
    
    func requestIDFA(completion: @escaping (String?) -> Void) {
        let status = ATTrackingManager.trackingAuthorizationStatus
        
        switch status {
        case .notDetermined:
            ATTrackingManager.requestTrackingAuthorization { authStatus in
                DispatchQueue.main.async {
                    if authStatus == .authorized {
                        let idfa = self.getCurrentIDFA()
                        completion(idfa)
                    } else {
                        completion(nil)
                    }
                }
            }
            
        case .authorized:
            let idfa = getCurrentIDFA()
            DispatchQueue.main.async {
                completion(idfa)
            }
            
        case .denied, .restricted:
            DispatchQueue.main.async {
                completion(nil)
            }
            
        @unknown default:
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func getCurrentIDFA() -> String {
        guard ATTrackingManager.trackingAuthorizationStatus == .authorized else {
            return ""
        }
        
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        
        if idfa == "00000000-0000-0000-0000-000000000000" {
            return ""
        }
        
        return idfa
    }
}
