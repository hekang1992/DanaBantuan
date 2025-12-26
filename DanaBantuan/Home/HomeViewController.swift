//
//  HomeViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit
import MJRefresh

class HomeViewController: BaseViewController {
    
    private let viewModel = HomeViewModel()
    
    private var baseModel: BaseModel?
    
    lazy var oneView: AppOneView = {
        let oneView = AppOneView(frame: .zero)
        return oneView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.oneView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.homeInfo()
            }
        })
        
        self.oneView.applyBlock = { [weak self] model in
            guard let self = self else { return }
            Task {
                await self.applyProduct(with: model)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.homeInfo()
        }
    }
    
}

extension HomeViewController {
    
    private func homeInfo() async {
        do {
            let json = ["se": "1"]
            let model = try await viewModel.homeInfo(json: json)
            if model.mountization == "0" {
                self.baseModel = model
                let modelArray = model.hairship?.clearfic ?? []
                for item in modelArray {
                    let gymn = item.gymn ?? ""
                    if gymn == "pulmonain" {
                        oneViewModel(with: item.haveion?.first ?? haveionModel())
                    }
                }
            }
            await MainActor.run {
                self.oneView.scrollView.mj_header?.endRefreshing()
            }
        } catch {
            await MainActor.run {
                self.oneView.scrollView.mj_header?.endRefreshing()
            }
        }
    }
    
}

extension HomeViewController {
    
    private func oneViewModel(with model: haveionModel) {
        self.oneView.model = model
    }
    
    private func applyProduct(with model: haveionModel) async {
        let productID = String(model.cunely ?? 0)
        
        let json = [
            "quintarian": "1001",
            "vigenclearlyence": "1000",
            "windowship": "1000",
            "spatikin": productID,
            "susment": "1001"
        ]
        
        do {
            let model = try await viewModel.applyProductInfo(json: json)
            if model.mountization == "0" {
                let pageUrl = model.hairship?.orexilike ?? ""
                if pageUrl.hasPrefix(SchemeApiUrl.scheme_url) {
                    URLSchemeParsable.handleSchemeRoute(pageUrl: pageUrl, from: self)
                } else {
                    self.goWebVc(with: pageUrl)
                }
            } else {
                ToastManager.showMessage(message: model.se ?? "")
            }
        } catch {
            
        }
    }
    
}
