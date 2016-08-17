//
//  MonthEyeMainViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/20/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class MonthEyeMainViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var monthEyeActivateTable: UITableView!
    
    @IBOutlet var monthEyeParametersContainer: UIView!
    
    
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
    
    @IBAction func useKeyboard(sender: AnyObject) {
        if bWillUseKeyboard == true {
            bWillUseKeyboard = false
        } else {
            bWillUseKeyboard = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in super.childViewControllers {
                print(i.title)
        }
        
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
            btnToModify.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            btnToModify.backgroundColor = UIColor.blueColor()
            btnToModify.setTitleColor(UIColor.whiteColor(), forState: .Normal)
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
        let xonDataZero = xonData[0] as! NSArray
        if let monthName = cell.viewWithTag(5) as? UILabel {
            monthName.text = "\(xonTitleData[0]) \(xonDataZero[0])"
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let numberpad:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Number", forIndexPath: indexPath)
        
        switch indexPath.row {
        case 9:
            (numberpad.contentView.viewWithTag(1) as! UIButton).setTitle("cancel", forState: .Normal)
        case 10:
            (numberpad.contentView.viewWithTag(1) as! UIButton).setTitle("0", forState: .Normal)
        case 11:
            (numberpad.contentView.viewWithTag(1) as! UIButton).setTitle("return", forState: .Normal)
        default:
            (numberpad.contentView.viewWithTag(1) as! UIButton).setTitle("\(indexPath.row+1)", forState: .Normal)
        }
        
        return numberpad
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let calcHeader = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
        
        return calcHeader
        
    }
    

}
