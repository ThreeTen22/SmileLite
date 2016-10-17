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
    var eyeContainerArray:Array = [AnyObject]()
    
    var focusedListing:Listing?
    var focusedMonthContainer:MonthContainer?
    
    var newRowIndex:Int = 0
    var indxToUse:Int = 0
    
    var sectionRowCounts:Array = [Int]()
    var selectedListingEyeCount = 1 //TODO : Integrate and update that when listing is selected
    
    var selectedIndx:Int = -1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gatherEyeData(eyeBook)
        for container in eyeContainerArray {
            print("EYE ARRAY DATE: \((container as! MonthContainer).expDateString)")
        }
        //tableViewOutlet.style
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func gatherEyeData(myEyeBook: EyeBook) {
        var containerCount = 0
        eyeContainerArray.removeAll()
        sectionRowCounts.removeAll()
        for listing in myEyeBook.listings {
            containerCount = 0
            for container in listing.registeredMonthContainers {
                for eye in container.monthEyes {
                    if eye != nil {
                        eyeContainerArray.append(container)
                        containerCount += 1
                        break
                    }
                }
            }
            sectionRowCounts.append(containerCount)
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if currentFilter == FilterType.ShowAll {
            print("Number of sections returned - LISTING COUNT")
            return eyeBook.listings.count
        }
        print("Number of sections returned - SPECIFIC")
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentFilter == .ShowAll {
            return sectionRowCounts[section]
        } else {
            return selectedListingEyeCount
        }
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let curSection = indexPath.section
        var counter = 0
        var indx = 0
        var currentEyeContainer = MonthContainer()
        
        while counter < curSection {
            indx += sectionRowCounts[counter]
            counter += 1
        }
        indx += indexPath.row
        
        currentEyeContainer = (eyeContainerArray[indx] as! MonthContainer)
        
        
        if indexPath.row != selectedIndx {
            let cell = tableView.dequeueReusableCellWithIdentifier("Eye", forIndexPath: indexPath) as! EyeTableViewCell
            
            cell.month.text = currentEyeContainer.expDateString
            
            if let bcEye = (currentEyeContainer.GetMonthByOrder(Order.buyCall)! as MonthEye?) {
                cell.bcQE.text = "\(bcEye.quantity) - \(bcEye.minEdge)"
            } else {
                //TODO: Grey out Buttons
                cell.bcQE.text = "eye not created"
                cell.bcQE.enabled = false
            }
            if let bpEye = (currentEyeContainer.GetMonthByOrder(Order.buyPut) as MonthEye?) {
                cell.bpQE.text = "\(bpEye.quantity) - \(bpEye.minEdge)"
            } else {
                //TODO: Grey out Buttons
                cell.bpQE.text = "eye not created"
                cell.bpQE.enabled = false
            }
            if let scEye = (currentEyeContainer.GetMonthByOrder(Order.sellCall) as MonthEye?) {
                cell.scQE.text = "\(scEye.quantity) - \(scEye.minEdge)"
            } else {
                //TODO: Grey out Buttons
                cell.scQE.text = "eye not created"
                cell.scQE.enabled = false
            }
            if let spEye = (currentEyeContainer.GetMonthByOrder(Order.sellPut) as MonthEye?) {
                cell.spQE.text = "\(spEye.quantity) - \(spEye.minEdge)"
            } else {
                //TODO: Grey out Buttons
                cell.spQE.text = "eye not created"
                cell.spQE.enabled = false
            }
            
            if let deltaTF = (currentEyeContainer.GetMonthByOrder(Order.buyCall) as MonthEye?) {
                cell.deltaLabel.text = "\(deltaTF.totalDelta)"
            }
            //cell.curMonthContainer = currentEyeContainer
            
            return cell
            
            
        } else {
            
            
            let cellExt = tableView.dequeueReusableCellWithIdentifier("ModifyEye", forIndexPath: indexPath) as! EyeTableViewCellExtended
            
            cellExt.month.text = currentEyeContainer.expDateString
            
            if let bcEye = (currentEyeContainer.GetMonthByOrder(Order.buyCall)! as MonthEye?) {
                cellExt.bcQuantityTF.text = "\(bcEye.quantity)"
                cellExt.bcEdgeTF.text = "\(bcEye.minEdge)"
            } else {
                //TODO: Grey out Buttons
                cellExt.bcQuantityTF.enabled = false
                cellExt.bcEdgeTF.enabled = false

            }
            if let bpEye = (currentEyeContainer.GetMonthByOrder(Order.buyPut) as MonthEye?) {
                cellExt.bpQuantityTF.text = "\(bpEye.quantity)"
                cellExt.bpEdgeTF.text = "\(bpEye.minEdge)"
            } else {
                //TODO: Grey out Buttons
                cellExt.bpQuantityTF.enabled = false
                cellExt.bpEdgeTF.enabled = false
            }
            if let scEye = (currentEyeContainer.GetMonthByOrder(Order.sellCall) as MonthEye?) {
                cellExt.scQuantityTF.text = "\(scEye.quantity)"
                cellExt.scEdgeTF.text = "\(scEye.minEdge)"
            } else {
                //TODO: Grey out Buttons
                cellExt.scQuantityTF.enabled = false
                cellExt.scEdgeTF.enabled = false
            }
            if let spEye = (currentEyeContainer.GetMonthByOrder(Order.sellPut) as MonthEye?) {
                cellExt.spQuantityTF.text = "\(spEye.quantity)"
                cellExt.spEdgeTF.text = "\(spEye.minEdge)"
            } else {
                //TODO: Grey out Buttons
                cellExt.spQuantityTF.enabled = false
                cellExt.spEdgeTF.enabled = false
            }
            
            if let deltaTF = (currentEyeContainer.GetMonthByOrder(Order.buyCall) as MonthEye?) {
                cellExt.deltaTF.text = "\(deltaTF.totalDelta)"
            }
            
            return cellExt
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == selectedIndx{
            return CGFloat(280.0)
        }
        return CGFloat(80.0)
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
            print("DEBUG: EyeTableViewController: CollectionView(): StockFilterView:  \(listingAtIndexPath.listingsymbol)" )
            
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
