/**
* PrePaymentModel.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/


import Foundation
import UIKit

class PrePaymentModel : NSObject
{
    //MARK Properties
    var no_of_bedrooms : String = ""
    var no_of_bathrooms : String = ""
    var currency_code : String = ""
    var currency_symbol : String = ""
    var description_details : String = ""
    var end_date : String = ""
    var host_user_name : String = ""
    var host_user_image : String = ""
    var nights_count : String = ""
    var per_night_price : String = ""
    var policy_name : String = ""
    var room_name : String = ""
    var room_type : String = ""
    var service_fee : String = ""
    var start_date : String = ""
    var status_code : String = ""
    var success_message : String = ""
    var total_price : String = ""
    var cleaning_fee : String = ""
    var addition_guest_fee : String = ""
    var security_fee : String = ""
    var rooms_total_guest : String = ""
    
    func addResponseToPayment(res:NSDictionary) -> PrePaymentModel{
        bindData(dic: res, str: "room_name", type: &self.room_name)
        bindData(dic: res, str: "bedrooms", type: &self.no_of_bedrooms)
        bindData(dic: res, str: "currency_code", type: &self.currency_code)
        bindData(dic: res, str: "currency_symbol", type: &self.currency_symbol)
        bindData(dic: res, str: "description", type: &self.description_details)
        bindData(dic: res, str: "end_date", type: &self.end_date)
        bindData(dic: res, str: "host_user_name", type: &self.host_user_name)
        bindData(dic: res, str: "host_user_thumb_image", type: &self.host_user_image)
        bindData(dic: res, str: "nights_count", type: &self.nights_count)
        bindData(dic: res, str: "per_night_price", type: &self.per_night_price)
        bindData(dic: res, str: "policy_name", type: &self.policy_name)
        bindData(dic: res, str: "room_type", type: &self.room_type)
        bindData(dic: res, str: "service_fee", type: &self.service_fee)
        bindData(dic: res, str: "status_code", type: &self.status_code)
        bindData(dic: res, str: "success_message", type: &self.success_message)
        bindData(dic: res, str: "cleaning_fee", type: &self.cleaning_fee)
        bindData(dic: res, str: "additional_guest", type: &self.addition_guest_fee)
        bindData(dic: res, str: "security_fee", type: &self.security_fee)
        bindData(dic: res, str: "rooms_total_guest", type: &self.rooms_total_guest)
        bindData(dic: res, str: "bathrooms", type: &self.no_of_bathrooms)
        bindData(dic: res, str: "start_date", type: &self.start_date)
        bindData(dic: res, str: "total_price", type: &self.total_price)
        
        return self
        
    }
}
