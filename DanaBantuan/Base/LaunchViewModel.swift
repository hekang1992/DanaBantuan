//
//  LaunchViewModel.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import Foundation

class LaunchViewModel {
    
    func initRequest(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/pteracy", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
}
