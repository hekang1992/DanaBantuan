//
//  MainViewModel.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/27.
//

import Foundation

class MainViewModel {
    
    /// get_user_detail_info
    func userDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/fidelage", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// save_user_detail_info
    func saveUserDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/nothfic", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// get_user_contact_detail_info
    func userContactDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/pung", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// save_user_detail_info
    func saveUserContactDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/goodard", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// upload_user_detail_info
    func uploadContactDetailInfo(json: [String: String]) async throws -> BaseModel {
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/algics", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// get_user_bank_detail_info
    func userBankDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/clearfic", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// save_user_bank_detail_info
    func saveUserBankDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/gymn", parameters: json)
            return model
        } catch {
            throw error
        }
    }
}
