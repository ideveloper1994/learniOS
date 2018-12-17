
import Foundation
import UIKit

class GoogleLocationModel : NSObject {
    
    // MARK:- Properties
    var success_message : String = ""
    var status_code : String = ""
    var street_address : String = ""
    var city_name : String = ""
    var premise_name : String = ""
    var state_name : String = ""
    var postal_code : String = ""
    var country_name : String = ""
    var dictTemp : NSMutableDictionary = NSMutableDictionary()
    
    // MARK:- Inits
    func initiateLocationData(responseDict: NSDictionary) -> Any {
        let locModel = GoogleLocationModel()
        if (responseDict["status"] as! String) as String == "OK" {
            locModel.dictTemp = NSMutableDictionary(dictionary:responseDict)
            locModel.success_message = "Success"
            locModel.status_code = "1"
            let dictMainResult = responseDict.value(forKeyPath: "result.address_components") as! NSArray
            for i in 0 ..< dictMainResult.count {
                let dictOrgResult = dictMainResult[i] as! NSDictionary
                let arrResult = dictOrgResult["types"] as! NSArray
                let strType = arrResult[0] as! String
                if strType == "street_number" {
                    locModel.street_address = dictOrgResult["long_name"] as! String
                } else if strType == "route" {
                    if ((locModel.street_address as String).characters.count > 0) {
                        locModel.street_address = String(format:"%@, %@",locModel.street_address,dictOrgResult["long_name"] as! String)
                    } else {
                        locModel.street_address = String(format: "%@",dictOrgResult["long_name"] as! String)
                    }
                } else if strType == "locality" {
                    locModel.city_name = dictOrgResult["long_name"] as! String
                } else if strType == "premise" {
                    locModel.premise_name = dictOrgResult["long_name"] as! String
                } else if strType == "administrative_area_level_1" {
                    locModel.state_name = dictOrgResult["long_name"] as! String
                } else if strType == "country" {
                    locModel.country_name = dictOrgResult["long_name"] as! String
                } else if strType == "postal_code" {
                    locModel.postal_code = dictOrgResult["long_name"] as! String
                }
            }
        } else {
            locModel.success_message = "Failure"
            locModel.status_code = "0"
        }
        return locModel
    }
}
