//
//  AddViewController.swift
//  RackScout
//
//  Created by Kevin Li on 2/29/16.
//  Copyright © 2016 Kevin Li. All rights reserved.
//

import UIKit

import GoogleMaps

import JVFloatLabeledTextField

class AddViewController: UIViewController, UITextFieldDelegate {
    
    var latitude: Double?
    var longitude: Double?
    
    var photoTakingHelper: PhotoTakingHelper?
    
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var streetAddressTextField: JVFloatLabeledTextField!
    @IBOutlet weak var cityStateZipTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var descriptionTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up navigation bar
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelButtonPressed")), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveButtonPressed")), animated: true)
        
        setUpTextFields()
        setUpMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextFields() {
        
        descriptionTextField.delegate = self
        
        // Draw the line underneath the text
        let bottomBorder1 = CALayer()
        bottomBorder1.frame = CGRectMake(0.0, streetAddressTextField.frame.size.height - 1, streetAddressTextField.frame.size.width, 1.0);
        bottomBorder1.backgroundColor = UIColor.lightGrayColor().CGColor
        streetAddressTextField.layer.addSublayer(bottomBorder1)
        
        let bottomBorder2 = CALayer()
        bottomBorder2.frame = CGRectMake(0.0, cityStateZipTextField.frame.size.height - 1, cityStateZipTextField.frame.size.width, 1.0);
        bottomBorder2.backgroundColor = UIColor.lightGrayColor().CGColor
        cityStateZipTextField.layer.addSublayer(bottomBorder2)
        
        streetAddressTextField.allowsEditingTextAttributes = false
        cityStateZipTextField.allowsEditingTextAttributes = false
    }
    
    func setUpMap() {
        if let latitude = latitude, longitude = longitude {
            mapView.camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 17)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(latitude, longitude)
            marker.map = mapView
            
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(latitude, longitude)) { (gmsReverseGeocodeResponse: GMSReverseGeocodeResponse?, let error: NSError?) -> Void in
                
                if let gmsAddress = gmsReverseGeocodeResponse!.firstResult() {
                    if let streetAddress = gmsAddress.thoroughfare {
                        self.streetAddressTextField.text = "\(streetAddress)"
                    } else {
                        self.streetAddressTextField.text = "Unavailable"
                        self.streetAddressTextField.enabled = false
                    }
                    
                    if let city = gmsAddress.locality {
                        self.cityStateZipTextField.text = "\(city)"
                    } else if let zip = gmsAddress.postalCode {
                        self.cityStateZipTextField.text = "\(zip)"
                    } else {
                        self.cityStateZipTextField.text = "Unavailable"
                        self.streetAddressTextField.enabled = false
                        
                    }
                
                } else {
                    self.streetAddressTextField.text = "Unavailable"
                    self.cityStateZipTextField.text = "Unavailable"
                    self.streetAddressTextField.enabled = false
                    self.cityStateZipTextField.enabled = false
                }
            }
        } else {
            streetAddressTextField.text = "Unavailable"
            cityStateZipTextField.text = "Unavailable"
            streetAddressTextField.enabled = false
            cityStateZipTextField.enabled = false
            
            if let saveButton = self.navigationItem.rightBarButtonItem {
                saveButton.enabled = false
            }
        }
    }
    
    @IBAction func addImageButtonPressed(sender: AnyObject) {
        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
            self.addedImage.image = image
            self.addImageButton.hidden = true
        })
    }
    
    func cancelButtonPressed() {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    func saveButtonPressed() {
        
        var bikeRack: BikeRack!
        var description: NSString!
        
        if descriptionTextField.text == "" {
            description = "Bike Rack"
        } else {
            description = descriptionTextField.text
        }
        
        print(latitude!)
        
        if let image = addedImage.image {
            bikeRack = BikeRack(location: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), desc: description, image: image)
        } else {
            bikeRack = BikeRack(location: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), desc: description)
        }
        
        bikeRack.upload()
        
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }

    
    // MARK: Text Field Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up keyboard to not block text fields
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unregister keyboard notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow() {
        if self.view.frame.origin.y >= 0 {
            setViewMovedUp(true)
        } else if (self.view.frame.origin.y < 0) {
            setViewMovedUp(false)
        }
    }
    
    func keyboardWillHide() {
        if self.view.frame.origin.y >= 0 {
            setViewMovedUp(true)
        } else if (self.view.frame.origin.y < 0) {
            setViewMovedUp(false)
        }
    }
    
    func setViewMovedUp(movedUp: Bool) {
        
        let keyboardOffset: CGFloat = 240.0
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var rect = self.view.frame
        
        if movedUp {
            rect.origin.y -= keyboardOffset
            rect.size.height += keyboardOffset
        } else {
            rect.origin.y += keyboardOffset
            rect.size.height -= keyboardOffset
        }
        self.view.frame = rect
        
        UIView.commitAnimations()
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }

}