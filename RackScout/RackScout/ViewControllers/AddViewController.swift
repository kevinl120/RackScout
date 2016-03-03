//
//  AddViewController.swift
//  RackScout
//
//  Created by Kevin Li on 2/29/16.
//  Copyright © 2016 Kevin Li. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class AddViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var streetAddressTextField: JVFloatLabeledTextField!
    @IBOutlet weak var cityStateZipTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var descriptionTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addedImage: UIImageView!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up navigation bar
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelButtonPressed")), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveButtonPressed")), animated: true)
        
        setUpTextFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextFields() {
        let bottomBorder1 = CALayer()
        bottomBorder1.frame = CGRectMake(0.0, streetAddressTextField.frame.size.height - 1, streetAddressTextField.frame.size.width, 1.0);
        bottomBorder1.backgroundColor = UIColor.lightGrayColor().CGColor
        streetAddressTextField.layer.addSublayer(bottomBorder1)
        
        let bottomBorder2 = CALayer()
        bottomBorder2.frame = CGRectMake(0.0, cityStateZipTextField.frame.size.height - 1, cityStateZipTextField.frame.size.width, 1.0);
        bottomBorder2.backgroundColor = UIColor.lightGrayColor().CGColor
        cityStateZipTextField.layer.addSublayer(bottomBorder2)
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
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }

}