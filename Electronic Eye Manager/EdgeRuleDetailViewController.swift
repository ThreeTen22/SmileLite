//
//  EdgeRuleDetailViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/13/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EdgeRuleDetailViewController: UIViewController, UIPickerViewDelegate {
    
    var edgeRuleTypes = ["$ Edge", "Gamma Edge"]
    var edgeRuleArray = [["    "],["   "]]
    var isBCSP:Bool = false
    var str:String = ""
    var tempInt:Int = 0
    @IBOutlet var edgeRulePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...3 {
            str = String(edgeRuleArray[1][i])
            tempInt = Int(str)!
            print(edgeRuleArray[1][i])
            print(edgeRuleArray[0][i])
            edgeRulePicker.selectRow(tempInt, inComponent: i-1, animated: true)
            edgeRulePicker.selectRow(tempInt, inComponent: i-1, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return edgeRuleTypes.count
        case 1:
            return 101
        case 2:
            return 101
        case 3:
            return 101
        case 4:
            return 101
        default:
            return 0
        }
    }
    //var bcspEdgeRule:NSArray = [["Buy Call | Sell Put","$ Edge", 0.0, 0, 0.0, 0.0],[0,0,0,0,0,0]]
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rowDbl:Double = Double(row)
        var returnStr = ""
        switch component {
        case 0:
            returnStr = edgeRuleTypes[row]
        case 1:
            returnStr = appendZerosToString(numberToString: String(rowDbl*0.01), MinCharLength: 4)
        case 2:
            if row < 21 {
                returnStr = String(100*row)
            }
            else {
                returnStr = String(2000+(500*(row-20)))
            }
        case 3:
            returnStr = String(row)
        case 4:
            returnStr = String(row)
        default:
            return ""
        }
        return returnStr
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isBCSP {
            //get information and put it into the array
            bcspEdgeRule[0][component+1] = self.pickerView(pickerView, titleForRow: row, forComponent: component)!
            print(self.pickerView(pickerView, titleForRow: row, forComponent: component))
            
            //add Index
            bcspEdgeRule[1][component+1] = String(row)
        }
        else {
            //get information and put it into the array
            scbpEdgeRule[0][component+1] = self.pickerView(pickerView, titleForRow: row, forComponent: component)!
            print(self.pickerView(pickerView, titleForRow: row, forComponent: component))
            
            //add Index
            scbpEdgeRule[1][component+1] = String(row)
        }
    }
    
}