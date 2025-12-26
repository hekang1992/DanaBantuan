//
//  CenterViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit

class CenterViewController: BaseViewController {
    
    private let viewModel = CenterViewModel()
    
    lazy var centerView: CenterView = {
        let centerView = CenterView(frame: .zero)
        return centerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.centerInfo()
        }
    }
    
}

extension CenterViewController {
    
    private func centerInfo() async {
        do {
            let json = ["vitiitious": UserLoginConfig.isLoggedIn ? "1" : "0"]
            let model = try await viewModel.centerInfo(json: json)
            if model.mountization == "0" {
                
            }
        } catch {
            
        }
    }
    
}
