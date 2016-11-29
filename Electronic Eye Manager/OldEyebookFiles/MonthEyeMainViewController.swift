//
//  MonthEyeMainViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/20/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class MonthEyeMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var currentListing:Listing?
    var currentMonthContainer:MonthContainer?
    
    var paramViewController:MonthEyeParametersTableViewController?
    var strikesViewController:TableViewController?
    var activeTextField:Array = [UITextField]()
    
    
    @IBOutlet var symbolTitle: UILabel!
    
    @IBAction func useKeyboard(sender: AnyObject) {
        if bWillUseKeyboard == true {
            bWillUseKeyboard = false
        } else {
            bWillUseKeyboard = true
        }
    }
    
    @IBAction func clearSelection(sender:UIButton) {
        for i in activeTextField {
            i.backgroundColor = nil
        }
        activeTextField.removeAll()
    }
    
    @IBAction func cancelChanges(sender:UIButton) {
        paramViewController?.tableView.reloadData()
        clearSelection(sender)
    }
    
    @IBAction func setToZero(sender:UIButton) {
        for i in activeTextField {
            i.text = "0.0"
        }
    }
    
    @IBAction func saveChanges(sender:UIButton) {
        if let paramVC = paramViewController {
            print(paramVC)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbolTitle.text = currentMonthContainer!.listingSymbol + " - " + currentMonthContainer!.expDateString
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeActiveTextFieldIfPresent(textField:UITextField) -> Bool {
        if let index = activeTextField.indexOf(textField) {
            activeTextField.removeAtIndex(index)
            if !bWillUseKeyboard {
                textField.backgroundColor = nil
            }
            return true
        }
        return false
    }
    
    func appendActiveTextField(textField:UITextField) -> Bool {
        if activeTextField.indexOf(textField) == nil {
            activeTextField.append(textField)
            if !bWillUseKeyboard {
                textField.backgroundColor = UIColor.yellowColor()
            }
            return true
        }
        return false
    }
    
    func indexOfActiveTextField(textField:UITextField) -> Int? {
        return activeTextField.indexOf(textField)
    }
    
//    func changeActiveButton(index:Int,_ btnToModify:UIButton) {
//        let monthEyeActiveCell = monthEyeActivateTable.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! MonthEyeActivateCell
//        if (monthEyeActiveCell.isBtnActive[index]) {
//            btnToModify.backgroundColor = UIColor.whiteColor()
//            monthEyeActiveCell.isBtnActive[index] = false
//            btnToModify.setTitleColor(UIColor.blueColor(), forState: .Normal)
//        } else {
//            btnToModify.backgroundColor = UIColor.blueColor()
//            btnToModify.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//            monthEyeActiveCell.isBtnActive[index] = true
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "parameters":
                paramViewController = (segue.destinationViewController as! MonthEyeParametersTableViewController)
                paramViewController?.monthEyeViewController = self
                paramViewController?.currentMonthContainer = currentMonthContainer
            case "strikes" :
                strikesViewController = (segue.destinationViewController as! TableViewController)
            default:
                print("MonthEyeMainViewControler: Prepare For Segue Default Hit")
                currentListing = nil
                currentMonthContainer = nil
                paramViewController = nil
                strikesViewController = nil
            }
            print("Controllers")
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
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let numberpad:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Number", forIndexPath: indexPath)
        
        let numberPadButtn = (numberpad.contentView.viewWithTag(1) as! UIButton)
        
        switch indexPath.row {
        case 4:
            numberPadButtn.setTitle("1", forState: .Normal)
        case 5:
            numberPadButtn.setTitle("10", forState: .Normal)
        case 6:
            numberPadButtn.setTitle("100", forState: .Normal)
        case 7:
            numberPadButtn.setTitle("1000", forState: .Normal)
        default:
            if indexPath.row < 4 {
                numberPadButtn.setTitle("+", forState: .Normal)
            } else {
                numberPadButtn.setTitle("-", forState: .Normal)
            }
        }
        numberPadButtn.userInteractionEnabled = false
        
        return numberpad
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let calcHeader = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
        
        return calcHeader
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        var modifyValue = 0.0
        for i in activeTextField {
            switch indexPath.row {
            case 0:
                modifyValue = 1.0
            case 1:
                modifyValue = 10.0
            case 2:
                modifyValue = 100.0
            case 3:
                modifyValue = 1000.0
            case 8:
                modifyValue = -1.0
            case 9:
                modifyValue = -10.0
            case 10:
                modifyValue = -100.0
            case 11:
                modifyValue = -1000.0
            default:
                modifyValue = 0.0
            }
            let textValue = Double(i.text!)
            i.text = String(textValue! + modifyValue)
        }
        return true
    }
    
    
}
