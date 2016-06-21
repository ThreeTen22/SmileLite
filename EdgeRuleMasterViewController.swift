//
//  EdgeRuleMasterViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/13/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EdgeRuleMasterViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("sender  \(sender)")
        print("segue  \(segue)")
        if (sender as! NSIndexPath).row == 0 {
            (segue.destinationViewController as! EdgeRuleDetailViewController).isBCSP = false
            (segue.destinationViewController as! EdgeRuleDetailViewController).edgeRuleArray = scbpEdgeRule
        } else {
            (segue.destinationViewController as! EdgeRuleDetailViewController).isBCSP = true
            (segue.destinationViewController as! EdgeRuleDetailViewController).edgeRuleArray = bcspEdgeRule
        }
        
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("EdgeRuleDetails", forIndexPath: indexPath)
        
        var tempArray = [["    "],["   "]]
        
        if indexPath.row == 0 {
            tempArray = scbpEdgeRule
        }
        else {
            tempArray = bcspEdgeRule
        }
        for i in 1...5 {
            (cell.contentView.viewWithTag(i) as! UILabel).text! = "\(tempArray[0][i-1])"
            
        }
        
        return cell
        
    }
    
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .Default, title: "Edit Edge Rule") { action, index in
            print("Edit Edge Mode Pressed")
            self.performSegueWithIdentifier("editEdgeRule", sender: indexPath)
        }
        more.backgroundColor = UIColor.lightGrayColor()
        
        return [more]
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
}

