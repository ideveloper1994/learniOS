//
//  AboutTitleModel.swift
//  Arheb
//
//  Created on 08/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation
import UIKit

class AboutTitleModel : NSObject {
    
    var space_msg : String = ""
    var guest_access_msg : String = ""
    var interaction_with_guest_msg : String = ""
    var overview_msg : String = ""
    var getting_arround_msg : String = ""
    var other_things_to_note_msg : String = ""
    var house_rules_msg : String = ""
    
    // MARK: Inits
    func initiateTitleData(responseDict: NSDictionary) -> AboutTitleModel {
        bindData(dic: responseDict, str: "space_msg", type: &self.space_msg)
        bindData(dic: responseDict, str: "guest_access_msg", type: &self.guest_access_msg)
        bindData(dic: responseDict, str: "interaction_with_guest_msg", type: &self.interaction_with_guest_msg)
        bindData(dic: responseDict, str: "overview_msg", type: &self.overview_msg)
        bindData(dic: responseDict, str: "getting_arround_msg", type: &self.getting_arround_msg)
        bindData(dic: responseDict, str: "other_things_to_note_msg", type: &self.other_things_to_note_msg)
        bindData(dic: responseDict, str: "house_rules_msg", type: &self.house_rules_msg)
        return self
    }
}
