//
//  EyeTableViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 9/28/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

//class EyeTableViewController: UIViewController, UICollectionViewDelegate, UITextFieldDelegate {
//    
//    enum FilterType {
//        case ShowAll
//        case ShowListing
//    }
//    
//    var filteredListing:Listing = Listing()
//    var currentFilter = FilterType.ShowAll
//    var selectedSymbol = ""
//    var eyeContainerArray:Array = [AnyObject]()
//
//    
//    weak var focusedListing:Listing?
//    
//    var sectionRowCounts:Array = [Int]()
//    
//    var selectedIndx:(Int, Int) = (-1, -1)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //(self.view as! UITableView).rowHeight = UITableViewAutomaticDimension
//        //(self.view as! UITableView).estimatedRowHeight = 100
//        //(self.view as! UITableView).beginUpdates()
//        //(self.view as! UITableView).endUpdates()
//        
//        eyeContainerArray.removeAll()
//        sectionRowCounts.removeAll()
//   
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        //(self.view as! UITableView).beginUpdates()
//        //(self.view as! UITableView).endUpdates()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    func gatherEyeData(myEyeBook: EyeBook) {
//        var containerCount = 0
//        for listing in myEyeBook.listings {
//            containerCount = 0
//            for container in listing.registeredMonthContainers {
//                for eye in container.monthEyes {
//                    if eye != nil {
//                        eyeContainerArray.append(container)
//                        containerCount += 1
//                        break
//                    }
//                }
//            }
//            sectionRowCounts.append(containerCount)
//        }
//    }
//    
//    
//    //func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}
//    
//    
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView.isKindOfClass(ListingCollectionView) {
//            return eyeBook.listings.count
//        }
//        return 1
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let index = collectionView.tag
//        let expDateString = (eyeBook.listings[index].registeredMonthContainers[0]).expDateString
//
//        let listingMonth = collectionView.dequeueReusableCellWithReuseIdentifier("Month", forIndexPath: indexPath)
//        //DEBUG - ONLY GETTING FIRST MONTH INDEX.  NEED TO GET collectionView(numberOfItemsInSection working
//        (listingMonth.viewWithTag(1) as! UIButton).setTitle(expDateString, forState: .Normal)
//        return listingMonth
//        //return oldCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        //oldCollectionViewDidSelectRow(collectionView, didSelectItemAtIndexPath: indexPath)
//    
//    }
//    
//
//    
//    //MARK: - Navigation
//    /*
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    
//    //    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//    //        if let oldTextField = activeTextField {
//    //            oldTextField.backgroundColor = UIColor.clearColor()
//    //        }
//    //        textField.backgroundColor = UIColor.yellowColor()
//    //        activeTextField = textField
//    //        return false
//    //    }
//
//    
////    func oldCellSetup(tableView:UITableView, indexPath:NSIndexPath) -> UITableViewCell {
////        let curSection = indexPath.section
////        var counter = 0
////        var indx = 0
////        
////        
////        //        while counter < curSection {
////        //            indx += sectionRowCounts[counter]
////        //            counter += 1
////        //        }
////        
////        indx += indexPath.row
////        
////        var currentEyeContainer:MonthContainer {
////            if currentFilter == .ShowAll {
////                return (eyeBook.listings[curSection].registeredMonthContainers[indx])
////            } else {
////                if let curListing = focusedListing {
////                    return curListing.registeredMonthContainers[indx]
////                }
////                print("ERROR : EyeTableViewController : tableView(cellForRowAtIndexPath) : var currentEyeContainer :")
////                return MonthContainer()
////            }
////        }
////        
////        if (indexPath.section,indexPath.row) != selectedIndx {
////            let cell = tableView.dequeueReusableCellWithIdentifier("Eye", forIndexPath: indexPath) as! EyeTableViewCell
////            
////            cell.month.text = currentEyeContainer.expDateString
////            
////            if let bcEye = (currentEyeContainer.GetMonthByOrder(Order.buyCall) as MonthEye?) {
////                cell.bcQE.text = "\(bcEye.quantity) - \(bcEye.minEdge)"
////            } else {
////                //TODO: Grey out Buttons
////                cell.bcQE.text = "no eye"
////                cell.bcQE.enabled = false
////            }
////            
////            if let bpEye = (currentEyeContainer.GetMonthByOrder(Order.buyPut) as MonthEye?) {
////                cell.bpQE.text = "\(bpEye.quantity) - \(bpEye.minEdge)"
////            } else {
////                //TODO: Grey out Buttons
////                cell.bpQE.text = "no eye"
////                cell.bpQE.enabled = false
////            }
////            if let scEye = (currentEyeContainer.GetMonthByOrder(Order.sellCall) as MonthEye?) {
////                cell.scQE.text = "\(scEye.quantity) - \(scEye.minEdge)"
////            } else {
////                //TODO: Grey out Buttons
////                cell.scQE.text = "no eye"
////                cell.scQE.enabled = false
////            }
////            if let spEye = (currentEyeContainer.GetMonthByOrder(Order.sellPut) as MonthEye?) {
////                cell.spQE.text = "\(spEye.quantity) - \(spEye.minEdge)"
////            } else {
////                //TODO: Grey out Buttons
////                cell.spQE.text = "no eye"
////                cell.spQE.enabled = false
////            }
////            
////            if let deltaTF = (currentEyeContainer.GetMonthByOrder(Order.buyCall) as MonthEye?) {
////                cell.deltaLabel.text = "\(deltaTF.totalDelta)"
////            }
////            
////            if currentEyeContainer.strikeEyes[0].count > 0 {
////                cell.bcStrikesBtn.setTitle("\(currentEyeContainer.strikeEyes.count)", forState: .Normal)
////                cell.bcStrikesBtn.backgroundColor = UIColor.greenColor()
////                cell.bcStrikesBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
////                //TODO:
////            } else {
////                cell.bcStrikesBtn.setTitle("0", forState: .Normal)
////                cell.bcStrikesBtn.backgroundColor = UIColor.lightGrayColor()
////            }
////            
////            if currentEyeContainer.strikeEyes[1].count > 0 {
////                cell.scStrikesBtn.setTitle("\(currentEyeContainer.strikeEyes.count)", forState: .Normal)
////                cell.scStrikesBtn.backgroundColor = UIColor.greenColor()
////                cell.scStrikesBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
////                //TODO:
////            } else {
////                cell.scStrikesBtn.setTitle("0", forState: .Normal)
////                cell.scStrikesBtn.backgroundColor = UIColor.lightGrayColor()
////            }
////            
////            if currentEyeContainer.strikeEyes[2].count > 0 {
////                cell.bpStrikesBtn.setTitle("\(currentEyeContainer.strikeEyes.count)", forState: .Normal)
////                cell.bpStrikesBtn.backgroundColor = UIColor.greenColor()
////                cell.bpStrikesBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
////                //TODO:
////            } else {
////                cell.bpStrikesBtn.setTitle("0", forState: .Normal)
////                cell.bpStrikesBtn.backgroundColor = UIColor.lightGrayColor()
////            }
////            
////            if currentEyeContainer.strikeEyes[3].count > 0 {
////                cell.spStrikesBtn.setTitle("\(currentEyeContainer.strikeEyes.count)", forState: .Normal)
////                cell.spStrikesBtn.backgroundColor = UIColor.greenColor()
////                cell.spStrikesBtn.titleLabel?.textColor = UIColor.blueColor()
////                //TODO:
////            } else {
////                cell.spStrikesBtn.setTitle("0", forState: .Normal)
////                cell.spStrikesBtn.backgroundColor = UIColor.lightGrayColor()
////            }
////            
////            
////            
////            //cell.curMonthContainer = currentEyeContainer
////            if selectedIndx != (-1, -1) {
////                cell.userInteractionEnabled = false
////            }
////            
////            return cell
////            
////            
////        } else {
////            
////            
////            let cellExt = tableView.dequeueReusableCellWithIdentifier("ModifyEye", forIndexPath: indexPath) as! EyeTableViewCellExtended
////            
////            cellExt.month.text = currentEyeContainer.expDateString
////            
////            if let bcEye = (currentEyeContainer.GetMonthByOrder(Order.buyCall) as MonthEye?) {
////                cellExt.bcQuantityTF.text = "\(bcEye.quantity)"
////                cellExt.bcEdgeTF.text = "\(bcEye.minEdge)"
////            } else {
////                //TODO: Grey out Buttons
////                cellExt.bcQuantityTF.enabled = false
////                cellExt.bcEdgeTF.enabled = false
////                
////            }
////            if let bpEye = (currentEyeContainer.GetMonthByOrder(Order.buyPut) as MonthEye?) {
////                cellExt.bpQuantityTF.text = "\(bpEye.quantity)"
////                cellExt.bpEdgeTF.text = "\(bpEye.minEdge)"
////            } else {
////                //TODO: Grey out Buttons
////                cellExt.bpQuantityTF.enabled = false
////                cellExt.bpEdgeTF.enabled = false
////            }
////            if let scEye = (currentEyeContainer.GetMonthByOrder(Order.sellCall) as MonthEye?) {
////                cellExt.scQuantityTF.text = "\(scEye.quantity)"
////                cellExt.scEdgeTF.text = "\(scEye.minEdge)"
////            } else {
////                //TODO: Grey out Buttons
////                cellExt.scQuantityTF.enabled = false
////                cellExt.scEdgeTF.enabled = false
////            }
////            if let spEye = (currentEyeContainer.GetMonthByOrder(Order.sellPut) as MonthEye?) {
////                cellExt.spQuantityTF.text = "\(spEye.quantity)"
////                cellExt.spEdgeTF.text = "\(spEye.minEdge)"
////            } else {
////                //TODO: Grey out Buttons
////                cellExt.spQuantityTF.enabled = false
////                cellExt.spEdgeTF.enabled = false
////            }
////            
////            if let deltaTF = (currentEyeContainer.GetMonthByOrder(Order.buyCall) as MonthEye?) {
////                cellExt.deltaTF.text = "\(deltaTF.totalDelta)"
////            }
////            
////            return cellExt
////        }
////    }
////    
////    func oldCollectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
////        if collectionView.isKindOfClass(StockFilterView) {
////            let listingAtIndexPath = eyeBook.listings[indexPath.row]
////            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Listing", forIndexPath: indexPath)
////            (cell.contentView.viewWithTag(1) as! UILabel).text = listingAtIndexPath.listingsymbol
////            print("DEBUG: EyeTableViewController: CollectionView(): StockFilterView:  \(listingAtIndexPath.listingsymbol)" )
////            
////            if listingAtIndexPath.isSelected {
////                cell.layer.borderWidth = 1.0
////                cell.layer.borderColor = UIColor.darkGrayColor().CGColor
////            }
////            else {
////                cell.layer.borderWidth = 1.0
////                cell.layer.borderColor = UIColor.lightGrayColor().CGColor
////            }
////            return cell
////        }
////        return collectionView.dequeueReusableCellWithReuseIdentifier("ERROR", forIndexPath: indexPath)
////    }
////    
////    func oldCollectionViewDidSelectRow(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
////        let listingAtIndexPath = eyeBook.listings[indexPath.row]
////        if !listingAtIndexPath.isSelected {
////            listingAtIndexPath.isSelected = true
////            currentFilter = .ShowListing
////            
////            focusedListing?.isSelected = false
////            focusedListing = listingAtIndexPath
////            
////            tableViewOutlet.beginUpdates()
////            tableViewOutlet.deleteSections(NSIndexSet.init(indexesInRange: NSRange.init(location: 0, length: tableViewOutlet.numberOfSections)), withRowAnimation: .Right)
////            tableViewOutlet.insertSections(NSIndexSet.init(index: 0), withRowAnimation: .Left)
////            tableViewOutlet.endUpdates()
////        } else {
////            focusedListing?.isSelected = false
////            currentFilter = .ShowAll
////            focusedListing = nil
////            
////            tableViewOutlet.beginUpdates()
////            tableViewOutlet.deleteSections(NSIndexSet.init(index: 0), withRowAnimation: .Right)
////            tableViewOutlet.insertSections(NSIndexSet.init(indexesInRange: NSRange.init(location: 0, length: eyeBook.listings.count)), withRowAnimation: .Left)
////            tableViewOutlet.endUpdates()
////            
////        }
////    }
//
//}
