//
//  PhoneNumberModel.swift
//  Arheb
//
//  Created on 6/21/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation

class PhoneNoModel : NSObject {
    
    var id : String = ""
    var user_id : String = ""
    var phone_code : String = ""
    var phone_number : String = ""
    var otp : String = ""
    var status : String = ""
    var phone_number_full : String = ""
    var phone_number_protected : String = ""
    var phone_number_nexmo : String = ""
    var default_phone_code : String = ""
    var default_phone_status_message : String = ""
    var verification_message_text : String = ""
    
    func initiatePhoneData(arrRes: NSArray) -> [PhoneNoModel] {
        var dataPhone = [PhoneNoModel]()
        for response in arrRes{
            let obj = response as! NSDictionary
            let objList = PhoneNoModel()
            bindData(dic: obj, str: "id", type: &objList.id)
            bindData(dic: obj, str: "user_id", type: &objList.user_id)
            bindData(dic: obj, str: "phone_code", type: &objList.phone_code)
            bindData(dic: obj, str: "otp", type: &objList.otp)
            bindData(dic: obj, str: "phone_number", type: &objList.phone_number)
            bindData(dic: obj, str: "status", type: &objList.status)
            bindData(dic: obj, str: "phone_number_full", type: &objList.phone_number_full)
            bindData(dic: obj, str: "phone_number_protected", type: &objList.phone_number_protected)
            bindData(dic: obj, str: "phone_number_nexmo", type: &objList.phone_number_nexmo)
            bindData(dic: obj, str: "default_phone_code", type: &objList.default_phone_code)
            bindData(dic: obj, str: "verification_message_text", type: &objList.verification_message_text)
            bindData(dic: obj, str: "default_phone_status_message", type: &objList.default_phone_status_message)
            dataPhone.append(objList)
        }
        return dataPhone
    }
    
}
