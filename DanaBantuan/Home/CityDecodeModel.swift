//
//  AddressDecodeModel.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/28.
//

import BRPickerView

struct CityDecodeModel {
    static func getAddressModelArray(dataSourceArr: [clearficModel]) -> [BRTextModel] {
        return dataSourceArr.enumerated().map { provinceIndex, provinceDic in
            let provinceModel = BRTextModel()
            provinceModel.code = provinceDic.mountization ?? ""
            provinceModel.text = provinceDic.waitern
            provinceModel.index = provinceIndex
            
            let cityList = provinceDic.tricenen ?? []
            provinceModel.children = cityList.enumerated().map { cityIndex, cityDic in
                let cityModel = BRTextModel()
                cityModel.code = cityDic.mountization ?? ""
                cityModel.text = cityDic.waitern
                cityModel.index = cityIndex
                
                let areaList = cityDic.tricenen ?? []
                cityModel.children = areaList.enumerated().map { areaIndex, areaDic in
                    let areaModel = BRTextModel()
                    areaModel.code = areaDic.mountization ?? ""
                    areaModel.text = areaDic.waitern
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
