//
//  Config.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import Foundation

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

extension UIFont {
    static func system(_ size: CGFloat, weightValue: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight(weightValue))
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension Double {
    func pix() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

extension CGFloat {
    func pix() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

extension Int {
    func pix() -> CGFloat {
        return CGFloat.init(CGFloat.init(self)/375.0 * SCREEN_WIDTH)
    }
}

class PhoneFormatter {
    static func formatPhoneNumber(_ phone: String) -> String {
        guard phone.count >= 8 else { return phone }
        
        let startIndex = phone.index(phone.startIndex, offsetBy: 3)
        let endIndex = phone.index(phone.endIndex, offsetBy: -4)
        
        guard startIndex < endIndex else {
            let prefix = String(phone.prefix(3))
            return "\(prefix)***"
        }
        
        let range = startIndex..<endIndex
        
        var formatted = phone
        formatted.replaceSubrange(range, with: "***")
        return formatted
    }
    
    func format(_ phone: String) -> String {
        return PhoneFormatter.formatPhoneNumber(phone)
    }
}
