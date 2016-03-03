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
    var desc: NSString
    var image: UIImage?
    
    init(location: CLLocationCoordinate2D, desc: NSString, image: UIImage) {
        self.location = location
        self.desc = desc
        self.image = image
    }
    
    init(location: CLLocationCoordinate2D, desc: NSString) {
        self.location = location
        self.desc = desc
    }
    
    func upload() {
        let bikeRacksRef = Firebase(url: "https://rackscout.firebaseio.com/bikeRacks/")
        let geoFire = GeoFire(firebaseRef: Firebase(url: "https://rackscout.firebaseio.com/geoFire"))
        
        var bikeRackDetails: [NSString: NSString]!
        
        if let imageSave = image {
            
            let imageData = UIImageJPEGRepresentation(imageSave, 0.7)
            let base64String: NSString! = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))
            
            bikeRackDetails = [
                "desc": desc,
                "image": base64String
            ]
        } else {
            bikeRackDetails = [
                "desc": desc
            ]
        }
        
        let idRef = bikeRacksRef.childByAutoId()
        idRef.updateChildValues(bikeRackDetails)
        
        geoFire.setLocation(CLLocation(latitude: 37.7853889, longitude: -122.4056973), forKey: idRef.key)
    }
    
}