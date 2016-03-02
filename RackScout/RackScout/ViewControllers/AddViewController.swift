//
//  AddViewController.swift
//  RackScout
//
//  Created by Kevin Li on 2/29/16.
//  Copyright © 2016 Kevin Li. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up navigation bar
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelButtonPressed")), animated: true)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveButtonPressed")), animated: true)
        
//        var bikeRack = BikeRack()
//        bikeRack.id = 0
//        bikeRack.location = CLLocation(latitude: 10, longitude: 100)
//        bikeRack.upload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelButtonPressed() {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
    func saveButtonPressed() {
        let bikeRack = BikeRack(id: "0", location: CLLocationCoordinate2DMake(10.0, 100.0))
        bikeRack.upload()
        
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }

}