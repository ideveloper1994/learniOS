//
//  ExploreModel.swift
//  Arheb
//
//  Created on 6/5/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation


class ExploreModel : NSObject {
    
    var room_id : String = ""
    var room_type : String = ""
    var room_price : String = ""
    var room_name : String = ""
    var room_thumb_image : String = ""
    var rating_value : String = ""
    var reviews_count : String = ""
    var is_wishlist : String = ""
    var is_whishlist : String = ""
    var instant_book : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var country_name : String = ""
    var city_name : String = ""
    var currency_code : String = ""
    var currency_symbol : String = ""
    var reviews_value: String = ""
    
    
    func initiateExploreData(arrRes: NSArray) -> [ExploreModel]{
        var arrExplore = [ExploreModel]()
        for response in arrRes{
            let res = response as! NSDictionary
            let obj = ExploreModel()
            bindData(dic: res, str: "room_id", type: &obj.room_id)
            bindData(dic: res, str: "room_price", type: &obj.room_price)
            bindData(dic: res, str: "room_name", type: &obj.room_name)
            bindData(dic: res, str: "room_thumb_image", type: &obj.room_thumb_image)
            bindData(dic: res, str: "rating_value", type: &obj.rating_value)
            bindData(dic: res, str: "reviews_count", type: &obj.reviews_count)
            bindData(dic: res, str: "is_wishlist", type: &obj.is_wishlist)
            bindData(dic: res, str: "is_whishlist", type: &obj.is_whishlist)
            bindData(dic: res, str: "country_name", type: &obj.country_name)
            bindData(dic: res, str: "city_name", type: &obj.city_name)
            bindData(dic: res, str: "currency_code", type: &obj.currency_code)
            bindData(dic: res, str: "reviews_value", type: &obj.reviews_value)
//            obj.currency_symbol = getSymbolForCurrencyCode(code: obj.currency_code)!
            
            //bindData(dic: res, str: "currency_symbol", type: &obj.currency_symbol)
            obj.currency_symbol = GETVALUE(USER_CURRENCY_SYMBOL)
            bindData(dic: res, str: "instant_book", type: &obj.instant_book)
            bindData(dic: res, str: "latitude", type: &obj.latitude)
            bindData(dic: res, str: "longitude", type: &obj.longitude)
            bindData(dic: res, str: "room_type", type: &obj.room_type)
            bindData(dic: res, str: "instant_book", type: &obj.instant_book)
            arrExplore.append(obj)
        }
        return arrExplore
    }
    
    
}
