//
//  GuestUserModel.swift
//  Arheb
//
//  Created on 6/5/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class GuestUserModel: NSObject {
    var first_name : String = ""
    var last_name : String = ""
    var large_image : String = ""
    var user_location : String = ""
    var member_from : String = ""
    var about_me : String = ""
    
    
    func initiateProfileData(res: NSDictionary) -> GuestUserModel {
        bindData(dic: res, str: "first_name", type: &self.first_name)
        bindData(dic: res, str: "last_name", type: &self.last_name)
        bindData(dic: res, str: "large_image", type: &self.large_image)
        bindData(dic: res, str: "user_location", type: &self.user_location)
        bindData(dic: res, str: "member_from", type: &self.member_from)
        bindData(dic: res, str: "about_me", type: &self.about_me)
        return self
    }
    

}
