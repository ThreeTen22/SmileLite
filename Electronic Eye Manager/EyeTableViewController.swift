//
//  EyeTableViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 9/28/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EyeTableViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate {
    
    enum FilterType {
        case ShowAll
        case ShowListing
    }
    
    @IBOutlet var listingCollection: StockFilterView!
    
    @IBOutlet var tableViewOutlet: UITableView!
    
    var listingSymbols = [String]()
    var filteredSymbol:Listing = Listing()
    var currentFilter = FilterType.ShowAll
    var selectedSymbol = ""
    var eyeArray:Array = [AnyObject]()
    
    var focusedListing:Listing?
    var focusedMonthContainer:MonthContainer?
    
    var newRowIndex:Int = 0
    var indxToUse:Int = 0
    
    var selectedIndx:Int = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.style
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var emptyEyes = true
        var currentListing:Listing {
            if currentFilter == .ShowAll {
                return eyeBook.listings[section]
            } else {
                return eyeBook.getListingBySymbol(selectedSymbol)!
            }
        }
        //return currentListing.registeredMonthContainers.count
        //DEBUG
          return 1
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row != selectedIndx {
            let cell = tableView.dequeueReusableCellWithIdentifier("Eye", forIndexPath: indexPath)
            return cell
        } else {
            let cellExt = tableView.dequeueReusableCellWithIdentifier("ModifyEye", forIndexPath: indexPath)
            return cellExt
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == selectedIndx{
            return CGFloat(280.0)
        }
        return CGFloat(100.0)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedIndx != indexPath.row {
            selectedIndx = indexPath.row
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            tableView.endUpdates()
        } else {
            selectedIndx = -1
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            tableView.endUpdates()
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isKindOfClass(StockFilterView) {
            return eyeBook.listings.count
        }
        if collectionView.isKindOfClass(QuickChangeValuesCollectionView) {
            return 12
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.isKindOfClass(StockFilterView) {
            let listingAtIndexPath = eyeBook.listings[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Listing", forIndexPath: indexPath)
            (cell.contentView.viewWithTag(1) as! UIButton).setTitle(listingAtIndexPath.listingsymbol, forState: .Normal)
            if listingAtIndexPath.isSelected {
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.blackColor().CGColor
            }
            else {
                cell.layer.borderWidth = 0.0
                cell.layer.borderColor = UIColor.clearColor().CGColor
            }
            return cell
        }
        if collectionView.isKindOfClass(QuickChangeValuesCollectionView) {
            let rowMod = indexPath.row%3
            switch rowMod {
            case 0:
                return collectionView.dequeueReusableCellWithReuseIdentifier("decreaseValue", forIndexPath: indexPath)
            case 1:
                return collectionView.dequeueReusableCellWithReuseIdentifier("changeAmount", forIndexPath: indexPath)
            case 2:
                return collectionView.dequeueReusableCellWithReuseIdentifier("increaseValue", forIndexPath: indexPath)
            default:
                return collectionView.dequeueReusableCellWithReuseIdentifier("ERROR", forIndexPath: indexPath)
            }
        }
        return collectionView.dequeueReusableCellWithReuseIdentifier("ERROR", forIndexPath: indexPath)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
