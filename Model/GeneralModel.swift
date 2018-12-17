//
//  GeneralModel.swift
//  Arheb
//
//  Created on 5/31/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation
import UIKit

class GeneralModel : NSObject {
    
    var success_message : String = ""
    var status_code : String = ""

    func addResponseToModel(res: NSDictionary) -> GeneralModel{
        bindData(dic: res, str: "success_message", type: &self.success_message)
        bindData(dic: res, str: "status_code", type: &self.status_code)
        return self
    }
}
