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
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var numberInPartyField: UITextField!
    @IBOutlet weak var amountEachLabel: UITextField!

    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var clearBtn: UIButton!
    
    // MARK: VC methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitialUIState()
        
        // set the currency placeholder in the bill field
        // current workaround is to just use 0
        billField.placeholder = formatValue(0)
        
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
    
    @IBAction func clearBillField(_ sender: AnyObject) {
        self.setInitialUIState()
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        // take the billField text, change it into a number
        // otherwise, if it's a nil value, let it be 0
        let bill = Double(billField.text!) ?? 0
        let numberInParty = Double(numberInPartyField.text!) ?? 0
        
        // if bill or numberInParty isn't valid,
        // then we don't display the calculations view
        if (bill == 0) {
            self.setInitialUIState()
        } else if (numberInParty == 0) {
            self.setHiddenBottomUIState()
        }
        else {
            let tip = bill * Tips.PERCENTAGES_ARR[tipControl.selectedSegmentIndex]
            let total = bill + tip
            let amountEach = total / numberInParty
            
            tipLabel.text = formatValue(tip)
            totalLabel.text = formatValue(total)
            amountEachLabel.text = formatValue(amountEach)
            
            self.setExpandedUIState()
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
            self.view.backgroundColor = Colors.LIGHT_BLUE
            topView.backgroundColor = Colors.LIGHT_BLUE
            controlsView.backgroundColor = Colors.LIGHT_BLUE
            bottomView.backgroundColor = Colors.NAVY
            tipControl.tintColor = Colors.NAVY
        }
        // light theme selected
        else {
            self.view.backgroundColor = UIColor.white
            topView.backgroundColor = UIColor.white
            controlsView.backgroundColor = UIColor.white
            bottomView.backgroundColor = Colors.GREEN
            tipControl.tintColor = Colors.GREEN
        }
    }
    
    func setInitialUIState() {
        // reset to initial state
        billField.text = ""
        tipLabel.text = ""
        totalLabel.text = ""
        amountEachLabel.text = ""
        
        UIView.animate(withDuration: 0.4, animations: {
            // set billField to be more centered
            self.billField.transform = CGAffineTransform( translationX: 0.0, y: 100.0 )
            
            // set UI elements to invis
            self.controlsView.alpha = 0
            self.bottomView.alpha = 0
            self.clearBtn.alpha = 0
        })
    }
    
    func setHiddenBottomUIState() {
        UIView.animate(withDuration: 0.4, animations: {
            // set UI elements to invis
            self.bottomView.alpha = 0
        })
    }
    
    func setExpandedUIState() {
        // show the bottom portion
        UIView.animate(withDuration: 0.4, animations: {
            self.billField.transform = CGAffineTransform( translationX: 0.0, y: 0.0 )
            self.controlsView.alpha = 1
            self.bottomView.alpha = 1
            
            // show the clear button with 2 or more digits
            if (self.billField.text!.characters.count >= Constants.CLEAR_BTN_DIGITS) {
                self.clearBtn.alpha = 1
            }
        })
    }
    
    func formatValue(_ value: Double) -> String {
        // formats currency type, thousands-separator, and decimal separator
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        // format the value to string -- e.g., 1234.56 -> "$1,234.56" (en_US)
        let formattedString = formatter.string(for: value)!
        
        if (value == 0) {
            // return only the currency symbol -- e.g., "$0.00" -> "$"
            let index = formattedString.index(formattedString.startIndex, offsetBy: 1)
            return formattedString.substring(to: index)
        } else {
            return formattedString
        }
    }
    
}

