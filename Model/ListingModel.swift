/**
 * ListingModel.swift
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

class ListingModel : NSObject {
    
    //MARK Properties
    var success_message : String = ""
    var status_code : String = ""
    var room_id : String = ""
    var room_type : String = ""
    var room_name : String = ""
    var remaining_steps : String = ""
    var room_title : String = ""
    var room_description : String = ""
    var room_price : String = ""
    var room_location : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var additional_rules_msg : String = ""
    var selected_amenities_id : String = ""
    var isListEnabled : String = ""
    var room_thumb_images : NSMutableArray = NSMutableArray()
    var home_type : String = ""
    var max_guest_count : String = ""
    var bedroom_count : String = ""
    var beds_count : String = ""
    var bathrooms_count : String = ""
    var weekly_price : String = ""
    var monthly_price : String = ""
    var cleaningFee:String = ""
    var additionGuestFee:String = ""
    var additionGuestCount:String = ""
    var securityDeposit:String = ""
    var weekendPrice:String = ""
    var booking_type:String = ""
    var policy_type:String = ""
    var currency_code:String = ""
    var currency_symbol:String = ""
    var room_thumb_image_ids : NSMutableArray = NSMutableArray()
    var blocked_dates : NSArray?
    var reserved_dates : NSArray?
    var nightly_price : NSArray?
    
    var street_name:String = ""
    var street_address:String = ""
    var city_name:String = ""
    var state_name:String = ""
    var country_name:String = ""
    var zipcode:String = ""
    
    var listed_rooms : NSArray?
    var un_listed_rooms : NSArray?

    
   // MARK: Inits
    func initiateListingData(jsonData: Any) -> [ListingModel] {
        var dataListing = [ListingModel]()

        let data = jsonData as! NSArray
        
        for newdata in data {
            let objList = ListingModel()
            let obj = newdata as! NSDictionary
            bindData(dic: obj, str: "room_id", type: &objList.room_id)
            bindData(dic: obj, str: "room_price", type: &objList.room_price)
            bindData(dic: obj, str: "room_name", type: &objList.room_name)
            bindData(dic: obj, str: "room_type", type: &objList.room_type)
            bindData(dic: obj, str: "remaining_steps", type: &objList.remaining_steps)
            bindData(dic: obj, str: "room_title", type: &objList.room_title)
            bindData(dic: obj, str: "room_description", type: &objList.room_description)
            bindData(dic: obj, str: "room_location", type: &objList.room_location)
            bindData(dic: obj, str: "latitude", type: &objList.latitude)
            bindData(dic: obj, str: "longitude", type: &objList.longitude)
            bindData(dic: obj, str: "additional_rules_msg", type: &objList.additional_rules_msg)
            bindData(dic: obj, str: "home_type", type: &objList.home_type)
            bindData(dic: obj, str: "max_guest_count", type: &objList.max_guest_count)
            bindData(dic: obj, str: "bedroom_count", type: &objList.bedroom_count)
            bindData(dic: obj, str: "beds_count", type: &objList.beds_count)
            bindData(dic: obj, str: "bathrooms_count", type: &objList.bathrooms_count)
            bindData(dic: obj, str: "weekly_price", type: &objList.weekly_price)
            bindData(dic: obj, str: "monthly_price", type: &objList.monthly_price)
            bindData(dic: obj, str: "cleaning_fee", type: &objList.cleaningFee)
            bindData(dic: obj, str: "additional_guests_fee", type: &objList.additionGuestFee)
            bindData(dic: obj, str: "for_each_guest", type: &objList.additionGuestCount)
            bindData(dic: obj, str: "security_deposit", type: &objList.securityDeposit)
            bindData(dic: obj, str: "weekend_pricing", type: &objList.weekendPrice)
            bindData(dic: obj, str: "beds_count", type: &objList.beds_count)
            bindData(dic: obj, str: "bathrooms_count", type: &objList.bathrooms_count)
            bindData(dic: obj, str: "weekly_price", type: &objList.weekly_price)
            bindData(dic: obj, str: "booking_type", type: &objList.booking_type)
            bindData(dic: obj, str: "policy_type", type: &objList.policy_type)
            bindData(dic: obj, str: "amenities", type: &objList.selected_amenities_id)
            bindData(dic: obj, str: "is_list_enabled", type: &objList.isListEnabled)
            bindData(dic: obj, str: "room_currency_code", type: &objList.currency_code)
            bindData(dic: obj, str: "room_currency_symbol", type: &objList.currency_symbol)
            bindData(dic: obj, str: "street_name", type: &objList.street_name)
            bindData(dic: obj, str: "street_address", type: &objList.street_address)
            bindData(dic: obj, str: "city", type: &objList.city_name)
            bindData(dic: obj, str: "state", type: &objList.state_name)
            bindData(dic: obj, str: "country", type: &objList.country_name)
            bindData(dic: obj, str: "zip", type: &objList.zipcode)
            bindData(dic: obj, str: "longitude", type: &objList.longitude)
            bindData(dic: obj, str: "additional_rules_msg", type: &objList.additional_rules_msg)
            
            if let latestValue = obj["room_thumb_images"] as? NSArray {
                objList.room_thumb_images = latestValue.mutableCopy() as! NSMutableArray
            }
            if let latestValue = obj["room_image_id"] as? NSArray {
                objList.room_thumb_image_ids = latestValue.mutableCopy() as! NSMutableArray
            }
            if let latestValue = obj["blocked_dates"] as? NSArray {
                objList.blocked_dates = latestValue
            }
            if let latestValue = obj["reserved_dates"] as? NSArray {
                objList.reserved_dates = latestValue
            }
            if let latestValue = obj["nightly_price"] as? NSArray {
                objList.nightly_price = latestValue
            }
            dataListing.append(objList)
        }
        return dataListing
    }
    

}
