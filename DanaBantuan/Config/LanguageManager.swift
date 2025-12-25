//
//  LanguageManager.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import Foundation

enum AppLanguage: String {
    case en = "1"
    case id = "2"
    
    var localeIdentifier: String {
        switch self {
        case .en: return "en"
        case .id: return "id"
        }
    }
}

class LanguageManager {
    static var bundle: Bundle = .main
    private static let userDefaultsKey = "app_language"
    
    static func setLanguage(code: Int) {
        let language: AppLanguage
        switch code {
        case 1:
            language = .en
        case 2:
            language = .id
        default:
            language = .en
        }
        setLanguage(language)
    }
    
    static func setLanguage(_ language: AppLanguage) {
        if let path = Bundle.main.path(forResource: language.localeIdentifier, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            bundle = langBundle
        } else {
            bundle = .main
        }
        UserDefaults.standard.set(language.rawValue, forKey: userDefaultsKey)
    }
    
    static func localizedString(for key: String) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
    
    static var currentLanguage: AppLanguage {
        guard let savedCode = UserDefaults.standard.string(forKey: userDefaultsKey) else {
            return .en
        }
        return AppLanguage(rawValue: savedCode) ?? .en
    }
}
