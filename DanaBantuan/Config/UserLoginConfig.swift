//
//  UserLoginConfig.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit

struct UserLoginConfig {
    
    enum Key: String {
        case userPhone = "user_phone"
        case userToken = "user_token"
    }
    
    static func saveUserInformation(phone: String, token: String) {
        let defaults = UserDefaults.standard
        defaults.set(phone, forKey: Key.userPhone.rawValue)
        defaults.set(token, forKey: Key.userToken.rawValue)
        defaults.synchronize()
    }
    
    static func deleteUserInformation() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Key.userPhone.rawValue)
        defaults.removeObject(forKey: Key.userToken.rawValue)
        defaults.synchronize()
    }
    
    static var phone: String? {
        return UserDefaults.standard.string(forKey: Key.userPhone.rawValue)
    }
    
    static var token: String? {
        return UserDefaults.standard.string(forKey: Key.userToken.rawValue)
    }
    
    static var isLoggedIn: Bool {
        return token != nil && phone != nil
    }
}
