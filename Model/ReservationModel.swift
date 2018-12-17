
import Foundation
import UIKit

class ReservationModel : NSObject {
    
    //MARK Properties
    var success_message : String = ""
    var status_code : String = ""
    var additional_guest_fee : String = ""
    var can_view_receipt : String = ""
    var check_in : String = ""
    var check_out : String = ""
    var cleaning_fee : String = ""
    var currency_symbol : String = ""
    var guest_count : String = ""
    var guest_thumb_image : String = ""
    var guest_user_name : String = ""
    var guest_users_id : String = ""
    var host_thumb_image : String = ""
    var host_user_name : String = ""
    var host_users_id : String = ""
    var payment_recieved_date : String = ""
    var per_night_price : String = ""
    var reservation_id : String = ""
    var room_id : String = ""
    var room_image : String = ""
    var room_location : String = ""
    var room_name : String = ""
    var room_type : String = ""
    var security_deposit : String = ""
    var service_fee : String = ""
    var total_cost : String = ""
    var total_nights : String = ""
    var trip_date : String = ""
    var trip_status : String = ""
    var guest_user_location : String = ""
    var member_from : String = ""

    func initiateReservationData(jsonData: Any) -> [ReservationModel] {
        
        var dataReservation = [ReservationModel]()
        
        let jsonArr = jsonData as! NSDictionary
        let obj = jsonArr.value(forKey: "data") as? NSArray
        for data in obj! {
            let objData = data as! NSDictionary
            let objRes = ReservationModel()
//            //            obj.bindData(str: "id", type: &objUser.id)
            bindData(dic: objData, str: "additional_guest_fee", type: &objRes.additional_guest_fee)
            bindData(dic: objData, str: "can_view_receipt", type: &objRes.can_view_receipt)
            bindData(dic: objData, str: "check_in", type: &objRes.check_in)
            bindData(dic: objData, str: "check_out", type: &objRes.check_out)
            bindData(dic: objData, str: "cleaning_fee", type: &objRes.cleaning_fee)
            bindData(dic: objData, str: "guest_thumb_image", type: &objRes.guest_thumb_image)
            bindData(dic: objData, str: "currency_symbol", type: &objRes.currency_symbol)
            bindData(dic: objData, str: "guest_count", type: &objRes.guest_count)
            bindData(dic: objData, str: "guest_user_name", type: &objRes.guest_user_name)
            bindData(dic: objData, str: "guest_users_id", type: &objRes.guest_users_id)
            bindData(dic: objData, str: "host_thumb_image", type: &objRes.host_thumb_image)
            bindData(dic: objData, str: "host_user_name", type: &objRes.host_user_name)
            bindData(dic: objData, str: "host_users_id", type: &objRes.host_users_id)
            bindData(dic: objData, str: "payment_recieved_date", type: &objRes.payment_recieved_date)
            bindData(dic: objData, str: "per_night_price", type: &objRes.per_night_price)
            bindData(dic: objData, str: "reservation_id", type: &objRes.reservation_id)
            bindData(dic: objData, str: "room_id", type: &objRes.room_id)
            bindData(dic: objData, str: "room_name", type: &objRes.room_name)
            bindData(dic: objData, str: "room_image", type: &objRes.room_image)
            bindData(dic: objData, str: "check_out", type: &objRes.check_out)
            bindData(dic: objData, str: "room_location", type: &objRes.room_location)
            bindData(dic: objData, str: "room_type", type: &objRes.room_type)
            bindData(dic: objData, str: "security_deposit", type: &objRes.security_deposit)
            bindData(dic: objData, str: "service_fee", type: &objRes.service_fee)
            bindData(dic: objData, str: "total_cost", type: &objRes.total_cost)
            bindData(dic: objData, str: "total_nights", type: &objRes.total_nights)
            bindData(dic: objData, str: "trip_date", type: &objRes.trip_date)
            bindData(dic: objData, str: "trip_status", type: &objRes.trip_status)
            bindData(dic: objData, str: "guest_user_location", type: &objRes.guest_user_location)
            bindData(dic: objData, str: "member_from", type: &objRes.member_from)
            dataReservation.append(objRes)
        }
        return dataReservation
    }
}
