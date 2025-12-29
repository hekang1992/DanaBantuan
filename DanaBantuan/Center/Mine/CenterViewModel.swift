//
//  CenterViewModel.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/25.
//

import Foundation

class CenterViewModel {
    
    func centerInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/alwaysad/interency", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    func logoutInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/alwaysad/mountization", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    func deleteInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/alwaysad/paintingsion", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
}
