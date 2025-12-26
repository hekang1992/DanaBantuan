//
//  LoginViewModel.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import Foundation

class LoginViewModel {
    
    func codeInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/sors", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    func loginInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/emness", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
}
