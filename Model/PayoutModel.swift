//
//  PayoutModel.swift
//  Arheb
//
//  Created on 6/3/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation

class PayoutModel : NSObject {
    
    var payout_id : String = ""
    var set_default : String = ""
    var payout_user_name : String = ""
    var paypal_method : String = ""
    var paypal_email : String = ""
    
    func initiatePayoutData(arrRes: NSArray) -> [PayoutModel]{
        var arrPayout = [PayoutModel]()
        for response in arrRes{
            let res = response as! NSDictionary
            let obj = PayoutModel()
            bindData(dic: res, str: "payout_id", type: &obj.payout_id)
            bindData(dic: res, str: "set_default", type: &obj.set_default)
            bindData(dic: res, str: "payout_user_name", type: &obj.payout_user_name)
            bindData(dic: res, str: "paypal_email", type: &obj.paypal_email)
            bindData(dic: res, str: "paypal_method", type: &obj.paypal_method)
            arrPayout.append(obj)
        }
        return arrPayout
    }
    
}
