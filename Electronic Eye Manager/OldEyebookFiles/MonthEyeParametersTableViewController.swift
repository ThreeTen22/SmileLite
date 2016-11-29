//
//  MonthEyeParametersTableViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 8/3/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit
class MonthEyeParametersTableViewController: UITableViewController, UITextFieldDelegate {
    let orderTypes = ["EOD","LMT"]
    var monthEyeViewController:MonthEyeMainViewController?
    var currentMonthContainer:MonthContainer?
    
    
    @IBAction func changeOrderType(sender: UIButton) {
        print("inside change order")
        print("title Label: "+(sender.titleLabel?.text)!)
        if sender.titleLabel?.text == orderTypes[0] {
            sender.setTitle(orderTypes[1], forState: .Normal)
        } else {
            sender.setTitle(orderTypes[0], forState: .Normal)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eyeParameters.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let monthEyes = currentMonthContainer!.monthEyes
        if indexPath.row != 4 {
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("InputCell", forIndexPath: indexPath)
            let cellView = cell.contentView
            //["Delta","Quanity","Min Edge", "Max Delta","Order Type"]
            
            ((cell.contentView.viewWithTag(1)) as! UILabel).text = eyeParameters[indexPath.row]
            for i in 0...3 {
                switch indexPath.row {
                case 0:
                    ((cellView.viewWithTag(i+2)) as! UITextField).text = "\(monthEyes[i]!.quantityDelta)"
                case 1:
                    ((cellView.viewWithTag(i+2)) as! UITextField).text = "\(monthEyes[i]!.quantity)"
                case 2:
                    ((cellView.viewWithTag(i+2)) as! UITextField).text = "\(monthEyes[i]!.minEdge)"
                case 3:
                    ((cellView.viewWithTag(i+2)) as! UITextField).text = "\(monthEyes[i]!.maxDelta)"
                default:
                    print("ERROR:  SWITCH IN MONTHEYEPARAMETERCONTROLLER HIT DEFAULT")
                }
            }
            return cell
        } else {
            let orderCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("OrderTypeCell", forIndexPath: indexPath)
            for i in 0...3 {
                ((orderCell.contentView.viewWithTag(i+1)) as! UIButton).setTitle("\(monthEyes[i]!.orderType)", forState: .Normal)
            }
            return orderCell
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        print("TappedCell")
        let tappedCell = tableView.cellForRowAtIndexPath(indexPath)
        for i in 0...3 {
            if let monthEye = monthEyeViewController {
                if let currentTextField = (tappedCell?.contentView.viewWithTag(i+2) as? UITextField) {
                    if (monthEye.indexOfActiveTextField(currentTextField) == nil) {
                        monthEye.appendActiveTextField(currentTextField)
                        currentTextField.backgroundColor = UIColor.yellowColor()
                    }
                }
                
            }
        }
        
        return false
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let monthEye = monthEyeViewController {
            if monthEye.removeActiveTextFieldIfPresent(textField) {
            } else {
                monthEye.appendActiveTextField(textField)
            }
        }
        return bWillUseKeyboard; //do not show keyboard nor cursor
    }
    
    
}