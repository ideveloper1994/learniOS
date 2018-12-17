//
//  CountryModel.swift
//  Arheb
//
//  Created on 6/17/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation

class CountryModel : NSObject {
    
    var country_code : String = ""
    var country_name : String = ""
    var country_id : String = ""
    var phone_code: String = ""
    
    func initiateCountryData(arrRes: NSArray) -> [CountryModel] {
        var dataCountry = [CountryModel]()
        for response in arrRes{
        let obj = response as! NSDictionary
            let objList = CountryModel()
            bindData(dic: obj, str: "country_code", type: &objList.country_code)
            bindData(dic: obj, str: "country_name", type: &objList.country_name)
            bindData(dic: obj, str: "country_id", type: &objList.country_id)
            bindData(dic: obj, str: "phone_code", type: &objList.phone_code)
            dataCountry.append(objList)
        }
        return dataCountry
    }
    
}
