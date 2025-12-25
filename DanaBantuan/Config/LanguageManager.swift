//
//  LanguageManager.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//


import Foundation

enum AppLanguage: String {
    case english = "462"
    case indonesian = "460"
    
    var localeIdentifier: String {
        switch self {
        case .english: return "en"
        case .indonesian: return "id"
        }
    }
}

class LanguageManager {
    static var bundle: Bundle = .main
    
    static func setLanguage(code: Int) {
        let language: AppLanguage
        switch code {
        case 1:
            language = .english
        case 2:
            language = .indonesian
        default:
            language = .english
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
    }
    
    static func localizedString(for key: String) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
