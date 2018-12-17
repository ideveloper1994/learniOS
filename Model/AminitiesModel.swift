//
//  AminitiesModel.swift
//  Arheb
//
//  Created on 6/9/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class AminitiesModel: NSObject {
    
    var aminity_id : String = ""
    var aminity_name : String = ""
    var aminity_type_id : String = ""
    
    func initiateAminityData(arrRes: NSArray) -> [AminitiesModel]{
        var arrAminities = [AminitiesModel]()
        for response in arrRes{
            let res = response as! NSDictionary
            let obj = AminitiesModel()
            bindData(dic: res, str: "id", type: &obj.aminity_id)
            bindData(dic: res, str: "name", type: &obj.aminity_name)
            bindData(dic: res, str: "type_id", type: &obj.aminity_type_id)
            arrAminities.append(obj)
        }
        return arrAminities
    }
}
