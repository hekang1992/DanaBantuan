//
//  HttpRequestManager.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/25.
//

import Foundation
import Alamofire

let base_url = "http://8.215.85.208:6853/readywise"
let base_h5_url = "http://8.215.85.208:6853"

final class HttpRequestManager {
    
    static let shared = HttpRequestManager()
    private init() {}
    
    /// GET Session（10s）
    private lazy var shortSession: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        return Session(configuration: config)
    }()
    
    /// POST / Upload Session（30s）
    private lazy var longSession: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        return Session(configuration: config)
    }()
    
    // MARK: - GET
    func get<T: Decodable>(
        _ path: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        
        guard let url = APIHelper.apiURLString(path: base_url + path) else {
            throw AFError.invalidURL(url: base_url + path)
        }
        
        return try await shortSession.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate()
        .serializingDecodable(T.self)
        .value
    }
    
    // MARK: - POST JSON
    func post<T: Decodable>(
        _ path: String,
        parameters: Parameters,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        
        guard let url = APIHelper.apiURLString(path: base_url + path) else {
            throw AFError.invalidURL(url: base_url + path)
        }
        
        return try await longSession.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate()
        .serializingDecodable(T.self)
        .value
    }
    
    // MARK: - multipart/form-data
    func postFormMultipart<T: Decodable>(
        _ path: String,
        parameters: [String: Any],
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        
        guard let url = APIHelper.apiURLString(path: base_url + path) else {
            throw AFError.invalidURL(url: base_url + path)
        }
        
        return try await longSession.upload(
            multipartFormData: { multipart in
                parameters.forEach { key, value in
                    multipart.append(
                        Data("\(value)".utf8),
                        withName: key
                    )
                }
            },
            to: url,
            method: .post,
            headers: headers
        )
        .validate()
        .serializingDecodable(T.self)
        .value
    }
    
    // MARK: - multipartFormData
    func upload<T: Decodable>(
        _ path: String,
        data: Data,
        parameters: [String: String]? = nil
    ) async throws -> T {
        
        guard let url = APIHelper.apiURLString(path: base_url + path) else {
            throw AFError.invalidURL(url: base_url + path)
        }
        
        return try await longSession.upload(
            multipartFormData: { multipart in
                multipart.append(
                    data,
                    withName: "interestice",
                    fileName: "interestice.jpg",
                    mimeType: "interestice/jpeg"
                )
                
                parameters?.forEach {
                    multipart.append(Data($0.value.utf8), withName: $0.key)
                }
            },
            to: url
        )
        .validate()
        .serializingDecodable(T.self)
        .value
    }
}
