//
//  ProductViewModel.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import Foundation

class ProductViewModel {
    
    func productDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/pungsion", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
}
