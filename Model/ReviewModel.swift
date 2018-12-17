//
//  ReviewModel.swift
//  Arheb
//
//  Created on 6/14/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation

class ReviewsModel : NSObject {
    
    var accuracy_value : String = ""
    var check_in_value : String = ""
    var cleanliness_value : String = ""
    var communication_value : String = ""
    var location_value : String = ""
    var value : String = ""
    var total_review : String = ""
    
    var userDetails = [ReviewUserModel]()
    
    func initiateReviewData(responseDict: NSDictionary) -> ReviewsModel {
        
        bindData(dic: responseDict, str: "total_review", type: &self.total_review)
        bindData(dic: responseDict, str: "accuracy_value", type: &self.accuracy_value)
        bindData(dic: responseDict, str: "check_in_value", type: &self.check_in_value)
        bindData(dic: responseDict, str: "cleanliness_value", type: &self.cleanliness_value)
        bindData(dic: responseDict, str: "communication_value", type: &self.communication_value)
        bindData(dic: responseDict, str: "location_value", type: &self.location_value)
        bindData(dic: responseDict, str: "value", type: &self.value)
        
        if let userArray = responseDict["data"] as? NSArray {
            self.userDetails = ReviewUserModel().initiateUserData(arrRes: userArray)
        }
        
        return self
    }
    
}

class ReviewUserModel: NSObject {
    
    var review_user_name : String = ""
    var review_user_image : String = ""
    var review_date : String = ""
    var review_message : String = ""
    
    func initiateUserData(arrRes: NSArray) -> [ReviewUserModel]{
        var arrReview = [ReviewUserModel]()
        for response in arrRes {
            let res = response as! NSDictionary
            let obj = ReviewUserModel()
            bindData(dic: res, str: "review_user_name", type: &obj.review_user_name)
            bindData(dic: res, str: "review_user_image", type: &obj.review_user_image)
            bindData(dic: res, str: "review_date", type: &obj.review_date)
            bindData(dic: res, str: "review_message", type: &obj.review_message)
            arrReview.append(obj)
        }
        return arrReview
    }

    
}
