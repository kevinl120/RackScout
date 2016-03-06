//
//  SettingsTableViewController.swift
//  RackScout
//
//  Created by Kevin Li on 3/5/16.
//  Copyright © 2016 Kevin Li. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var autoRefreshSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey("autoRefresh") {
            autoRefreshSwitch.setOn(false, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func autoRefreshChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if autoRefreshSwitch.on {
            defaults.setBool(true, forKey: "autoRefresh")
        } else {
            defaults.setBool(false, forKey: "autoRefresh")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
