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
        let destView = (segue.destinationViewController as! EdgeRuleDetailViewController)
        if (sender as! NSIndexPath).row == 0 {
            destView.isBCSP = false
            destView.edgeRuleArray = scbpEdgeRule
            destView.edgeRuleArrayBackup = scbpEdgeRule
        } else {
            destView.isBCSP = true
            destView.edgeRuleArray = bcspEdgeRule
            destView.edgeRuleArrayBackup = bcspEdgeRule
        }
        
        for i in parentViewController!.parentViewController!.childViewControllers {
            if let x = (i as? GraphViewController) {
                destView.graphVC = x
            }
        }
        
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    // indexPath.row: 0 = scbp | 1 = bcsp
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("EdgeRuleDetails", forIndexPath: indexPath)
        
        var tempArray = [["    "],["   "]]
        
        if indexPath.row == 0 {
            tempArray = scbpEdgeRule
            (cell.contentView.viewWithTag(1) as! UILabel).textColor = UIColor(red: 240.0, green: 0.0, blue: 0.0, alpha: 1.0)
            
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
        var mimicFrom = ["SCBP", "BCSP"]
        var mimicTitle = ""
        
        var graph:GraphViewController {
            for i in parentViewController!.parentViewController!.childViewControllers {
                if let x = (i as? GraphViewController) {
                    return x
                }
            }
            return GraphViewController()
        }
        
        
        
        if indexPath.row == 0 {
            mimicTitle = "Mimic\n\(mimicFrom[1])\nParameters"
        } else {
            mimicTitle = "Mimic\n\(mimicFrom[0])\nParameters"
        }
        
        let editRule = UITableViewRowAction(style: .Default, title: "Edit\nEdge Rule") { action, index in
            self.performSegueWithIdentifier("editEdgeRule", sender: indexPath)
        }
        
        let mimicRule = UITableViewRowAction(style: .Default, title: mimicTitle) { action, index in
            if indexPath.row == 0 {
                scbpEdgeRule = bcspEdgeRule
                scbpEdgeRule[0][0] = (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.viewWithTag(1) as! UILabel).text!
            }
            else {
                bcspEdgeRule = scbpEdgeRule
                bcspEdgeRule[0][0] = (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))?.viewWithTag(1) as! UILabel).text!
                
            }
            self.tableView.reloadData()
            graph.graph.setNeedsDisplay()
            self.performSegueWithIdentifier("editEdgeRule", sender: indexPath)
        }
        
        editRule.backgroundColor = UIColor.darkGrayColor()
        mimicRule.backgroundColor = UIColor.orangeColor()
        return [editRule, mimicRule]
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
}

