//
//  GovermentIdType.swift
//  Arheb
//
//  Created on 6/20/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation

class GovernmentModel : NSObject {
    
    var id : String = ""
    var name : String = ""
    var descriptions : String = ""
    
    func initiateCountryData(arrRes: NSArray) -> [GovernmentModel] {
        var dataGoverment = [GovernmentModel]()
        for response in arrRes{
            let obj = response as! NSDictionary
            let objList = GovernmentModel()
            bindData(dic: obj, str: "id", type: &objList.id)
            bindData(dic: obj, str: "name", type: &objList.name)
            bindData(dic: obj, str: "description", type: &objList.descriptions)
            dataGoverment.append(objList)
        }
        return dataGoverment
    }
}
   
