//
//  LocationUserdefaultConfig.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2026/1/6.
//

import Foundation

class LocationUserdefaultConfig {
    
    static func saveLocationInfo(latitude: String, longitude: String) {
        UserDefaults.standard.set(latitude, forKey: "latitude")
        UserDefaults.standard.set(longitude, forKey: "longitude")
        UserDefaults.standard.synchronize()
    }
    
    static func getLocationInfo() -> (latitude: String?, longitude: String?) {
        let latitude = UserDefaults.standard.string(forKey: "latitude")
        let longitude = UserDefaults.standard.string(forKey: "longitude")
        return (latitude, longitude)
    }
    
}
