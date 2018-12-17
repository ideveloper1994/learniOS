//
//  LocationModel.swift
//  Arheb
//
//  Created on 05/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation
import MapKit

class LocationModel: NSObject {
    var searchedAddress = ""
    var longitude = ""
    var latitude = ""
    var currentLocation: CLLocation!
}
