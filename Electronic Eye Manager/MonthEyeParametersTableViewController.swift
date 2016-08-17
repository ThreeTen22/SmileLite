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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eyeParameters.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("ParametersSegue")
        print(segue.identifier)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row != 4 {
            let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("InputCell", forIndexPath: indexPath)
            let cellView = cell.contentView
            //["Delta","Quanity","Min Edge", "Max Delta","Order Type"]
            
            ((cell.contentView.viewWithTag(1)) as! UILabel).text = eyeParameters[indexPath.row]
            
            for i in 0...3 {
                switch indexPath.row {
                case 0:
                    ((cellView.viewWithTag(i+2)) as! UITextField).text = "\(currentMonthEye.quantityDelta[i])"
                case 1:
                    ((cellView.viewWithTag(i+2)) as! UITextField).text = "\(currentMonthEye.quantity[i])"
                case 2:
                    ((cellView.viewWithTag(i+2)) as! UITextField).text = "\(currentMonthEye.minEdge[i])"
                case 3:
                    ((cellView.viewWithTag(i+2)) as! UITextField).text = "\(currentMonthEye.maxDelta[i])"
                default:
                    print("ERROR:  SWITCH IN MONTHEYEPARAMETERCONTROLLER HIT DEFAULT")
                }
            }
            return cell
        } else {
            let orderCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("OrderTypeCell", forIndexPath: indexPath)
            for i in 0...3 {
                ((orderCell.contentView.viewWithTag(i+1)) as! UIButton).setTitle("\(currentMonthEye.orderType[i])", forState: .Normal)
            }
            return orderCell
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("Editing TextField")
        textField.selected = true
        return bWillUseKeyboard; //do not show keyboard nor cursor
    }
    
}