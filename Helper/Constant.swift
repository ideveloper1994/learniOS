//
//  Constant.swift
//  Arheb
//
//  Created on 5/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

let BASE_CODE = "en"
let ARABIC_CODE = "ar"
let ENGLISH_CODE = "en"

extension String{
    func localize() -> String{
        let path = Bundle.main.path(forResource: appDelegate?.currentLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

func setLanguage(langCode: String){
    appDelegate?.currentLanguage = langCode
    let defsults = UserDefaults.standard
    defsults.set(appDelegate?.currentLanguage, forKey: "AppLanguage")
    defsults.synchronize()
}

struct TabbarTravel{
    static let titleSaved = "SAVED"
    static let titleExplore = "EXPLORE"
    static let titleTrips = "TRIPS"
    static let titleInbox = "INBOX"
    static let titleProfile = "PROFILE"
}

struct TabbarHost{
    static let titleReservation = "RESERVATIONS"
    static let titleListing = "LISTING"
    static let titleCalendar = "CALENDAR"
    static let titleProfile = "PROFILE"
}

let appDelegate = UIApplication.shared.delegate as? AppDelegate

struct Arheb{
    static let maxEnterText = 500
}

struct UserDefaultKey{
    static let kHostorTravel = "HostOrTravel"
    static let kLoggedIn = "logged_in"
}

struct HostOrTravel{
    static let host = "Host"
    static let travel = "Travel"
}

struct Screen {
    static let device = UIDevice.current.userInterfaceIdiom
    static var width = UIScreen.main.bounds.width
    static var height = UIScreen.main.bounds.height
}

struct AppColor {
    static let color = UIColor(colorLiteralRed: 4/255, green: 166/255, blue: 152/255, alpha: 1)
    static let dark_border = UIColor(colorLiteralRed: 207/255, green: 207/255, blue: 207/255, alpha: 1)
    static let light_border = UIColor(colorLiteralRed: 223/255, green: 224/255, blue: 231/255, alpha: 1)
    static let mainColor = #colorLiteral(red: 0.1833160818, green: 0.653447032, blue: 0.5964687467, alpha: 1)
    static let sendBtnColor = #colorLiteral(red: 0.1824345291, green: 0.6602292061, blue: 0.5964571238, alpha: 1)
    static let disableSendBtnColor = #colorLiteral(red: 0.1824345291, green: 0.6602292061, blue: 0.5964571238, alpha: 0.5)
}

struct AppFont {
    static let CIRCULAR_BOLD = "CircularAirPro-Bold"
    static let CIRCULAR_LIGHT = "CircularAirPro-Light"
    static let CIRCULAR_BOOK = "CircularAirPro-Book"
    
    static let MAKENT_LOGO_FONT1 = "makent1"
    static let MAKENT_LOGO_FONT2 = "makent2"
    static let MAKENT_LOGO_FONT3 = "makent3"
    static let MAKENT_AMENITIES_FONT = "makent-amenities"
}

struct keyChainKey{
    static let authenticationToken = "AuthenticationToken"
    static let email = "email"
    static let password = "password"
}

struct NotificationName {
    static let addWishlist = "AddWishlist"
    static let instagramToken = "InstagramToken"
}


let characterEntities : [ String : Character ] = [
    // XML predefined entities:
    "&pound;"    : "£",
    "&euro;"     : "€",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]


// MARK: Constant Strings

let USER_CURRENCY_SYMBOL = "user_currency_symbol"
let USER_CURRENCY_ORG = "user_currency_org"
let USER_CURRENCY_SYMBOL_ORG = "user_currency_symbol_org"
let USER_CURRENCY = "user_currency"
let USER_LOCATION = "UserLocation"
let USER_LATITUDE = "UserLatiude"
let USER_LONGITUDE = "UserLongitude"

let USER_LANGUAGE = "kLanguage"
// MARK: UserDefault Values

func GETVALUE(_ keyname : String) -> String {
    if(UserDefaults.standard.value(forKey: keyname) != nil){
        return UserDefaults.standard.value(forKey: keyname) as! String
    }
    return ""
}

func STOREVALUE(value : String , keyname : String) {
    UserDefaults.standard.setValue(value , forKey: keyname as String)
    UserDefaults.standard.synchronize()
}

