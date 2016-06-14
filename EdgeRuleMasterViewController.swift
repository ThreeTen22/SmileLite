//
//  EdgeRuleMasterViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/13/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

var scbpEdgeRule:NSArray = ["Sell Call | Buy Put","$ Edge", 0.00, 0, 0.0, 100.0]
var bcspEdgeRule:NSArray = ["Buy Call | Sell Put","$ Edge", 0.00, 5000, 0.0, 100.0]

class EdgeRuleMasterViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
        var tempArray:NSArray = NSArray()
        
        if indexPath.row == 0 {
            tempArray = scbpEdgeRule
        }
        else {
            tempArray = bcspEdgeRule
        }
        for i in tempArray {
            print("hello \(i)")
        }
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .Default, title: "Edit Edge Rule") { action, index in
            print("more button tapped")
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

