//
//  SettingsViewController.swift
//  kim-tippy
//
//  Created by Nguyen, Kim on 8/2/17.
//  Copyright © 2017 knguyen1. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    
    @IBOutlet var settingsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the configured default tip value - only need to do this once
        let defaults = UserDefaults.standard
        let defaultSelectedIndex = defaults.integer(forKey: "defaultSelectedIndex")
        let isDarkThemeOn = defaults.bool(forKey: "isDarkThemeOn")
        
        // init the controls
        defaultTipControl.selectedSegmentIndex = defaultSelectedIndex
        darkThemeSwitch.isOn = isDarkThemeOn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    @IBAction func defaultTipChanged(_ sender: Any) {
        self.saveToSettings()
    }
    @IBAction func darkThemeChanged(_ sender: Any) {
        self.saveToSettings()
    }
    
    // MARK: functions
    func saveToSettings() {
        let defaults = UserDefaults.standard
        defaults.set(defaultTipControl.selectedSegmentIndex, forKey: "defaultSelectedIndex")
        defaults.set(darkThemeSwitch.isOn, forKey: "isDarkThemeOn")
        defaults.synchronize()
    }
    
}
