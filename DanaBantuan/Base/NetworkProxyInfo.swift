//
//  NetworkProxyInfo.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import Foundation

struct NetworkProxyInfo {
    
    // MARK: - Connection Status
    enum ConnectionStatus: Int {
        case inactive = 0
        case active = 1
    }
    
    // MARK: - Public Status
    static var proxyStatus: ConnectionStatus {
        return isProxyEnabled ? .active : .inactive
    }
    
    static var vpnStatus: ConnectionStatus {
        return isVPNEnabled ? .active : .inactive
    }
    
    // MARK: - Private Helpers
    private static var systemProxySettings: [String: Any]? {
        CFNetworkCopySystemProxySettings()?
            .takeRetainedValue() as? [String: Any]
    }
    
    private static var isProxyEnabled: Bool {
        guard let settings = systemProxySettings else { return false }
        
        let proxyKeys = ["HTTPProxy", "HTTPSProxy"]
        return proxyKeys.contains { key in
            let value = settings[key] as? String
            return !(value?.isEmpty ?? true)
        }
    }
    
    private static var isVPNEnabled: Bool {
        guard
            let settings = systemProxySettings,
            let scopedSettings = settings["__SCOPED__"] as? [String: Any]
        else {
            return false
        }
        
        let vpnKeywords = ["tap", "tun", "ppp", "ipsec", "utun"]
        
        return scopedSettings.keys.contains { key in
            vpnKeywords.contains { key.localizedCaseInsensitiveContains($0) }
        }
    }
}
