//
//  EdgeRuleDetailViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/13/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EdgeRuleDetailViewController: UIViewController, UIPickerViewDelegate {
    //These values get changed at runtime,  compiler was complaining
    var edgeRuleTypes = ["$ Edge", "Vega Edge"]
    var edgeRuleArray = [["    "],["   "]]
    var edgeRuleArrayBackup = [["    "],["   "]]
    var isBCSP:Bool = false
    var curRowIndx = [0,0,0,0]
    var graphVC:GraphViewController = GraphViewController()
    var didAppear = false
    
    
    @IBOutlet var edgeRulePicker: UIPickerView!
    
    override func viewDidLoad() {
        didAppear = false
        var str:String = ""
        for i in 1...4 {
            str = String(edgeRuleArray[1][i])
//            print("Begin ViewDidLoadDebug:")
//            print(edgeRuleArray[1][i])
//            print(edgeRuleArray[0][i])
//            print("End ViewDidLoadDebug")
            curRowIndx[i-1] = Int(str)!
            edgeRulePicker.selectRow(Int(str)!, inComponent: (i-1), animated: false)
            
            print("startingCur: \(curRowIndx)")
        }
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        didAppear = true
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
            return 67
        case 3:
            return 201
        case 4:
            return 101
        default:
            return 0
        }
    }
    //var bcspEdgeRule:NSArray = [["Buy Call | Sell Put","$ Edge", 0.0, 0, 0.0, 0.0],[0,0,0,0,0,0]]
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let returnStr = getTitleInfo(row, component)
        let tempRow = pickerView.selectedRowInComponent(component)
        if tempRow != curRowIndx[component] && didAppear {
            curRowIndx[component] = tempRow
            if (row - tempRow) < 0 {
                setInformation(pickerView, tempRow - 1, component)
            }
            else if (row - tempRow) > 0 {
                setInformation(pickerView, tempRow + 1, component)
            }
            print("row \(row) temprow    \(tempRow) component \(component) didAppear: \(didAppear)")
            graphVC.redrawGraph()
        }
        return returnStr
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setInformation(pickerView, row, component)
        graphVC.redrawGraph()
        print("selected: \(row)")
    }
    
    func getTitleInfo(row:Int, _ component:Int) -> String {
        let rowDbl:Double = Double(row)
        var returnStr = ""
        switch component {
        case 0:
            returnStr = edgeRuleTypes[row]
        case 1:
            returnStr = appendZerosToString(numberAsString: String(rowDbl*0.01), MinCharLength: 4)
        case 2:
            if row < 21 {
                returnStr = String(100*row)
            }
            else {
                returnStr = String(2000+(500*(row-20)))
            }
        case 3:
            returnStr = appendZerosToString(numberAsString: String(rowDbl*0.01), MinCharLength: 4)
            
        case 4:
            returnStr = String(row)
        default:
            returnStr = ""
        }
        return returnStr
        
    }
    
    func setInformation(pickerView:UIPickerView, _ row:Int, _ component: Int) {
        
        if isBCSP {
            //              get information and put it into the array
            bcspEdgeRule[0][component+1] = self.pickerView(pickerView, titleForRow: row, forComponent: component)!
            
            //              add Index
            bcspEdgeRule[1][component+1] = String(row)
        }
        else {
            //              get information and put it into the array
           
            scbpEdgeRule[0][component+1] = self.pickerView(pickerView, titleForRow: row, forComponent: component)!
            //              add Index
            scbpEdgeRule[1][component+1] = String(row)
        }
    }
}