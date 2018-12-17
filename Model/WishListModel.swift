//
//  WishListModel.swift
//  Arheb
//
//  Created on 6/5/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation


class WishListModel : NSObject {
    
    var list_id : String = ""
    var list_name : String = ""
    var privacy : String = ""
    var room_thumb_images : NSArray?
    
    func initiateWishListData(arrRes: NSArray) -> [WishListModel]{
        var arrWishList = [WishListModel]()
        for response in arrRes{
            let res = response as! NSDictionary
            let obj = WishListModel()
            bindData(dic: res, str: "list_id", type: &obj.list_id)
            bindData(dic: res, str: "list_name", type: &obj.list_name)
            bindData(dic: res, str: "privacy", type: &obj.privacy)
            if let latestValue = res["room_thumb_images"] as? NSArray{
                obj.room_thumb_images = latestValue
            }
            arrWishList.append(obj)
        }
        return arrWishList
    }

}

//class WishListRoomModel : NSObject {
//    
//    var room_id : String = ""
//    var user_id : String = ""
//    var room_thumb_image : String = ""
//    
//    // MARK: Inits
//    func initiateWishListRoomData(responseDict: NSDictionary) -> Any
//    {
//        room_id =  self.checkParamTypes(params: responseDict, keys:"room_id")
//        room_thumb_image = self.checkParamTypes(params: responseDict, keys:"room_thumb_image")
//        user_id = self.checkParamTypes(params: responseDict, keys:"user_id")
//        return self
//    }
//    
//}
