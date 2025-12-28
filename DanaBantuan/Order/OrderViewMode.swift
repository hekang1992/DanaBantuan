//
//  OrderViewMode.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/28.
//

import Foundation

class OrderViewMode {
    
    func orderListInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/orexilike", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    
}
