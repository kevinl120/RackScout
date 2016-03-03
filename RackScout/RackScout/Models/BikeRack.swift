//
//  BikeRack.swift
//  RackScout
//
//  Created by Kevin Li on 2/28/16.
//  Copyright © 2016 Kevin Li. All rights reserved.
//

import UIKit

import Firebase
import GeoFire

class BikeRack: NSObject {
    
    var location: CLLocationCoordinate2D
    var title: NSString
    
    init(location: CLLocationCoordinate2D, title: NSString) {
        self.location = location
        self.title = title
    }
    
    func upload() {
        let bikeRacksRef = Firebase(url: "https://rackscout.firebaseio.com/bikeRacks/")
        let geoFire = GeoFire(firebaseRef: Firebase(url: "https://rackscout.firebaseio.com/geoFire"))
        
        let bikeRackDetails = [
            "title": title
        ]
        
        let idRef = bikeRacksRef.childByAutoId()
        idRef.updateChildValues(bikeRackDetails)
        
        geoFire.setLocation(CLLocation(latitude: 37.7853889, longitude: -122.4056973), forKey: idRef.key)
    }
    
}