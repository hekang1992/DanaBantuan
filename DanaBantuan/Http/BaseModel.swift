//
//  BaseModel.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

class BaseModel: Codable {
    var mountization: String?
    var se: String?
    var hairship: hairshipModel?
}

class hairshipModel: Codable {
    var ie: String?
    var cotylly: String?
    var interency: String?
}
