//
//  CreateURL.swift
//  Arheb
//
//  Created on 5/30/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit


class ArhebCreateUrl: NSObject
{

    static func generateGetUrl(apiName: String, params: NSDictionary) -> String {
        var queryString = "";
        var urlString:NSString = NSString()
        for key in params{
            queryString = "\(queryString)&\(key.key)=\(key.value)"
        }
        if(queryString.characters.count > 0){
            queryString.remove(at: queryString.startIndex)
            urlString = "\(baseUrl)\(apiName)?\(queryString)" as NSString
        }else{
            urlString = "\(baseUrl)\(apiName)" as NSString
        }
  
        print("\(baseUrl)\(apiName)?\(queryString)")
       // let urlString:NSString = "\(baseUrl)\(apiName)?\(queryString)" as NSString
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodedUrl!
    }
    
}
