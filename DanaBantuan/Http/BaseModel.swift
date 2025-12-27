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
    var clearfic: [clearficModel]?
    var orexilike: String?
    var play: [playModel]?
    var vovo: vovoModel?
    var section: sectionModel?
}

class odontardModel: Codable {
    var jutcommonably: String?
    var pung: String?
    var goodard: String?
}

class clearficModel: Codable {
    var gymn: String?
    var haveion: [haveionModel]?
}

class haveionModel: Codable {
    var cunely: Int?
    var tic: String?
    var vituage: String?
    var penoern: String?
    var persicfier: String?
    var algics: String?
    var paintingsion: String?
    var listen: String?
    var cardineur: String?
    var relateform: String?
    var oesophagable: String?
    var hydroing: String?
}

class playModel: Codable {
    var jutcommonably: String?
    var bariics: String?
    var edian: String?
    var dosaneity: String?
    var sectionia: Int?
    var barel: String?
}

class vovoModel: Codable {
    var barel: String?
    var jutcommonably: String?
}

class sectionModel: Codable {
    var ourability: String?
    var cunely: String?
    var tic: String?
    var vituage: String?
    var selenality: String?
    var stop: Int?
    var acetacy: String
    var quassweightify: Int?
    var penoern: String?
    var cordeous: String?
    var stereo: stereoModel?
}

class stereoModel: Codable {
    var out: outModel?
    var clysmonceit: outModel?
}

class outModel: Codable {
    var jutcommonably: String?
    var futilition: String?
}
