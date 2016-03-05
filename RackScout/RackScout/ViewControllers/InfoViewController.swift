//
//  InfoViewController.swift
//  RackScout
//
//  Created by Kevin Li on 3/2/16.
//  Copyright © 2016 Kevin Li. All rights reserved.
//

import UIKit

import Firebase
import GoogleMaps

class InfoViewController: UIViewController {
    
    var id: String!
    var locationDataLoaded = false
    var imageLoading = false
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var location: CLLocationCoordinate2D!
    
    @IBOutlet weak var locationsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var postalLabel: UILabel!
    
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLabels()
        
        var refString = "https://rackscout.firebaseio.com/bikeRacks/"
        refString += id
        
        let ref = Firebase(url: refString)
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func directionsButtonPressed(sender: AnyObject) {
        if locationDataLoaded {
            if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                
                let alertController = UIAlertController(title: "Directions", message: "Which app do you want to use?", preferredStyle: .Alert)
                
                // Adds cancel button
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                // Adds google maps option
                let googleMapsAction = UIAlertAction(title: "Google Maps", style: .Default) { (action) in
                    UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?daddr=\(self.location.latitude),\(self.location.longitude)&directionsmode=bicycling")!)
                }
                alertController.addAction(googleMapsAction)
                
                // Adds apple maps option
                let appleMapsAction = UIAlertAction(title: "Apple Maps", style: .Default) { (action) in
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/maps?saddr=Current%20Location&daddr=\(self.location.latitude),\(self.location.longitude)")!)
                }
                alertController.addAction(appleMapsAction)
                
                // Show the alert controller
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/maps?saddr=Current%20Location&daddr=\(self.location.latitude),\(self.location.longitude)")!)
            }
        }
    }
    
    @IBAction func imageButtonPressed(sender: AnyObject) {
        
        if !imageLoading {
            
            imageLoading = true
            
            self.imageButton.setTitle("Loading...", forState: UIControlState.Normal)
            
            let detailsRefString = "https://rackscout.firebaseio.com/bikeRacks/" + id
            let detailsRef = Firebase(url: detailsRefString)
            
            detailsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                let imageString = snapshot.value["image"] as? String
                
                if let imgstr = imageString {
                    let imageView = UIImageView.init(image: UIImage(data: NSData(base64EncodedString: imgstr, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!))
                    imageView.contentMode = UIViewContentMode.ScaleAspectFit
                    imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height)
                    self.view.addSubview(imageView)
                    
                    let closeButton = UIButton(frame: UIScreen.mainScreen().bounds)
                    closeButton.addTarget(self, action: "removeImage", forControlEvents: .TouchUpInside)
                    self.view.addSubview(closeButton)
                    
                    self.imageLoading = false
                    self.imageButton.setTitle("Image", forState: UIControlState.Normal)
                } else {
                    self.imageButton.setTitle("Image Unavailable", forState: UIControlState.Normal)
                    self.imageButton.enabled = false
                }
            })
        }
    }
    
    func removeImage() {
        for subview in self.view.subviews {
            if subview.isKindOfClass(UIImageView) {
                subview.removeFromSuperview()
            }
        }
        
        self.view.subviews.last!.removeFromSuperview()
    }
    
    func loadLabels() {
        
        let detailsRefString = "https://rackscout.firebaseio.com/bikeRacks/" + id + "/desc"
        let detailsRef = Firebase(url: detailsRefString)
        
        detailsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.titleLabel.text = snapshot.value as? String
        })
        
        let locationRefString = "https://rackscout.firebaseio.com/geoFire/" + id + "/l"
        let locationRef = Firebase(url: locationRefString)
        
        locationRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.location = CLLocationCoordinate2D(latitude: snapshot.value[0] as! Double, longitude: snapshot.value[1] as! Double)
            
            self.mapView.camera = GMSCameraPosition.cameraWithTarget(self.location, zoom: 17)
            
            let marker = GMSMarker()
            marker.position = self.location
            marker.map = self.mapView
            
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(self.location, completionHandler: { (gmsReverseGeocodeResponse: GMSReverseGeocodeResponse?, let error: NSError?) -> Void in
                if let gmsAddress = gmsReverseGeocodeResponse!.firstResult() {
                    
                    self.streetLabel.text = "\(gmsAddress.lines![0])"
                    self.postalLabel.text = "\(gmsAddress.lines![1])"
                }
            
            })
            self.locationDataLoaded = true
        })
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }

}
