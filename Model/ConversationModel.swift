//
//  Conversation.swift
//  Arheb
//
//  Created by devloper65 on 6/2/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ConversationModel: NSObject {
    
    var sucessMessage:String = ""
    var statusCode:String = ""
    var sender_user_name:String = ""
    var sender_thumb_image:String = ""
    var receiver_user_name:String = ""
    var receiver_thumb_image:String = ""
    var arrMessages:[ConversationMessageModel] = [ConversationMessageModel]()
    func addResponseToConversation(res:NSDictionary) -> ConversationModel{
        
        bindData(dic: res, str: "success_message", type: &self.sucessMessage)
        bindData(dic: res, str: "status_code", type: &self.statusCode)
        bindData(dic: res, str: "sender_user_name", type: &self.sender_user_name)
        bindData(dic: res, str: "sender_thumb_image", type: &self.sender_thumb_image)
        bindData(dic: res, str: "receiver_user_name", type: &self.receiver_user_name)
        bindData(dic: res, str: "receiver_thumb_image", type: &self.receiver_thumb_image)
        if(res.value(forKey: "data") != nil){
            let arrData:NSArray = res.value(forKey: "data") as! NSArray
            for dict in arrData{
                let tmpDict:NSDictionary = dict as! NSDictionary
                var objConMess = ConversationMessageModel()
                objConMess = objConMess.addResponseToConversationMessage(res: tmpDict)
                self.arrMessages.append(objConMess)
            }
        }
        return self
    }
    
    
}
