//
//  ViewController.swift
//  kim-tippy
//
//  Created by Nguyen, Kim on 8/2/17.
//  Copyright © 2017 knguyen1. All rights reserved.
//

import UIKit

class TipCalcViewController: UIViewController {

    @IBOutlet var tipPageView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var numberInPartyField: UITextField!
    @IBOutlet weak var amountEachLabel: UITextField!

    @IBOutlet weak var tipControl: UISegmentedControl!
    
    // MARK: VC methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the bottom to invisible
        self.bottomView.alpha = 0
        
        // autofocus to bill field
        billField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: IBActions
    @IBAction func onTap(_ sender: Any) {
        // closes up the decimal pad keyboard
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        // take the billField text, change it into a number
        // otherwise, if it's a nil value, let it be 0
        let bill = Double(billField.text!) ?? 0
        let numberInParty = Double(numberInPartyField.text!) ?? 0
        
        // if bill or numberInParty isn't valid,
        // then we don't display the calculations view
        if (bill == 0 || numberInParty == 0) {
            tipLabel.text = "$"
            totalLabel.text = "$"
            amountEachLabel.text = "$"
            
            // hide the bottom portion
            UIView.animate(withDuration: 0.4, animations: {
                self.bottomView.alpha = 0
            })
        }
        else {
            let tip = bill * Tips.PERCENTAGES_ARR[tipControl.selectedSegmentIndex]
            let total = bill + tip
            let amountEach = total / numberInParty
            
            // $%.2f allows 2 decimal places
            tipLabel.text = String(format: "$%.2f", tip)
            totalLabel.text = String(format: "$%.2f", total)
            amountEachLabel.text = String(format: "$%.2f each", amountEach)
            
            // show the bottom portion
            UIView.animate(withDuration: 0.4, animations: {
                self.bottomView.alpha = 1
            })
        }
    }
    
    // MARK: Functions
    func loadSettings() {
        let defaults = UserDefaults.standard
        
        // load the configured defaults
        let defaultSelectedIndex = defaults.integer(forKey: "defaultSelectedIndex")
        let isDarkThemeOn = defaults.bool(forKey: "isDarkThemeOn")
        
        // set the default tip percentage
        tipControl.selectedSegmentIndex = defaultSelectedIndex
        
        // dark theme selected
        if (isDarkThemeOn) {
            topView.backgroundColor = Colors.LIGHT_BLUE
            bottomView.backgroundColor = Colors.NAVY
            tipControl.tintColor = Colors.NAVY
        }
        // light theme selected
        else {
            topView.backgroundColor = UIColor.white
            bottomView.backgroundColor = Colors.GREEN
            tipControl.tintColor = Colors.GREEN
        }
    }
    
}

