//
//  MapViewController.swift
//  RackScout
//
//  Created by Kevin Li on 2/28/16.
//  Copyright © 2016 Kevin Li. All rights reserved.
//

import UIKit

import Firebase

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        test();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test() {
        
//        let camera = GMSCameraPosition.cameraWithLatitude(-33.86,
//            longitude: 151.20, zoom: 6)
//        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
//        mapView.myLocationEnabled = true
//        self.view = mapView
//        
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
        
//        let ref = Firebase(url: "https://rackscout.firebaseio.com/")
//        
//        let bikeRacksRef = ref.childByAppendingPath("bikeRacks")
//        
//        var testBikeRack = [
//            "id": "0",
//            "testProperty": "Blarg"
//        ]
//        
//        var bikeRacks = ["0": testBikeRack]
//        
//        bikeRacksRef.setValue(bikeRacks)
    }
    
    
}