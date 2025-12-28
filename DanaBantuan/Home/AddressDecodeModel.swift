//
//  AddressDecodeModel.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/28.
//

import BRPickerView

struct AddressDecodeModel {
    static func getAddressModelArray(dataSourceArr: [clearficModel]) -> [BRTextModel] {
        return dataSourceArr.enumerated().map { provinceIndex, provinceDic in
            let provinceModel = BRTextModel()
            provinceModel.code = provinceDic.mountization ?? ""
            provinceModel.text = provinceDic.waitern
            provinceModel.index = provinceIndex
            
            let cityList = provinceDic.tricenen ?? []
            provinceModel.children = cityList.enumerated().map { cityIndex, cityDic in
                let cityModel = BRTextModel()
                cityModel.code = provinceDic.mountization ?? ""
                cityModel.text = provinceDic.waitern
                cityModel.index = cityIndex
                
                let areaList = cityDic.tricenen ?? []
                cityModel.children = areaList.enumerated().map { areaIndex, areaDic in
                    let areaModel = BRTextModel()
                    areaModel.code = provinceDic.mountization ?? ""
                    areaModel.text = provinceDic.waitern
                    areaModel.index = areaIndex
                    return areaModel
                }
                
                return cityModel
            }
            
            return provinceModel
        }
    }
}

class AppAddressCityModel {
    static let shared = AppAddressCityModel()
    private init() {}
    var modelArray: [clearficModel]?
}
