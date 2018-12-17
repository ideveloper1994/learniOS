//
//  InboxModel.swift
//  Arheb
//
//  Created on 6/9/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class InboxModel: NSObject {
    var check_in_time : String = ""
    var check_out_time : String = ""
    var host_thumb_image : String = ""
    var host_user_id : String = ""
    var request_user_id : String = ""
    var host_user_name : String = ""
    var last_message : String = ""
    var last_message_date_time : String = ""
    var message_status : String = ""
    var message_type : String = ""
    var reservation_id : String = ""
    var review_count : String = ""
    var room_location : String = ""
    var room_name : String = ""
    var total_cost : String = ""
    var unread_message_count : String = ""
    var user_location : String = ""
    var room_id : String = ""
    var is_message_read : String = ""
    var trip_status : String = ""
    
    var room_thumb_image : String = ""
    var total_guest : String = ""
    var total_nights : String = ""
    var host_member_since_from : String = ""
    
    var booking_status : String = ""
    
    func initiateInboxData(arrRes: NSArray) -> [InboxModel]{
        var arrInbox = [InboxModel]()
        for response in arrRes{
            let res = response as! NSDictionary
            let obj = InboxModel()
            bindData(dic: res, str: "reservation_id", type: &obj.reservation_id)
            bindData(dic: res, str: "room_id", type: &obj.room_id)
            bindData(dic: res, str: "is_message_read", type: &obj.is_message_read)
            bindData(dic: res, str: "message_status", type: &obj.message_status)
            bindData(dic: res, str: "host_user_name", type: &obj.host_user_name)
            bindData(dic: res, str: "host_thumb_image", type: &obj.host_thumb_image)
            bindData(dic: res, str: "last_message_date_time", type: &obj.last_message_date_time)
            bindData(dic: res, str: "room_name", type: &obj.room_name)
            bindData(dic: res, str: "room_location", type: &obj.room_location)
            bindData(dic: res, str: "last_message", type: &obj.last_message)
            bindData(dic: res, str: "check_in_time", type: &obj.check_in_time)
            bindData(dic: res, str: "check_out_time", type: &obj.check_out_time)
            bindData(dic: res, str: "total_cost", type: &obj.total_cost)
            bindData(dic: res, str: "host_user_id", type: &obj.host_user_id)
            bindData(dic: res, str: "request_user_id", type: &obj.request_user_id)
            bindData(dic: res, str: "user_location", type: &obj.user_location)
            bindData(dic: res, str: "room_thumb_image", type: &obj.room_thumb_image)
            bindData(dic: res, str: "total_guest", type: &obj.total_guest)
            bindData(dic: res, str: "total_nights", type: &obj.total_nights)
            bindData(dic: res, str: "host_member_since_from", type: &obj.host_member_since_from)
            bindData(dic: res, str: "review_count", type: &obj.review_count)
            bindData(dic: res, str: "unread_message_count", type: &obj.unread_message_count)
            bindData(dic: res, str: "trip_status", type: &obj.trip_status)
            bindData(dic: res, str: "booking_status", type: &obj.booking_status)
            arrInbox.append(obj)
        }
        return arrInbox
    }
}
