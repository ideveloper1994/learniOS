/**
 * LoginModel.swift
 *
 * @package Makent
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import Foundation
import UIKit

class LoginModel : NSObject, NSCoding {
    
    //MARK Properties
    var success_message : String = ""
    var status_code : String = ""
    var user_name : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var user_image_small : String = ""
    var user_image_large : String = ""
    var dob : String = ""
    var email_id : String = ""
    var user_id : String = ""
    
    var government_id  = ""
    var government_id_type = ""
    var government_id_name  = ""
    
    
    override init() {
    }
    
    init( user_name: String, first_name: String,  last_name: String, dob: String, email_id: String,user_id: String, user_image_small: String) {
        self.user_name = user_name
        self.first_name = first_name
        self.last_name = last_name
        self.dob = dob
        self.email_id = email_id
        self.user_id = user_id
        self.user_image_small = user_image_small
    }
    
    func addResponseToLogin(res:NSDictionary) -> LoginModel{
        if(res.value(forKey: "access_token") != nil){
            let token:String = res.value(forKey: "access_token") as! String
            KeychainWrapper.standard.set(token, forKey: keyChainKey.authenticationToken)
        }
        bindData(dic: res, str: "success_message", type: &self.success_message)
        bindData(dic: res, str: "status_code", type: &self.status_code)
        bindData(dic: res, str: "first_name", type: &self.first_name)
        bindData(dic: res, str: "last_name", type: &self.last_name)
        bindData(dic: res, str: "user_image", type: &self.user_image_small)
        bindData(dic: res, str: "user_image", type: &self.user_image_large)
        bindData(dic: res, str: "dob", type: &self.dob)
        bindData(dic: res, str: "email_id", type: &self.email_id)
        bindData(dic: res, str: "user_id", type: &self.user_id)
        return self
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let user_name = aDecoder.decodeObject(forKey: "user_name") as! String
        let first_name = aDecoder.decodeObject(forKey: "first_name") as! String
        let last_name = aDecoder.decodeObject(forKey: "last_name") as! String
        let user_image_small = aDecoder.decodeObject(forKey: "user_image_small") as! String
        let dob = aDecoder.decodeObject(forKey: "dob") as! String
        let email_id = aDecoder.decodeObject(forKey: "email_id") as! String
        let user_id = aDecoder.decodeObject(forKey: "user_id") as! String
        self.init(
            user_name: user_name,
            first_name: first_name,
            last_name: last_name,
            dob: dob,
            email_id: email_id,
            user_id: user_id,
            user_image_small: user_image_small
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user_name, forKey: "user_name")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(email_id, forKey: "email_id")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(user_image_small, forKey: "user_image_small")
    }
    
}
