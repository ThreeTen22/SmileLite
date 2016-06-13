//
//  TableViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/7/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(String(xonData[0][0]))
        print(String(xonData[0][1]))
        print(String(xonData[0][2]))
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
        return cell
    }
    
}
