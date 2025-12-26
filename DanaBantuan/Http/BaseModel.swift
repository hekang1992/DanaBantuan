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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intValue = try? container.decode(Int.self, forKey: .mountization) {
            mountization = String(intValue)
        } else {
            mountization = try? container.decode(String.self, forKey: .mountization)
        }
        se = try? container.decode(String.self, forKey: .se)
        hairship = try? container.decode(hairshipModel.self, forKey: .hairship)
    }
    
    enum CodingKeys: String, CodingKey {
        case mountization, se, hairship
    }
}

class hairshipModel: Codable {
    var ie: String?
    var cotylly: String?
    var interency: String?
    var odontard: [odontardModel]?
}

class odontardModel: Codable {
    var jutcommonably: String?
    var pung: String?
    var goodard: String?
}
