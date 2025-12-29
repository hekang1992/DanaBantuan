//
//  OrderViewController.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/25.
//

import UIKit
import SnapKit
import MJRefresh

class OrderViewController: BaseViewController {
    
    private let viewModel = OrderViewMode()
    
    var modelArray: [clearficModel] = []
    
    lazy var orderView: OrderView = {
        let orderView = OrderView(frame: .zero)
        return orderView
    }()
    
    var type: String = "4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(orderView)
        orderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.orderView.orderTypeBlock = { [weak self] type in
            guard let self = self else { return }
            self.type = type
            Task {
                await self.orderListInfo(with: type)
            }
        }
        
        self.orderView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.orderListInfo(with: self.type)
            }
        })
        
        self.orderView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            self.changeRootVc()
        }
        
        self.orderView.tapCellClickBlock = { [weak self] model in
            guard let self = self else { return }
            let pageUrl = model.physalidory ?? ""
            if pageUrl.hasPrefix(SchemeApiUrl.scheme_url) {
                URLSchemeParsable.handleSchemeRoute(pageUrl: pageUrl, from: self)
            } else {
                if pageUrl.isEmpty {
                    return
                }
                self.goWebVc(with: pageUrl)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.orderListInfo(with: type)
        }
    }
}

extension OrderViewController {
    
    private func orderListInfo(with type: String) async {
        do {
            let json = ["gameaneity": type, "sorsess": "1", "patienne": "50"]
            let model = try await viewModel.orderListInfo(json: json)
            if model.mountization == "0" || model.mountization == "00" {
                self.orderView.modelArray = model.hairship?.clearfic ?? []
            }
            await self.orderView.tableView.mj_header?.endRefreshing()
        } catch {
            await self.orderView.tableView.mj_header?.endRefreshing()
        }
    }
}
