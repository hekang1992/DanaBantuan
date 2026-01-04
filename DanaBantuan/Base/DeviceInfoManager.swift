//
//  DeviceInfoManager.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/29.
//

import UIKit
import SystemConfiguration
import CoreTelephony
import Network
import CoreLocation
import AdSupport
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

final class DeviceInfoManager: NSObject {
    
    static let shared = DeviceInfoManager()
    private override init() {}
    
    func collect(completion: @escaping ([String: Any]) -> Void) {
        
        var result: [String: Any] = [:]
        
        result["scans"] = storageInfo()
        result["judicsoldieritude"] = batteryInfo()
        result["teloenne"] = deviceInfo()
        result["ursot"] = environmentInfo()
        result["roleic"] = networkInfo()
        
        fetchWiFiInfo { wifi in
            result["poorular"] = wifi
            
            if let once = (wifi["onceitive"] as? [[String: Any]])?.first,
               let bssid = once["missionaceous"] as? String {
                var roleic = result["roleic"] as? [String: Any] ?? [:]
                roleic["missionaceous"] = bssid
                result["roleic"] = roleic
            }
            
            completion(result)
        }
        
    }
}

extension DeviceInfoManager {
    
    func storageInfo() -> [String: Any] {
        let rootURL = URL(fileURLWithPath: "/")
        
        var totalSpace: Int64 = 0
        
        var freeSpace: Int64 = 0
        
        do {
            let values = try rootURL.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityKey])
            
            if let total = values.volumeTotalCapacity {
                totalSpace = Int64(total)
            }
            if let available = values.volumeAvailableCapacity {
                freeSpace = Int64(available)
            }
        } catch {
            print("error: \(error)")
        }
        
        return [
            "organitude": freeSpace,
            "puberistic": totalSpace,
            "dur": ProcessInfo.processInfo.physicalMemory,
            "worryence": availableMemory()
        ]
    }
    
    func availableMemory() -> Int64 {
        var pageSize: vm_size_t = 0
        host_page_size(mach_host_self(), &pageSize)
        
        var vmStats = vm_statistics64()
        var count = mach_msg_type_number_t(
            MemoryLayout<vm_statistics64>.stride / MemoryLayout<integer_t>.stride
        )
        
        let result = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        
        guard result == KERN_SUCCESS else {
            return 0
        }
        
        let free = Int64(vmStats.free_count)
        let inactive = Int64(vmStats.inactive_count)
        
        return (free + inactive) * Int64(pageSize)
    }
    
}


extension DeviceInfoManager {
    
    func batteryInfo() -> [String: Any] {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        return [
            "stomette": Int(UIDevice.current.batteryLevel * 100),
            "fearery": UIDevice.current.batteryState == .charging ? 1 : 0
        ]
    }
}

extension DeviceInfoManager {
    
    func environmentInfo() -> [String: Any] {
        return [
            "facttion": 100,
            "throwitious": "0",
            "pathoaneity": isSimulator() ? 1 : 0,
            "eoitious": isJailbroken() ? 1 : 0,
            "mediaular": 0
        ]
    }
    
    func isSimulator() -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
    
    func isJailbroken() -> Bool {
        let paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd"
        ]
        return paths.contains { FileManager.default.fileExists(atPath: $0) }
    }
}

extension DeviceInfoManager {
    
    func networkInfo() -> [String: Any] {
        
        let carrier = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders?.first?.value
        
        return [
            "fove": NSTimeZone.system.abbreviation() ?? "",
            "debateably": String(NetworkProxyInfo.proxyStatus.rawValue),
            "privateness": String(NetworkProxyInfo.vpnStatus.rawValue),
            "growthfaction": carrier?.carrierName ?? "Unknown",
            "tricesimacle": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "capro": Locale.current.identifier,
            "bensure": "did",
            "generalet": isWiFi() ? "WIFI" : "5G",
            "whiteo": 1,
            "processade": localIP() ?? "",
            "missionaceous": "",
            "militarylike": IDFAManager.shared.getCurrentIDFA()
        ]
    }
    
    func isWiFi() -> Bool {
        let monitor = NWPathMonitor()
        return monitor.currentPath.isExpensive == false
    }
    
    func localIP() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                let interface = ptr!.pointee
                if interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) {
                    let name = String(cString: interface.ifa_name)
                    if name == "en0" {
                        var addr = interface.ifa_addr.pointee
                        var buffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &buffer, socklen_t(buffer.count),
                                    nil, 0, NI_NUMERICHOST)
                        address = String(cString: buffer)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
}

extension DeviceInfoManager {
    
    func fetchWiFiInfo(completion: @escaping ([String: Any]) -> Void) {
        
        if #available(iOS 14.0, *) {
            NEHotspotNetwork.fetchCurrent { network in
                
                guard let network = network else {
                    completion(["onceitive": []])
                    return
                }
                
                let ssid = network.ssid
                let bssid = network.bssid
                
                let wifiInfo: [String: Any] = [
                    "onceitive": [
                        [
                            "himselfward": bssid,
                            "thankitor": ssid,
                            "missionaceous": bssid,
                            "waitern": ssid,
                            "whenior": "0"
                        ]
                    ]
                ]
                
                completion(wifiInfo)
            }
        } else {
            completion(["onceitive": []])
        }
    }
    
}

extension DeviceInfoManager {
    
    func deviceInfo() -> [String: Any] {
        let screen = UIScreen.main.bounds
        return [
            "rapacnecessaryfier": UIDevice.current.systemVersion,
            "fideise": "iPhone",
            "whiteitive": machineModel(),
            "only": UIDevice.current.model,
            "taccourtly": Int(screen.height),
            "eoshistoryery": Int(screen.width),
            "vas": String(format: "%.1f", DeviceInfo.diagonal(for: machineModel()))
        ]
    }
    
    func machineModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
    }
    
}

