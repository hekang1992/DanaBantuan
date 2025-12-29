//
//  LaunchViewModel.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import Foundation

class LaunchViewModel {
    
    func launchInfo(json: [String: String]) async throws -> BaseModel {
        
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
            throw error
        }
    }
    
    func uploadIDFAinfo(json: [String: String]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/persicfier", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// upload_location_info
    func uploadLocationinfo(json: [String: String]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/vituage", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// upload_device_info
    func uploadDeviceinfo(json: [String: String]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/penoern", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// upload_pc_info
    func uploadSnippetInfo(json: [String: String]) async throws -> BaseModel {
        let deviceInfo: [String: String] = [
            "pulchrfy": IDFAManager.shared.getCurrentIDFA(),
            "vorion": IDFVManager.shared.getIDFV()
        ]
        
        let parameters = deviceInfo.merging(json) { _, new in new }
        
        do {
            return try await HttpRequestManager.shared.postFormMultipart(
                "/alwaysad/uniify",
                parameters: parameters
            )
        } catch {
            throw error
        }
    }
    
}
