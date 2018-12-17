//
//  Utils.swift
//  Arheb
//
//  Created on 5/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FLAnimatedImage

//MARK:- Global method to store string in user defaults
func setNsuserDefaultValue(value:String,key:String){
    UserDefaults.standard.set(value, forKey: key)
}

//MARK:- get Value by key from the dictionary
func bindData<T>(dic: NSDictionary,str: String, type: inout T){
    if let val: T = dic[str] as? T{
        type = val
    }else{
        if let val = dic[str]{
            let strVal = String(describing: val)
            if let val: T = strVal as? T{
                type = val
            }
        }
    }
}

//MARK:- set User details in Userdefaults after login
func setUserDetails(user: LoginModel) {
    let defaults = UserDefaults.standard
    let userData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
    defaults.set(userData, forKey: "User")
    defaults.set(true, forKey: UserDefaultKey.kLoggedIn)
    defaults.synchronize()
}

//MARK:- get User details from user defaults
func getUserDetails() -> LoginModel? {
    let defaults = UserDefaults.standard
    if defaults.value(forKey: "User") != nil{
        let nsData = defaults.value(forKey: "User") as! Data
        let objUser = NSKeyedUnarchiver.unarchiveObject(with: nsData) as! LoginModel
        return objUser
    }
    return nil
}

//MARK: Release all details when logout
func onLogout(){
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "User")
    defaults.set(false, forKey: UserDefaultKey.kLoggedIn)
    defaults.synchronize()
    KeychainWrapper.standard.removeObject(forKey: keyChainKey.authenticationToken)
    setNsuserDefaultValue(value: HostOrTravel.travel, key: UserDefaultKey.kHostorTravel)
    appDelegate?.arrWishList.removeAll()
    
}

// MARK: Convert Currency Code to Symbol
func getSymbolForCurrencyCode(code: String) -> String?
{
    let locale = NSLocale(localeIdentifier: code)
    return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code) as String?
}

func createRatingStar(ratingValue : String) -> String {
    //U -> Fullstar Y -> half star V -> empty star
//    let rangeYours = ratingValue.range(of: ".")
    if ratingValue == "0"{
        return "VVVVV"
    }
    
    let arrRating = ratingValue.components(separatedBy: ".")
    var strStar = ""
    if arrRating.count == 1{
        if arrRating[0] == "1"{
            strStar = "UVVVV"
        }else if arrRating[0] == "2"{
            strStar = "UUVVV"
        }else if arrRating[0] == "3"  {
            strStar = "UUUVV"
        } else if arrRating[0] == "4"{
            strStar = "UUUUV"
        } else if arrRating[0] == "5" {
            strStar = "UUUUU"
        }
    }else {
        if ratingValue == "0.5"  {
            strStar = "YVVVV"
        } else if ratingValue == "1.5" {
            strStar = "UYVVV"
        }else if ratingValue == "2.5"{
            strStar = "UUYVV"
        }else if ratingValue == "3.5"{
            strStar = "UUUYV"
        } else if ratingValue == "4.5"  {
            strStar = "UUUUV"
        }
    }
    return strStar as String
}


//MARK: Apply Attributed text

func attributedConversationText(originalText: NSString, boldText: String , fontSize : CGFloat)->NSAttributedString
{
    let attributedString = NSMutableAttributedString(string: originalText as String, attributes: [NSFontAttributeName:UIFont (name: AppFont.CIRCULAR_LIGHT, size: fontSize)!])
    
    let boldFontAttribute = [NSFontAttributeName: UIFont (name: AppFont.CIRCULAR_BOLD, size: fontSize)!]
    
    // Part of string to be bold
    attributedString.addAttributes(boldFontAttribute, range: originalText.range(of: boldText))
    
    return attributedString
}

func addBoldText(fullString: NSString, boldPartOfString: NSString, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
    let nonBoldFontAttribute = [NSFontAttributeName:font!]
    let boldFontAttribute = [NSFontAttributeName:boldFont!]
    let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
    boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartOfString as String))
    return boldString
}

func getBigAndNormalString(originalText : NSString ,normalText : NSString, attributeText : NSString , font : UIFont) -> NSMutableAttributedString {
    let mainString: NSMutableAttributedString = NSMutableAttributedString(string: originalText as String)
    let range = originalText.range(of: attributeText as String)
    mainString.addAttribute(NSFontAttributeName, value:  UIFont (name: AppFont.CIRCULAR_BOOK, size: 18)!, range: NSRange(location: range.location, length: attributeText.length))
    return mainString
}

func attributedTextboldText(_ originalText: NSString, boldText: String , fontSize : CGFloat)->NSAttributedString {
    let attributedString = NSMutableAttributedString(string: originalText as String, attributes: [NSFontAttributeName:UIFont (name: AppFont.CIRCULAR_LIGHT, size: fontSize)!])
    let boldFontAttribute = [NSFontAttributeName: UIFont (name: AppFont.CIRCULAR_BOLD, size: fontSize)!]
    attributedString.addAttributes(boldFontAttribute, range: originalText.range(of: boldText))
    return attributedString
}

func makeHostAttributeTextColor(originalText : NSString ,normalText : NSString, attributeText : NSString , font : UIFont) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: originalText as String, attributes: [NSFontAttributeName:font])
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), range: originalText.range(of: attributeText as String))
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(attributeText.length,normalText.length))
    return attributedString
}

func onGetStringHeight(_ width:CGFloat, strContent:NSString, font:UIFont) -> CGFloat
{
    let sizeOfString = strContent.boundingRect( with: CGSize(width: width, height: CGFloat.infinity), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[NSFontAttributeName: font], context: nil).size
    return sizeOfString.height
}
// MARK: Set Dot Loader GIF

func setDotLoader(_ animatedLoader: FLAnimatedImageView?) {
    if let path =  Bundle.main.path(forResource: "dot_loading", ofType: "gif") {
        if let data = NSData(contentsOfFile: path) {
            let gif = FLAnimatedImage(animatedGIFData: data as Data!)
            animatedLoader?.animatedImage = gif
        }
    }
}



//MARK:- Height for View by Text
func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
    let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

