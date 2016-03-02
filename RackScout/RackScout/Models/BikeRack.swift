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

    @NSManaged var id: NSNumber
    @NSManaged var location: CLLocation
    
    func upload() {
        let ref = Firebase(url: "https://rackscout.firebaseio.com/")
        let bikeRacksRef = ref.childByAppendingPath("bikeRacks")
    
        let bikeRackDetails = [
            "latitude": location.coordinate.latitude.description,
            "longitude": location.coordinate.longitude.description
        ]
        
        let bikeRack = [id.stringValue: bikeRackDetails]
        
        bikeRacksRef.setValue(bikeRack)
        
    }
    
}