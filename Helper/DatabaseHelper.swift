//
//  DatabaseHelper.swift
//  Arheb
//
//  Created by devloper65 on 6/17/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

func addDataToCustomLocationModel(data:NSData) -> CustomLocationModel{
    var obj:CustomLocationModel = CustomLocationModel()
    if let strData = String(data: data as Data, encoding: .utf8) {
        let str = strData.components(separatedBy: "{")
        let arrSepratedStr = strData.replacingOccurrences(of: (str[0]), with: "")
        let arrSeprateSemiColon = arrSepratedStr.components(separatedBy: ";")
        var arrStr = [String]()
        for var strTemp in arrSeprateSemiColon{
            var arrSeprarteColon = strTemp.components(separatedBy: ":")
            if arrSeprarteColon.count == 3{
                if(arrSeprarteColon[2] != "\"geoplugin_credit\""){
                    let string1:String = arrSeprarteColon[2]
                    if(string1.characters.last != "\""){
                        let string2:String = arrSeprarteColon[2] + "\""
                        arrStr.append(string2)
                    }else{
                        arrStr.append(arrSeprarteColon[2])
                    }
                }
            }
            else if arrSeprarteColon.count == 2  {
                if(arrSeprarteColon[1] == "200"){ let string1:String = "\""+"200"+"\""; arrStr.append(string1) }
                else{arrStr.append(arrSeprarteColon[1])}
            }
        }
        var arrStr1 = [String]()
        for i in stride(from: 0, to: arrStr.count, by: 2) {
            let strTemap = arrStr[i] + ":" + arrStr[i + 1]
            arrStr1.append(strTemap)
        }
        let strings = arrStr1.joined(separator: ",")
        let finalString = "{" + strings + "}"
        
        if let dataS =  finalString.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: dataS, options: .mutableContainers) as! NSDictionary
                
                obj = obj.initiateCustomLocationData(responseDict: json)
                
                
            } catch {
                print("Something went wrong")
            }
        }
    }
    return obj
}



