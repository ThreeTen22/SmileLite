//
//  TableViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/7/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var selectMinDelta: Bool = false
    var deltaRange = [-1,-1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xonData.count
    }
    // Date  Strk CBid CAsk  CTheo Cpos PBid PAsk PTheo, PPos, PutDelta (11 total)
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("strikeCell", forIndexPath: indexPath) as! MonthEyeCell
        let monthFocus = "06/17/16"
        
        if String(xonData[indexPath.row][0]) == monthFocus {
            cell.strikePrice?.text = String(xonData[indexPath.row][1])
            cell.delta?.text = removeAfterIndex(Source: String(xonData[indexPath.row][10]), CutOffIndex: 6)
            cell.cTheo?.text = removeAfterIndex(Source: String(xonData[indexPath.row][3]), CutOffIndex: 4)
            cell.cPos?.text = String(xonData[indexPath.row][5])
            cell.pTheo?.text = removeAfterIndex(Source: String(xonData[indexPath.row][8]), CutOffIndex: 4)
            cell.pPos?.text = String(xonData[indexPath.row][9])
        }
        if deltaRange[0] <= indexPath.row && indexPath.row <= deltaRange[1] && deltaRange[0] != (-1) {
            cell.backgroundColor = UIColor.lightGrayColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var title = "lower bound"
        if selectMinDelta {
            title = "high delta"
        } else {
            title = "low delta"
        }
        let delta = UITableViewRowAction(style: .Default, title: title) { action, index in
                if self.selectMinDelta {
                    self.selectMinDelta = false
                    self.deltaRange[1] = indexPath.row
                } else {
                    self.selectMinDelta = true
                    self.deltaRange[0] = indexPath.row
                }
                self.tableView.reloadData()
                print(self.deltaRange)
            }
        delta.backgroundColor = UIColor.blueColor()
        
        if deltaRange[0] != (-1) || deltaRange[1] != (-1) {
            let clearDelta = UITableViewRowAction(style: .Default, title: "clear range", handler: { action, index in
                self.deltaRange[0] = -1
                self.deltaRange[1] = -1
                self.tableView.reloadData()
                self.selectMinDelta = false
            })
            return [delta,clearDelta]
        }
            return [delta]
        }
}
