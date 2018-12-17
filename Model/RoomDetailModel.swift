
import Foundation
import UIKit

class RoomDetailModel : NSObject {
    
    var room_id : String = ""
    var room_price : String = ""
    var room_name : String = ""
    var room_images : NSArray!
    var rating_value : String = ""
    var reviews_count : String = ""
    var is_whishlist : String = ""
    var room_share_url : String = ""
    var host_user_id : String = ""
    var host_user_name : String = ""
    var room_type : String = ""
    var host_user_image : String = ""
    var no_of_guest : String = ""
    var no_of_beds : String = ""
    var no_of_bedrooms : String = ""
    var no_of_bathrooms : String = ""
    var locaiton_name : String = ""
    var loc_latidude : String = ""
    var loc_longidude : String = ""
    var review_user_name : String = ""
    var review_user_image : String = ""
    var review_date : String = ""
    var review_message : String = ""
    var review_value : String = ""
    var room_detail : String = ""
    var check_in_time : String = ""
    var check_out_time : String = ""
    var weekly_price : String = ""
    var monthly_price : String = ""
    var security_deposit : String = ""
    var additional_guests : String = ""
    var cleaning_fee : String = ""
    var currency_symbol : String = ""
    var currency_code : String = ""
    var instant_book : String = ""
    var house_rules : String = ""
    var cancellation_policy : String = ""
    var can_book : String = ""
    
    var review_count : String = ""
    var cleaning : String = ""
    var additional_guest : String = ""
    var guests : String = ""
    var security : String = ""
    var weekend : String = ""
    
    var amenitiesList = [AminitiesModel]()
    var similar_list_details = [ExploreModel]()
    var blocked_dates : NSArray!
    
    func initiateRoomData(res: NSDictionary) -> RoomDetailModel{
        let obj = RoomDetailModel()
        bindData(dic: res, str: "can_book", type: &obj.can_book)
        bindData(dic: res, str: "instant_book", type: &obj.instant_book)
        bindData(dic: res, str: "room_id", type: &obj.room_id)
        bindData(dic: res, str: "room_price", type: &obj.room_price)
        bindData(dic: res, str: "room_name", type: &obj.room_name)
        bindData(dic: res, str: "room_share_url", type: &obj.room_share_url)
        bindData(dic: res, str: "is_whishlist", type: &obj.is_whishlist)
        bindData(dic: res, str: "rating_value", type: &obj.rating_value)
        bindData(dic: res, str: "host_user_id", type: &obj.host_user_id)
        bindData(dic: res, str: "host_user_name", type: &obj.host_user_name)
        bindData(dic: res, str: "room_type", type: &obj.room_type)
        bindData(dic: res, str: "host_user_image", type: &obj.host_user_image)
        bindData(dic: res, str: "no_of_guest", type: &obj.no_of_guest)
        bindData(dic: res, str: "no_of_beds", type: &obj.no_of_beds)
        bindData(dic: res, str: "no_of_bedrooms", type: &obj.no_of_bedrooms)
        bindData(dic: res, str: "no_of_bathrooms", type: &obj.no_of_bathrooms)
        bindData(dic: res, str: "locaiton_name", type: &obj.locaiton_name)
        bindData(dic: res, str: "loc_latidude", type: &obj.loc_latidude)
        bindData(dic: res, str: "loc_longidude", type: &obj.loc_longidude)
        
        bindData(dic: res, str: "review_user_name", type: &obj.review_user_name)
        bindData(dic: res, str: "review_user_image", type: &obj.review_user_image)
        bindData(dic: res, str: "review_date", type: &obj.review_date)
        bindData(dic: res, str: "review_message", type: &obj.review_message)
        bindData(dic: res, str: "review_count", type: &obj.review_count)
        bindData(dic: res, str: "room_detail", type: &obj.room_detail)
        bindData(dic: res, str: "cancellation_policy", type: &obj.cancellation_policy)
        bindData(dic: res, str: "weekly_price", type: &obj.weekly_price)
        bindData(dic: res, str: "monthly_price", type: &obj.monthly_price)
        bindData(dic: res, str: "cleaning", type: &obj.cleaning)
        
        bindData(dic: res, str: "additional_guest", type: &obj.additional_guest)
        bindData(dic: res, str: "guests", type: &obj.guests)
        bindData(dic: res, str: "security", type: &obj.security)
        
        bindData(dic: res, str: "weekend", type: &obj.weekend)
        bindData(dic: res, str: "house_rules", type: &obj.house_rules)
        bindData(dic: res, str: "currency_code", type: &obj.currency_code)
        
        bindData(dic: res, str: "currency_symbol", type: &obj.currency_symbol)
        bindData(dic: res, str: "house_rules", type: &obj.house_rules)
        bindData(dic: res, str: "currency_code", type: &obj.currency_code)
        
        if let room_images = res["room_images"] as? NSArray {
            obj.room_images = room_images
        }
        
        if let amenities_values = res["amenities_values"] as? NSArray {
            obj.amenitiesList = AminitiesModel().initiateAminityData(arrRes: amenities_values)
        }
        
        if let blocked_dates = res["blocked_dates"] as? NSArray {
            obj.blocked_dates = blocked_dates
        }
        
        if let similar_list_details = res["similar_list_details"] as? NSArray {
            obj.similar_list_details = ExploreModel().initiateExploreData(arrRes: similar_list_details)
        }
        
        return obj
    }
    
    
    
}
