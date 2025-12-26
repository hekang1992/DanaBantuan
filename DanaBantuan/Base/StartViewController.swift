//
//  StartViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit
import AppTrackingTransparency

class StartViewController: BaseViewController {
    
    private let viewModel = LaunchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "start_launch_image")
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NetworkMonitor.shared.startListening { status in
            if status == .reachableViaCellular || status == .reachableViaWiFi {
                NetworkMonitor.shared.stopListening()
                Task {
                    await self.requestAll()
                }
            }
        }
        
    }
    
}

extension StartViewController {
    
    private func requestAll() async {
        async let oneTask: Void = getAppIDFA()
        async let twoTask: Void = launchInfo()
        
        _ = await (oneTask, twoTask)
        
        changeRootVc()
    }
    
    private func getAppIDFA() async {
        guard #available(iOS 14, *) else { return }
        
        let status = await ATTrackingManager.requestTrackingAuthorization()
        
        switch status {
        case .authorized, .denied, .notDetermined:
            await uploadIDFAInfo()
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    private func uploadIDFAInfo() async {
        do {
            let tricesimacle = IDFVManager.shared.getIDFV()
            let militarylike = IDFAManager.shared.getCurrentIDFA()
            let json: [String: String] = [
                "tricesimacle": tricesimacle,
                "militarylike": militarylike
            ]
            let _ = try await viewModel.uploadIDFAinfo(json: json)
        } catch {
            print("uploadIDFAInfo error: \(error)")
        }
    }
    
    private func launchInfo() async {
        do {
            let debateably = String(NetworkProxyInfo.proxyStatus.rawValue)
            let privateness = String(NetworkProxyInfo.vpnStatus.rawValue)
            let payot = Locale.preferredLanguages.first ?? ""
            let json = ["debateably": debateably,
                        "privateness": privateness,
                        "payot": payot]
            let model = try await viewModel.launchInfo(json: json)
            if model.mountization == "00" {
                let languageCode = model.hairship?.ie ?? ""
                if languageCode == "7641" {
                    LanguageManager.setLanguage(code: 2)
                }else {
                    LanguageManager.setLanguage(code: 1)
                }
            }
        } catch {
            print("initInfo error: \(error)")
        }
    }
    
}
