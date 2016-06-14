//
//  EdgeRuleDetailViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/13/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

    var edgeRuleTypes = ["$ Edge", "Gamma Edge"]
    var buyCallEdgeRule = ["$ Edge", "0.03", "1500", "1.5", "45"]


class EdgeRuleDetailViewController: UIViewController, UIPickerViewDelegate {

    @IBOutlet var edgeRulePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return edgeRuleTypes.count
        case 1:
            return 101
        case 2:
            return 1001
        case 3:
            return 101
        case 4:
            return 101
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rowDbl:Double = Double(row)
        switch component {
        case 0:
            return edgeRuleTypes[row]
        case 1:
            return appendZerosToString(numberToString: String(rowDbl*0.01), MinCharLength: 4)
        case 2:
            return String(row*10)
        case 3:
            return String(row)
        case 4:
            return String(row)
        default:
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}