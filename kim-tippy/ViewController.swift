//
//  ViewController.swift
//  kim-tippy
//
//  Created by Nguyen, Kim on 8/2/17.
//  Copyright © 2017 knguyen1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var numberInPartyField: UITextField!
    @IBOutlet weak var amountEachLabel: UITextField!

    @IBOutlet weak var tipControl: UISegmentedControl!
    
    let tipPercentages = [0.15, 0.2, 0.22]
    let lighterBlueColor = UIColor(red: 194/255, green: 230/255, blue: 249/255, alpha: 0.9)
    let navyColor = UIColor(red: 15/255, green: 108/255, blue: 157/255, alpha: 1)
    let greenColor = UIColor(red: 79/255, green: 200/255, blue: 38/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // calculates tip
    @IBAction func calculateTip(_ sender: AnyObject) {
        // take the billField text, change it into a number
        // otherwise, if it's a nil value, let it be 0
        let bill = Double(billField.text!) ?? 0
        let numberInParty = Double(numberInPartyField.text!) ?? 0
        
        if (bill == 0 || numberInParty == 0) {
            tipLabel.text = "$"
            totalLabel.text = "$"
            amountEachLabel.text = "$"
        }
        else {
            // segmentIndex = 0, 1, 2
            // tipPercentages[0] ...
            let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
            let total = bill + tip
            let amountEach = total / numberInParty
            
            // $%.2f allows 2 decimal places
            tipLabel.text = String(format: "$%.2f", tip)
            totalLabel.text = String(format: "$%.2f", total)
            amountEachLabel.text = String(format: "$%.2f each", amountEach)
        }
    }
    
    // MARK: Functions
    func loadSettings() {
        let defaults = UserDefaults.standard
        // load the configured default tip value
        let defaultSelectedIndex = defaults.integer(forKey: "defaultSelectedIndex")
        let isDarkThemeOn = defaults.bool(forKey: "isDarkThemeOn")
        tipControl.selectedSegmentIndex = defaultSelectedIndex
        
        if (isDarkThemeOn) {
            topView.backgroundColor = lighterBlueColor
            bottomView.backgroundColor = navyColor
            tipControl.tintColor = navyColor
            // set text color to a lighter one
            
            
        } else {
            topView.backgroundColor = UIColor.white
            bottomView.backgroundColor = greenColor
            tipControl.tintColor = greenColor
        }
    }
    
}

