//
//  CenterViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit
import MJRefresh

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
        
        centerView.tapClickBlock = { [weak self] pageUrl in
            guard let self = self, !pageUrl.isEmpty else { return }
            if pageUrl.hasPrefix(SchemeApiUrl.scheme_url) {
                URLSchemeParsable.handleSchemeRoute(pageUrl: pageUrl, from: self)
            } else {
                self.goWebVc(with: pageUrl)
            }
        }
        
        self.centerView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.centerInfo()
            }
        })
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
            if model.mountization == "0" || model.mountization == "00" {
                let modelArray = model.hairship?.odontard ?? []
                self.centerView.modelArray = modelArray
            }else {
                ToastManager.showMessage(message: model.se ?? "")
            }
            await MainActor.run {
                self.centerView.tableView.mj_header?.endRefreshing()
            }
        } catch {
            await MainActor.run {
                self.centerView.tableView.mj_header?.endRefreshing()
            }
        }
    }
    
}
