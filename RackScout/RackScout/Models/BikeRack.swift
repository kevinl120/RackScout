//
//  BikeRack.swift
//  RackScout
//
//  Created by Kevin Li on 2/28/16.
//  Copyright © 2016 Kevin Li. All rights reserved.
//

import UIKit

import Firebase

class BikeRack: NSObject {

    var id: NSString
    var location: CLLocationCoordinate2D
    
    init(id: NSString, location: CLLocationCoordinate2D) {
        self.id = id
        self.location = location
    }
    
    func upload() {
        let ref = Firebase(url: "https://rackscout.firebaseio.com/")
        let bikeRacksRef = ref.childByAppendingPath("bikeRacks")
    
        let bikeRackDetails = [
            "latitude": location.latitude.description,
            "longitude": location.longitude.description
        ]
        
        let bikeRack = [id: bikeRackDetails]
        
        bikeRacksRef.updateChildValues(bikeRack)
        
    }
    
}