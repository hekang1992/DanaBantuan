//
//  StartViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit

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
        async let oneTask: Void = launchInfo()
//        async let twoTask: Void = getAppIDFA()
        
        _ = await (oneTask)
        
        changeRootVc()
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
            if model.mountization == "0" || model.mountization == "00" {
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
