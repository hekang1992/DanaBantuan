//
//  IDFVManager.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/25.
//

import UIKit
import Security

class IDFVManager {
    
    static let shared = IDFVManager()
    
    private init(){}
    
    func getIDFV() -> String {
        if let existingIDFV = loadIDFVFromKeychain() {
            return existingIDFV
        }
        
        let idfv: String
        if let vendorId = UIDevice.current.identifierForVendor?.uuidString {
            idfv = vendorId
        } else {
            idfv = UUID().uuidString
        }
        
        saveIDFVToKeychain(idfv)
        return idfv
    }
    
    private let keychainService = "com.idfv.danabantuan.app"
    private let keychainAccount = "device_idfv"
    
    private  func saveIDFVToKeychain(_ idfv: String) {
        guard let data = idfv.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func loadIDFVFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess,
           let data = dataTypeRef as? Data,
           let idfv = String(data: data, encoding: .utf8) {
            return idfv
        }
        
        return nil
    }
    
}
