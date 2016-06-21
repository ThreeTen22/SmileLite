//
//  MonthEyeMainViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/20/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class MonthEyeMainViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var monthEyeActivateTable: UITableView!
    
    @IBAction func sellCallAtn(sender: UIButton) {
        print(sender.superview)
        changeActiveButton(0, sender)
    }
    @IBAction func buyPutAtn(sender: UIButton) {
        changeActiveButton(1, sender)
    }

    @IBAction func buyCallAtn(sender: UIButton) {
        changeActiveButton(2, sender)
    }
    
    @IBAction func sellPutAtn(sender: UIButton) {
        changeActiveButton(3, sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeActiveButton(index:Int,_ btnToModify:UIButton) {
       let monthEyeActiveCell = monthEyeActivateTable.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! MonthEyeActivateCell
        if (monthEyeActiveCell.isBtnActive[index]) {
            btnToModify.backgroundColor = UIColor.whiteColor()
            monthEyeActiveCell.isBtnActive[index] = false
        } else {
            btnToModify.backgroundColor = UIColor.blueColor()
            monthEyeActiveCell.isBtnActive[index] = true
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = monthEyeActivateTable.dequeueReusableCellWithIdentifier("MonthCell") as! MonthEyeActivateCell
        if let monthName = cell.viewWithTag(5) as? UILabel {
            monthName.text = "\(xonTitleData[0]) \(xonData[0][0])"
        }
        return cell
    }

}
