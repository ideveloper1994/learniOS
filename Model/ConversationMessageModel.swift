//
//  ConversationMessage.swift
//  Arheb
//
//  Created by devloper65 on 6/2/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ConversationMessageModel: NSObject {

    var receiver_thumb_image:String = ""
    var receiver_user_name:String = ""
    var receiver_message_status = ""
    var receiver_messages_dateTime:String = ""
    var receiver_messages:String = ""
    var sender_thumb_image:String = ""
    var sender_user_name:String = ""
    var sender_message_status:String = ""
    var sender_details:String = ""
    var sender_messages_dateTime:String = ""
    var sender_messages:String = ""
    func addResponseToConversationMessage(res:NSDictionary) -> ConversationMessageModel{
        bindData(dic: res, str: "receiver_thumb_image", type: &self.receiver_thumb_image)
        bindData(dic: res, str: "receiver_user_name", type: &self.receiver_user_name)
        bindData(dic: res, str: "receiver_message_status", type: &self.receiver_message_status)
        bindData(dic: res, str: "receiver_messages_date/time", type: &self.receiver_messages_dateTime)
        bindData(dic: res, str: "receiver_messages", type: &self.receiver_messages)
        bindData(dic: res, str: "sender_thumb_image", type: &self.sender_thumb_image)
        bindData(dic: res, str: "sender_user_name", type: &self.sender_user_name)
        bindData(dic: res, str: "sender_message_status", type: &self.sender_message_status)
        bindData(dic: res, str: "sender_details", type: &self.sender_details)
        bindData(dic: res, str: "sender_messages", type: &self.sender_messages)
        bindData(dic: res, str: "sender_messages_date/time", type: &self.sender_messages_dateTime)
        return self
    }
    func addSendMessage(res:NSMutableDictionary) -> ConversationMessageModel{
        bindData(dic: res, str: "message", type: &self.sender_messages)
        bindData(dic: res, str: "message_time", type: &self.sender_messages_dateTime)
        bindData(dic: res, str: "sender_thumb_image", type: &self.sender_thumb_image)
        bindData(dic: res, str: "sender_user_name", type: &self.sender_user_name)
        self.sender_message_status = "0"
        return self
    }
}
