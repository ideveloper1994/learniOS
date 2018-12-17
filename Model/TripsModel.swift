import Foundation
import UIKit

class TripsModel : NSObject {
    
    //MARK Properties
    
    var success_message : String = ""
    var status_code : String = ""
    var booking_status : String = ""
    var currency_symbol : String = ""
    var guest_count : String = ""
    var host_thumb_image : String = ""
    var host_user_id : String = ""
    var host_user_name : String = ""
    var room_image : String = ""
    var room_location : String = ""
    var room_name : String = ""
    var room_type : String = ""
    var total_cost : String = ""
    var total_nights : String = ""
    var total_trips_count : String = ""
    var trip_date : String = ""
    var trip_status : String = ""
    var user_name : String = ""
    var user_thumb_image : String = ""
    var reservation_id : String = ""
    var room_id : String = ""
    var per_night_price : String = ""
    var service_fee : String = ""
    var cleaning_fee : String = ""
    var addition_guest_fee : String = ""
    var security_fee : String = ""
    var can_view_receipt : String = ""
    var check_in : String = ""
    var check_out : String = ""

    //MARK: Inits
    func initiateTripsData(jsonData: Any, tripType: String) -> [TripsModel] {
        var dataTrips = [TripsModel]()
        let jsonArr = jsonData as! NSDictionary
        let obj = jsonArr.value(forKey: tripType) as? NSArray
        for data in obj! {
            let objData = data as! NSDictionary
            let objTrips = TripsModel()
            bindData(dic: objData, str: "booking_status", type: &objTrips.booking_status)
            bindData(dic: objData, str: "currency_symbol", type: &objTrips.currency_symbol)
            bindData(dic: objData, str: "guest_count", type: &objTrips.guest_count)
            bindData(dic: objData, str: "host_thumb_image", type: &objTrips.host_thumb_image)
            bindData(dic: objData, str: "host_user_id", type: &objTrips.host_user_id)
            bindData(dic: objData, str: "host_user_name", type: &objTrips.host_user_name)
            bindData(dic: objData, str: "room_image", type: &objTrips.room_image)
            bindData(dic: objData, str: "room_location", type: &objTrips.room_location)
            bindData(dic: objData, str: "room_name", type: &objTrips.room_name)
            bindData(dic: objData, str: "room_type", type: &objTrips.room_type)
            bindData(dic: objData, str: "total_cost", type: &objTrips.total_cost)
            bindData(dic: objData, str: "total_nights", type: &objTrips.total_nights)
            bindData(dic: objData, str: "total_trips_count", type: &objTrips.total_trips_count)
            bindData(dic: objData, str: "trip_date", type: &objTrips.trip_date)
            bindData(dic: objData, str: "trip_status", type: &objTrips.trip_status)
            bindData(dic: objData, str: "check_in", type: &objTrips.check_in)
            bindData(dic: objData, str: "check_out", type: &objTrips.check_out)
            bindData(dic: objData, str: "room_id", type: &objTrips.room_id)
            bindData(dic: objData, str: "user_name", type: &objTrips.user_name)
            bindData(dic: objData, str: "user_thumb_image", type: &objTrips.user_thumb_image)
            bindData(dic: objData, str: "reservation_id", type: &objTrips.reservation_id)
            bindData(dic: objData, str: "per_night_price", type: &objTrips.per_night_price)
            bindData(dic: objData, str: "service_fee", type: &objTrips.service_fee)
            bindData(dic: objData, str: "cleaning_fee", type: &objTrips.cleaning_fee)
            bindData(dic: objData, str: "additional_guest_fee", type: &objTrips.addition_guest_fee)
            bindData(dic: objData, str: "security_deposit", type: &objTrips.security_fee)
            bindData(dic: objData, str: "can_view_receipt", type: &objTrips.can_view_receipt)
            dataTrips.append(objTrips)

        }
        return dataTrips
    }
}
