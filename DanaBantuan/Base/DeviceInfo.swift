//
//  DeviceInfo.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/29.
//

import Foundation

public class DeviceInfo {
    
    public class func diagonal(for identifier: String) -> Double {
        let device = mapToDevice(identifier: identifier)
        return diagonal(for: device)
    }
    
    public indirect enum Device {
        case iPodTouch5, iPodTouch6, iPodTouch7
        case iPhone4, iPhone4s, iPhone5, iPhone5c, iPhone5s
        case iPhone6, iPhone6Plus, iPhone6s, iPhone6sPlus
        case iPhone7, iPhone7Plus, iPhoneSE
        case iPhone8, iPhone8Plus, iPhoneX, iPhoneXS, iPhoneXSMax
        case iPhoneXR, iPhone11, iPhone11Pro, iPhone11ProMax
        case iPhoneSE2, iPhone12, iPhone12Mini, iPhone12Pro, iPhone12ProMax
        case iPhone13, iPhone13Mini, iPhone13Pro, iPhone13ProMax
        case iPhoneSE3, iPhone14, iPhone14Plus, iPhone14Pro, iPhone14ProMax
        case iPhone15, iPhone15Plus, iPhone15Pro, iPhone15ProMax
        case iPhone16, iPhone16Plus, iPhone16Pro, iPhone16ProMax, iPhone16e
        case iPhone17, iPhone17Pro, iPhone17ProMax, iPhoneAir
        case simulator(Device)
        case unknown(String)
    }
    
    private class func mapToDevice(identifier: String) -> Device {
#if os(iOS)
        switch identifier {
        case "iPod5,1": return .iPodTouch5
        case "iPod7,1": return .iPodTouch6
        case "iPod9,1": return .iPodTouch7
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return .iPhone4
        case "iPhone4,1": return .iPhone4s
        case "iPhone5,1", "iPhone5,2": return .iPhone5
        case "iPhone5,3", "iPhone5,4": return .iPhone5c
        case "iPhone6,1", "iPhone6,2": return .iPhone5s
        case "iPhone7,2": return .iPhone6
        case "iPhone7,1": return .iPhone6Plus
        case "iPhone8,1": return .iPhone6s
        case "iPhone8,2": return .iPhone6sPlus
        case "iPhone9,1", "iPhone9,3": return .iPhone7
        case "iPhone9,2", "iPhone9,4": return .iPhone7Plus
        case "iPhone8,4": return .iPhoneSE
        case "iPhone10,1", "iPhone10,4": return .iPhone8
        case "iPhone10,2", "iPhone10,5": return .iPhone8Plus
        case "iPhone10,3", "iPhone10,6": return .iPhoneX
        case "iPhone11,2": return .iPhoneXS
        case "iPhone11,4", "iPhone11,6": return .iPhoneXSMax
        case "iPhone11,8": return .iPhoneXR
        case "iPhone12,1": return .iPhone11
        case "iPhone12,3": return .iPhone11Pro
        case "iPhone12,5": return .iPhone11ProMax
        case "iPhone12,8": return .iPhoneSE2
        case "iPhone13,2": return .iPhone12
        case "iPhone13,1": return .iPhone12Mini
        case "iPhone13,3": return .iPhone12Pro
        case "iPhone13,4": return .iPhone12ProMax
        case "iPhone14,5": return .iPhone13
        case "iPhone14,4": return .iPhone13Mini
        case "iPhone14,2": return .iPhone13Pro
        case "iPhone14,3": return .iPhone13ProMax
        case "iPhone14,6": return .iPhoneSE3
        case "iPhone14,7": return .iPhone14
        case "iPhone14,8": return .iPhone14Plus
        case "iPhone15,2": return .iPhone14Pro
        case "iPhone15,3": return .iPhone14ProMax
        case "iPhone15,4": return .iPhone15
        case "iPhone15,5": return .iPhone15Plus
        case "iPhone16,1": return .iPhone15Pro
        case "iPhone16,2": return .iPhone15ProMax
        case "iPhone17,3": return .iPhone16
        case "iPhone17,4": return .iPhone16Plus
        case "iPhone17,1": return .iPhone16Pro
        case "iPhone17,2": return .iPhone16ProMax
        case "iPhone17,5": return .iPhone16e
        case "iPhone18,3": return .iPhone17
        case "iPhone18,1": return .iPhone17Pro
        case "iPhone18,2": return .iPhone17ProMax
        case "iPhone18,4": return .iPhoneAir
        case "i386", "x86_64", "arm64":
            let simIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"
            return .simulator(mapToDevice(identifier: simIdentifier))
        default: return .unknown(identifier)
        }
#else
        return .unknown(identifier)
#endif
    }
    
    private class func diagonal(for device: Device) -> Double {
#if os(iOS)
        switch device {
        case .iPodTouch5, .iPodTouch6, .iPodTouch7: return 4.0
            
        case .iPhone4, .iPhone4s: return 3.5
            
        case .iPhone5, .iPhone5c, .iPhone5s, .iPhoneSE: return 4.0
            
        case .iPhone6, .iPhone6s, .iPhone7, .iPhone8, .iPhoneSE2, .iPhoneSE3: return 4.7
            
        case .iPhone12Mini, .iPhone13Mini: return 5.4
            
        case .iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus: return 5.5
            
        case .iPhoneX, .iPhoneXS, .iPhone11Pro: return 5.8
            
        case .iPhoneXR, .iPhone11, .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro,
                .iPhone14, .iPhone14Pro, .iPhone15, .iPhone15Pro, .iPhone16, .iPhone16e: return 6.1
            
        case .iPhone16Pro, .iPhone17, .iPhone17Pro: return 6.3
            
        case .iPhoneXSMax, .iPhone11ProMax, .iPhoneAir: return 6.5
            
        case .iPhone12ProMax, .iPhone13ProMax, .iPhone14Plus, .iPhone14ProMax,
                .iPhone15Plus, .iPhone15ProMax, .iPhone16Plus, .iPhone16ProMax,
                .iPhone17ProMax: return 6.7
            
        case .simulator(let model): return diagonal(for: model)
            
        case .unknown: return -1
        }
#else
        return -1
#endif
    }
}
