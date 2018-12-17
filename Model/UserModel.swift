//
//  UserModel.swift
//  Arheb
//
//  Created on 6/1/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation
import UIKit

class UserModel : NSObject {
    
    var user_name : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var user_thumb_image : String = ""
    var normal_image_url : String = ""
    var large_image_url : String = ""
    var small_image_url : String = ""
    var dob : String = ""
    var email : String = ""
    var user_location : String = ""
    var member_from : String = ""
    var about_me : String = ""
    var school : String = ""
    var gender : String = ""
    var phone : String = ""
    var work : String = ""
    var is_email_connect : String = ""
    var is_facebook_connect : String = ""
    var is_google_connect : String = ""
    var is_linkedin_connect : String = ""
    var user_id : String = ""
    
    func initiateProfileData(res: NSDictionary) -> UserModel {
        bindData(dic: res, str: "user_id", type: &self.user_id)
        bindData(dic: res, str: "first_name", type: &self.first_name)
        bindData(dic: res, str: "last_name", type: &self.last_name)
        bindData(dic: res, str: "user_name", type: &self.user_name)
        bindData(dic: res, str: "small_image_url", type: &self.small_image_url)
        bindData(dic: res, str: "normal_image_url", type: &self.normal_image_url)
        bindData(dic: res, str: "large_image_url", type: &self.large_image_url)
        bindData(dic: res, str: "dob", type: &self.dob)
        bindData(dic: res, str: "email", type: &self.email)
        bindData(dic: res, str: "user_location", type: &self.user_location)
        bindData(dic: res, str: "member_from", type: &self.member_from)
        bindData(dic: res, str: "about_me", type: &self.about_me)
        bindData(dic: res, str: "school", type: &self.school)
        bindData(dic: res, str: "gender", type: &self.gender)
        bindData(dic: res, str: "phone", type: &self.phone)
        bindData(dic: res, str: "work", type: &self.work)
        bindData(dic: res, str: "is_email_connect", type: &self.is_email_connect)
        bindData(dic: res, str: "is_facebook_connect", type: &self.is_facebook_connect)
        bindData(dic: res, str: "is_google_connect", type: &self.is_google_connect)
        bindData(dic: res, str: "is_linkedin_connect", type: &self.is_linkedin_connect)
        return self
    }
    
}
