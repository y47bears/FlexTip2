//
//  SettingsViewController.swift
//  FlexTip2
//
//  Created by Daniel Seuk Lee on 2/19/17.
//  Copyright © 2017 Daniel Seuk Lee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let defaults = UserDefaults.standard
    let locale = Locale.current
    
    @IBOutlet weak var tipDefaultSelector: UISegmentedControl!
    @IBOutlet weak var localePicker: UIPickerView!

    @IBAction func tipSelected(_ sender: Any) {
        
        let chooseTipPercentages = [0.18, 0.2, 0.25]
        let myTipPercent = chooseTipPercentages[tipDefaultSelector.selectedSegmentIndex]
        let myTipPercentSelection = [tipDefaultSelector.selectedSegmentIndex]
        
        defaults.set(myTipPercent, forKey: "keyDefaultTip")
        defaults.set(myTipPercentSelection, forKey: "keyDefaultTipIndex")
        
    }
    
/*
    // for UIPicker: returns country names, but not locale
    let countries = NSLocale.isoCountryCodes.map { (code:String) -> String in
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
    }
*/


/*    // latest attempt
    func countryInfo() -> NSArray {
        
        var countryCodes = NSLocale.isoCountryCodes
        var countries: NSMutableArray
        
        for countryCode in countryCodes {
            let dictionary: NSDictionary = NSDictionary(object:countryCode, forKey:NSLocale.Key.countryCode as NSCopying)
            var identifier: NSString? = NSLocale.localeIdentifier(fromComponents: dictionary as! [String : String]) as NSString?
            let country = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
            
            if country != nil {
                countries.add(country!)
            }
        }
        NSLog("\(countries)")
        return countries
    }
*/

    // for UIPicker: temporary partial solution saving locale, but not displaying Country
    let countries = ["en_US", "ace_AG", "es_AR", "pt_BR", "de_CH", "zh_CN", "de_DE", "ar_EG", "fr_FR", "en_GB", "en_IN", "ko_KR", "es_MX", "ru_RU"]

    //MARK: - Locale pickerView Data Source and Delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let valueSelected = countries[row] as String
        defaults.set(valueSelected, forKey: "keyCountry") // temporary - should be Locale or currency symbol
        print(valueSelected) // To troubleshoot
        let countryRow = row as Int
        defaults.set(countryRow, forKey: "keyCountryRow")
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = countries[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 25.0)!,NSForegroundColorAttributeName:UIColor(displayP3Red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)])
        return myTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let myTipPercentSelection = defaults.value(forKey: "keyDefaultTipIndex") as? Array<Int> {
            tipDefaultSelector.selectedSegmentIndex = myTipPercentSelection[0]
        }
        
        localePicker.delegate = self
        localePicker.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
