//
//  UserLoginConfig.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/25.
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

struct StayPointConfig {
    
    enum Key: String {
        case userSatrt = "user_start"
        case userLeave = "user_leave"
    }
    
    static func saveStartInfo(start: String) {
        let defaults = UserDefaults.standard
        defaults.set(start, forKey: Key.userSatrt.rawValue)
        defaults.synchronize()
    }
    
    static func saveLeaveInfo(leave: String) {
        let defaults = UserDefaults.standard
        defaults.set(leave, forKey: Key.userLeave.rawValue)
        defaults.synchronize()
    }
    
    static func deleteTrackInformation() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Key.userSatrt.rawValue)
        defaults.removeObject(forKey: Key.userLeave.rawValue)
        defaults.synchronize()
    }
    
    static var starttime: String? {
        return UserDefaults.standard.string(forKey: Key.userSatrt.rawValue)
    }
    
    static var leavetime: String? {
        return UserDefaults.standard.string(forKey: Key.userLeave.rawValue)
    }
    
    
}
