//
//  ViewController.swift
//  FlexTip2
//
//  Created by Daniel Seuk Lee on 2/19/17.
//  Copyright © 2017 Daniel Seuk Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
//    let locale = Locale.current // previously used
//    let currencySymbol = Locale.current.currencySymbol // previously used

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var partyField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if defaults.value(forKey: "keyBillAmount") == nil || defaults.value(forKey: "keyBillAmount")! as! String == "" {
            billField.becomeFirstResponder()
        } else {
            billField.text = defaults.value(forKey: "keyBillAmount") as! String?
            billField.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, animations: {
            self.tipBackground.alpha = 0
        })
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
//        currencyFormatter.locale = Locale(identifier: "fr_FR") // testing with another locale

        // temporary, this works for now
        if let valueSelected = defaults.value(forKey: "keyCountry") as? String {
            currencyFormatter.locale = Locale(identifier: valueSelected) // testing with another locale
        }

        let tipPercentages = [0.18, 0.2, 0.25]        
        
        let bill = Double(billField.text!) ?? 0
        let party = Double(partyField.text!) ?? 1
        
        let tipTotal = bill * tipPercentages[tipControl.selectedSegmentIndex]
        
        
        let tip = NSNumber(value: tipTotal / party)
        let total = NSNumber(value: bill + tipTotal)

        UIView.animate(withDuration: 1.0, animations: {
            self.tipBackground.alpha = 1.0
        })
        UIView.animate(withDuration: 1.5, animations: {
            self.tipBackground.alpha = 0.3
        })

        tipLabel.text = currencyFormatter.string(from: tip)!
        totalLabel.text = currencyFormatter.string(from: total)!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        
        if let myTipPercentSelection = defaults.value(forKey: "keyDefaultTipIndex") as? Array<Int> {
            tipControl.selectedSegmentIndex = myTipPercentSelection[0] // sets to User selected default
            calculateTip(_: Any.self) // calculate after default value changes
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")

        if defaults.value(forKey: "keyBillAmount") == nil || defaults.value(forKey: "keyBillAmount")! as! String == "" {
        } else {
            billField.text = defaults.value(forKey: "keyBillAmount") as! String?
        }

        if defaults.value(forKey: "keyParty") == nil || defaults.value(forKey: "keyParty")! as! String == "" {
            partyField.text = "1"
        } else {
            partyField.text = defaults.value(forKey: "keyParty") as? String
        }

        if let myTipPercentSelection = defaults.value(forKey: "keyDefaultTipIndex") as? Array<Int> {
            tipControl.selectedSegmentIndex = myTipPercentSelection[0]
        }
}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
        
        // Store Bill Amount, Party Size, Current Tip selection
        defaults.set(billField.text, forKey: "keyBillAmount")
        defaults.set(partyField.text, forKey: "keyParty")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")

        // Remove saved Bill Amount and Party Size after 1 minute
        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) {
            self.defaults.removeObject(forKey: "keyBillAmount")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) {
            self.defaults.removeObject(forKey: "keyParty")
        }
    }
    
}

