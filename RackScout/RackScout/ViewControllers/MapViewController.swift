//
//  MapViewController.swift
//  RackScout
//
//  Created by Kevin Li on 2/28/16.
//  Copyright © 2016 Kevin Li. All rights reserved.
//

import UIKit

import Firebase
import GeoFire
import GoogleMaps

import SMCalloutView

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
    var calloutView = SMCalloutView()
    var emptyCalloutView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let CalloutYOffset: CGFloat = 40.0
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var addBikeRackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpLocationManager()
        setUpCalloutView()
        setUpMap()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Mechanics
    
    func findBikeRacks() {
        let ref = Firebase(url: "https://rackscout.firebaseio.com/geoFire")
        let geoFire = GeoFire(firebaseRef: ref)
        
        if let location = locationManager.location {
            
            let geoQuery = geoFire.queryAtLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), withRadius: 1609) // kilometers
            
            geoQuery.observeEventType(GFEventTypeKeyEntered, withBlock: { result in
                let marker = GMSMarker(position: result.1.coordinate)
                
                
                // Change marker title text
                var refString = "https://rackscout.firebaseio.com/bikeRacks/"
                if let id = result.0 {
                    marker.snippet = id
                    refString += id
                    refString += "/desc"
                }
                
                let ref = Firebase(url: refString)
                
                ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    marker.title = snapshot.value as? String
                })
                
                marker.map = self.mapView
            })
        }

    }
    
    // MARK: Location
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Change camera view only once
        if let location = locationManager.location {
            mapView.camera = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16)
        }
        
        locationManager.stopUpdatingLocation()
        
        findBikeRacks()
    }
    
    // MARK: Map Setup
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        // Callout View Setup

        let anchor = marker.position
        
        let point = mapView.projection.pointForCoordinate(anchor)
        
        calloutView.title = marker.title
        calloutView.calloutOffset = CGPoint(x: 0, y: -CalloutYOffset)
        calloutView.hidden = false
        
        var calloutRect = CGRectZero
        calloutRect.origin = point
        calloutRect.size = CGSizeZero
        
        calloutView.presentCalloutFromRect(calloutRect, inView: mapView, constrainedToView: mapView, animated: true)
        
        return self.emptyCalloutView
    }
    
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        
        // Callout View Setup
        
        if mapView.selectedMarker != nil && !calloutView.hidden {
            let anchor = mapView.selectedMarker!.position
            let arrowPt = calloutView.backgroundView.arrowPoint
            var pt = mapView.projection.pointForCoordinate(anchor)
            
            pt.x -= arrowPt.x
            pt.y -= arrowPt.y + CalloutYOffset
            
            calloutView.frame = CGRect(origin: pt, size: calloutView.frame.size)
        } else {
            calloutView.hidden = true
        }
    }
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        // Callout View Setup
        calloutView.hidden = true
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        // Callout View Setup
        mapView.selectedMarker = marker
        
        return true
    }
    
    // MARK: Setup
    
    func setUpLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }

    func setUpMap() {
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 64.0, left: 0.0, bottom: 60.0, right: 0.0)
    }
    
    func setUpCalloutView() {
        let button = UIButton(type: UIButtonType.DetailDisclosure)
        button.addTarget(self, action: Selector("calloutButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        
        calloutView.rightAccessoryView = button as UIView
    }
    
    // MARK: Navigation
    func calloutButtonTapped() {
        self.performSegueWithIdentifier("showBikeRackInfo", sender: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addBikeRack" {
            let vc = segue.destinationViewController as! AddViewController
            if let location = locationManager.location {
                vc.latitude = location.coordinate.latitude
                vc.longitude = location.coordinate.longitude
            }
        }
    }
}