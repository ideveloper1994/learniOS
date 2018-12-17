//
//  CustomLocationModel.swift
//  Arheb
//
//  Created by devloper65 on 6/16/17.
//  Copyright © 2017 Arheb. All rights reserved.
//


import UIKit

class CustomLocationModel: NSObject {
    //MARK Properties
    
    var geoplugin_areaCode : String = ""
    var geoplugin_city : String = ""
    var geoplugin_continentCode : String = ""
    var geoplugin_countryCode : String = ""
    var geoplugin_countryName : String = ""
    var geoplugin_currencyCode : String = ""
    var geoplugin_currencyConverter : String = ""
    var geoplugin_currencySymbol : String = ""
    var geoplugin_currencySymbol_UTF8 : String = ""
    var geoplugin_dmaCode : String = ""
    var geoplugin_latitude : String = ""
    var geoplugin_longitude : String = ""
    var geoplugin_region : String = ""
    var geoplugin_regionCode : String = ""
    var geoplugin_regionName : String = ""
    var geoplugin_request : String = ""
    var geoplugin_status : String = ""
    
    
    
    // MARK: Inits
    
    func initiateCustomLocationData(responseDict: NSDictionary) -> CustomLocationModel {
        bindData(dic: responseDict, str: "geoplugin_areaCode", type: &self.geoplugin_areaCode)
        bindData(dic: responseDict, str: "geoplugin_city", type: &self.geoplugin_city)
        bindData(dic: responseDict, str: "geoplugin_continentCode", type: &self.geoplugin_continentCode)
        bindData(dic: responseDict, str: "geoplugin_countryCode", type: &self.geoplugin_countryCode)
        bindData(dic: responseDict, str: "geoplugin_countryName", type: &self.geoplugin_countryName)
        bindData(dic: responseDict, str: "geoplugin_currencyCode", type: &self.geoplugin_currencyCode)
        bindData(dic: responseDict, str: "geoplugin_currencyConverter", type: &self.geoplugin_currencyConverter)
        bindData(dic: responseDict, str: "geoplugin_currencySymbol", type: &self.geoplugin_currencySymbol)
        bindData(dic: responseDict, str: "geoplugin_currencySymbol_UTF8", type: &geoplugin_currencySymbol_UTF8)
        bindData(dic: responseDict, str: "geoplugin_dmaCode", type: &self.geoplugin_dmaCode)
        bindData(dic: responseDict, str: "geoplugin_latitude", type: &self.geoplugin_latitude)
        bindData(dic: responseDict, str: "geoplugin_longitude", type: &self.geoplugin_longitude)
        bindData(dic: responseDict, str: "geoplugin_region", type: &self.geoplugin_region)
        bindData(dic: responseDict, str: "geoplugin_regionCode", type: &self.geoplugin_regionCode)
        bindData(dic: responseDict, str: "geoplugin_regionName", type: &self.geoplugin_regionName)
        bindData(dic: responseDict, str: "geoplugin_request", type: &geoplugin_request)
        bindData(dic: responseDict, str: "geoplugin_status", type: &self.geoplugin_status)
        return self
    }
}
