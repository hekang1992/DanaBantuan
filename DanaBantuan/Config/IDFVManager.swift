//
//  IDFVManager.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import Security

class IDFVManager {
    
    static let shared = IDFVManager()
    private init() {}
    
    private let service = Bundle.main.bundleIdentifier ?? "com.app.danabantuan.idfv"
    private let account = "device_danabantuan_idfv"
    
    func getIDFV() -> String {
        if let storedIDFV = retrieveIDFVFromKeychain() {
            return storedIDFV
        }
        
        guard let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString else {
            return ""
        }
        
        if saveIDFVToKeychain(idfv: vendorIdentifier) {
            return vendorIdentifier
        }
        
        return ""
    }
    
    private func saveIDFVToKeychain(idfv: String) -> Bool {
        guard let data = idfv.data(using: .utf8) else {
            return false
        }
    
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    private func retrieveIDFVFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            guard let data = dataTypeRef as? Data,
                  let idfv = String(data: data, encoding: .utf8) else {
                return nil
            }
            return idfv
        } else if status == errSecItemNotFound {
            return nil
        } else {
            return nil
        }
    }
    
}
