//
//  ProductViewModel.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/26.
//

import Foundation

class ProductViewModel {
    
    /// get_product_detail_info
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
    
    func getUserlInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/alwaysad/moness", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    func uploadImageInfo(json: [String: String], data: Data) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/alwaysad/ectosion", data: data, parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// sace_user_info
    func saveUserlInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/tinaceous", parameters: json)
            return model
        } catch {
            throw error
        }
    }
    
    /// order_info
    func orderInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingView.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingView.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.postFormMultipart("/alwaysad/haveion", parameters: json)
            return model
        } catch {
            throw error
        }
    }
}
