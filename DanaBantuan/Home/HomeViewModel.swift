//
//  HomeViewModel.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import Foundation

class HomeViewModel {
    
    func homeInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/alwaysad/se", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    
}
