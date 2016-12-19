//
//  EyeListViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/12/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit


class EyeBookViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    
    var currentFilter = FilterType.listing
    var selectedSymbol = ""
    
    weak var filteredListing:Listing?
    
    
    var isTableAnimatedProgramatically = false
    //var newView = ((UINib.init(nibName: "InputView", bundle: nil)).instantiateWithOwner(nil, options: nil)[0] as! UIView)
    
    weak var eyePopoverViewController:EyePopoverViewController?
    //weak var selectedCell:StrikeCollectionViewCell?
    weak var selectedCellTextField:StrikeCellTextField?
    
    @IBOutlet weak var eyeBookTableView: UITableView!
    
    @IBAction func testAction(sender:AnyObject) {
        //eyeBookTableView.hidden = !eyeBookTableView.hidden
        eyeBookTableView.removeFromSuperview()
        eyeBookTableView = nil
        for i in eyeBook.listings {
            i.listingMaturities.removeAll()
            i.maturitiesToDisplay.removeAll()
            i.visibleStrikes.removeAll()
            for x in i.registeredMonthContainers {
                x.monthEyes.removeAll()
                for strikes in 0..<x.strikeEyes.count {
                    x.strikeEyes[strikes].removeAll()
                }
                x.strikeEyes.removeAll()
            }
            
        }
        eyeBook.listings.removeAll()
        eyeBook = EyeBook()
        eyebookRaw = ""
        
        
        //filteredListing = nil
        //print("TestButton")
    }
    
    
    @IBAction func pressedListingInFilterCollection(sender: ListingFilterButton) {
        //.all,  flisting = nil, listingTest = nil
        //.filter, flisting = selected, listingTest = flisting
        //.filter, flisting = select
        
        let sectionset = NSMutableIndexSet()
        let listingTest = eyeBook.getListingBySymbol(sender.listingSymbol)
        var modifyFilteredListing = false
        var justReload:Bool = false
        
        if let fListing = filteredListing {
            if fListing.listingSymbol == listingTest?.listingSymbol {
                fListing.isSelectedInEyebook = false
                filteredListing = nil
                currentFilter = .all
            }
            else {
                fListing.isSelectedInEyebook = false
                modifyFilteredListing = true
                justReload = true
            }
        } else {
            modifyFilteredListing = true
        }
        
        if modifyFilteredListing {
            listingTest?.isSelectedInEyebook = true
            filteredListing = listingTest
            currentFilter = .listing
            
            for (indx,listing) in eyeBook.listings.enumerate() {
                //print("\(listing.listingSymbol)  :  \(listing.isSelectedInEyebook)")
                if listing.isSelectedInEyebook == false {
                    sectionset.addIndex(indx)
                }
            }
        }
        
        
        //print("DEBUG:  filteredListing: \(filteredListing) + \(filteredListing?.listingSymbol) ")
        //print("")
        //print("DEBUG:  Listing.isSelectedInEyebook check : ")
        
        //print("DEBUG:  reloadData: ")
        if currentFilter == .all {
            for (indx,listing) in eyeBook.listings.enumerate() {
                if listing.listingSymbol != sender.listingSymbol {
                    sectionset.addIndex(indx)
                }
            }
            eyeBookTableView.beginUpdates()
            eyeBookTableView.insertSections(sectionset, withRowAnimation: .Automatic)
            eyeBookTableView.endUpdates()
        }
        else if justReload {
            eyeBookTableView.reloadData()
        } else if sectionset.count > 1 {
            eyeBookTableView.beginUpdates()
            eyeBookTableView.deleteSections(sectionset, withRowAnimation: UITableViewRowAnimation.Automatic)
            eyeBookTableView.endUpdates()
        }
        eyeBookTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Layout.eyeBookBGColor
        //monthDelegate.initalize()
        
        let jsonString = getEyes(clientSuccess, errmsg: clientErrmsg, client: client)
        if jsonString == eyebookRaw {
            clientSuccess = false
            
        }
        eyebookJSON = JSON.parse(jsonString)
        eyeBook = EyeBook(fromEyesJSON: eyebookJSON)
        
        
        
        
        parseXonString()
        
        //print("Strike Eyes:")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        /*
         deleteTable = false
         
         let jsonString = getEyes(clientSuccess, errmsg: clientErrmsg, client: client)
         if jsonString == eyebookRaw {
         clientSuccess = false
         }
         eyebookJSON = JSON.parse(jsonString)
         
         eyeBook = EyeBook(fromEyesJSON: eyebookJSON)
         */
    }
    
    override func viewWillDisappear(animated: Bool) {
        //print("/n EYEBOOK VIEW CONROLLER:  I Disappearing /n")
        //eyeBookTableView.reloadData()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //print(#function)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //let owningCollectionView = (textField.superview?.superview?.superview as! StrikeCollectionView)
        let owningCollectionCell = (textField.superview?.superview) as! StrikeCollectionViewCell
        selectedCellTextField = textField as? StrikeCellTextField
        
        //print(owningCollectionCell.cellType)
        switch owningCollectionCell.cellType {
        case .buyputmonthqe,.buyputstrikeqe,.buycallmonthqe,.buycallstrikeqe:
            break
        case .sellputmonthqe,.sellputstrikeqe,.sellcallmonthqe,.sellcallstrikeqe:
            break
        default:
            return false
        }
        
        let tableIndexPath = eyeBookTableView.indexPathForRowAtPoint(textField.convertPoint(textField.center, toView: eyeBookTableView))!
        isTableAnimatedProgramatically = true
        
        selectedCellTextField = textField as? StrikeCellTextField
        
        textField.backgroundColor = UIColor.yellowColor()
        if eyeBookTableView.contentOffset.y != 0 {
            eyeBookTableView.scrollToRowAtIndexPath(tableIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        } else {
            scrollViewDidEndScrollingAnimation(eyeBookTableView)
            return false
        }
        
        return false
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        //let owningCollectionView = (textField.superview?.superview?.superview as! StrikeCollectionView)
        //let owningIndexPath = owningCollectionView.indexPathForCell(owningCollectionCell)
        //let newIndexPath = NSIndexPath(forRow: (owningIndexPath?.row)!-18, inSection: (owningIndexPath?.section)!)
        
        //owningCollectionView.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
        
        if isTableAnimatedProgramatically {
            isTableAnimatedProgramatically = false
            eyePopoverViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("EyePopoverViewController") as? EyePopoverViewController)
            
            if let popOver = eyePopoverViewController {
                var isMonth = false
                var isBuy = false
                
                let textField:StrikeCellTextField! = selectedCellTextField
                let owningCollectionCell = (textField.superview?.superview) as! StrikeCollectionViewCell
                
                switch owningCollectionCell.cellType {
                case .buycallmonthqe:
                    isBuy = true
                    isMonth = true
                    popOver.orderType = Order.buycall
                case .buyputmonthqe:
                    isBuy = true
                    isMonth = true
                    popOver.orderType = .buyput
                case .buyputstrikeqe:
                    isBuy = true
                    popOver.orderType = .buyput
                case .buycallstrikeqe:
                    isBuy = true
                    popOver.orderType = .buycall
                case .sellcallmonthqe:
                    isMonth = true
                    popOver.orderType = .sellcall
                case .sellputmonthqe:
                    isMonth = true
                    popOver.orderType = .sellput
                case .sellputstrikeqe:
                    popOver.orderType = .sellput
                    break
                case .sellcallstrikeqe:
                    popOver.orderType = .sellcall
                    break
                default: break
                }
                
                popOver.isMonthEye = isMonth
                popOver.isBuy = isBuy
                
                
                if let currentListing = Optional(eyeBook.listings[owningCollectionCell.listingIndex]) {
                    popOver.currentListing = currentListing
                    if let currentJSON = currentListing.getVisibleStrikes(owningCollectionCell.floorIndex) {
                        popOver.strikeJSON = currentJSON
                        //print("currentJSON")
                        //print(currentJSON)
                    }
                }
                
                //popOver.strikeTextField = textField
                
                popOver.modalPresentationStyle = UIModalPresentationStyle.Popover
                self.presentViewController(popOver, animated: true, completion: nil)
                popOver.modalPresentationStyle = UIModalPresentationStyle.Popover
                
                //textField.inputView = strikeInputViewController?.view
                
                let myController:UIPopoverPresentationController = (popOver.popoverPresentationController)!
                myController.permittedArrowDirections = [UIPopoverArrowDirection.Up, UIPopoverArrowDirection.Down]
                myController.sourceView = owningCollectionCell
                myController.sourceRect = owningCollectionCell.convertRect((owningCollectionCell.bounds), toView: myController.sourceView!)
                myController.delegate = self
                //myController.passthroughViews = [owningCollectionView]
                
            }
        }
    }
    
    
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        //unowned let popOver = popoverPresentationController.presentedViewController as! EyePopoverViewController
    }
    
    // Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the
    // dismissal of the view.
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        unowned let cVC = popoverPresentationController.presentedViewController as! EyePopoverViewController
        
        let newExchanges:Exchanges = cVC.exchangeInfo
        //debug//print("\(self) - ChildTag \(childViewController.view!.tag)")
        if let eye:Eye = cVC.currentEye! {
            if newExchanges != eye.exchangeData {
                eye.exchangeData = newExchanges
            }
        }
        
        return true
    }
    
    // Called on the delegate when the user has taken action to dismiss the popover. This is not called when the popover is dimissed programatically.
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        unowned let owningCollectionView = (selectedCellTextField!.superview?.superview?.superview as! StrikeCollectionView)
        
        if selectedCellTextField!.isFirstResponder() {
            selectedCellTextField!.resignFirstResponder()
        }
        
        owningCollectionView.reloadData()
        
        selectedCellTextField!.backgroundColor = UIColor.clearColor()
        selectedCellTextField = nil
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
        //let childViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EyePopoverViewController")
        //strikeInputViewController!.view.backgroundColor = UIColor.redColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if filteredListing != nil {
            return 1
        }
        //print("NumberOfSections Hit")
        return eyeBook.listings.count
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        unowned let fListing:Listing = filteredListing ?? eyeBook.listings[section]
        let willDisplayType = fListing.willDisplay
        
        switch willDisplayType {
        case .NoStrikes:
            return 1
        default:
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(45.0)
        } else if indexPath.row == 1 {
            let listing:Listing = eyeBook.listings[indexPath.section]
            if listing.willDisplay == Listing.DisplayType.FilteredStrikes {
                //print("HEIGHT FOR ROW   \(listing.visibleStrikes.count)")
             return CGFloat(45*listing.visibleStrikes.count)
            } else {
            return (tableView.frame.height - 45.0)
            }
        } else {
            return CGFloat(30.0)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        unowned let fListing:Listing = filteredListing ?? eyeBook.listings[indexPath.section]
        
        let isFiltered:Bool = {
            return (currentFilter == .listing)
        }()
        
        
        if indexPath.row == 0 {
            let listingCell = (tableView.dequeueReusableCellWithIdentifier("ListingTableCell", forIndexPath: indexPath) as! ListingTableCell)
            if isFiltered {
                for (indx,listing) in eyeBook.listings.enumerate() {
                    if listing.listingSymbol == fListing.listingSymbol {
                        listingCell.monthCollection.tag = indx
                        break
                    }
                }
            } else {
                listingCell.monthCollection.tag = indexPath.section
            }
            
            if fListing.listingMaturities.count == 0 {
                //print("Making Maturities - \(fListing.listingSymbol)")
                let maturityString:String = getMaturities(clientSuccess, errmsg: clientErrmsg, client: client, listingID: fListing.listingId)!
                let maturityJSON = JSON.parse(maturityString)
                //print("Maturities: \(maturityJSON)")
                if maturityJSON["payload"].isEmpty {
                    //print("PAYLOAD FAILED!")
                    listingCell.listingSymbol.text = fListing.listingSymbol
                    return listingCell
                    
                }
                if let maturityArray = maturityJSON["payload"]["rows"].array {
                    fListing.listingMaturities.appendContentsOf(maturityArray)
                } else {
                    //print("ERROR: TableView:  Maturities Not Set")
                    
                }
            } else {
                //print("SKIPPING MATURITIES")
            }
            
            
            listingCell.listingSymbol.text = fListing.listingSymbol
            listingCell.monthCollection.reloadData()
            return listingCell
        } else {
            let strikesCell = tableView.dequeueReusableCellWithIdentifier("StrikesTableCell", forIndexPath: indexPath) as! StrikesTableCell
            if isFiltered {
                for (indx,listing) in eyeBook.listings.enumerate() {
                    if listing.listingSymbol == fListing.listingSymbol {
                        strikesCell.strikeCollection.tag = indx
                        break
                    }
                }
            } else {
                strikesCell.strikeCollection.tag = indexPath.section
                
            }
            //print("StrikesCollection Tag: \(strikesCell.strikeCollection.tag)")
            strikesCell.strikeCollection.reloadData()
            return strikesCell
        }
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        var returnValue = 1
        if collectionView.isKindOfClass(ListingCollectionView) {
            returnValue = FilterListingsCollectionDelegate.numberOfSectionsInCollectionView(collectionView)
        } else
            if collectionView.isKindOfClass(MonthCollectionView) {
                returnValue = MonthCollectionDelegate.numberOfSectionsInCollectionView(collectionView)
            } else
                if collectionView.isKindOfClass(StrikeCollectionView) {
                    if clientSuccess {
                        returnValue = StrikeCollectionDelegate.numberOfSectionsInCollectionView(collectionView)
                    } else {
                        returnValue = XONStrikeCollectionDelegate.numberOfSectionsInCollectionView(collectionView)
                    }
        }
        return returnValue
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //print("hitheader")
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionHeadersPinToVisibleBounds = true
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "StrikesHeader", forIndexPath: indexPath)
        let stackView = header.viewWithTag(1) as! UIStackView
        if stackView.arrangedSubviews.count == 0 {
            for i in 0...17 {
                let newLabel = UILabel()
                newLabel.text = xonListingArray[i]
                Layout.setLayout(newLabel, label: newLabel, type: StrikeType.title)
                stackView.addArrangedSubview(newLabel)
            }
        }
        return header
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnValue = 1
        if collectionView.isKindOfClass(ListingCollectionView) {
            //print("cell count: Listing Collection")
            returnValue = FilterListingsCollectionDelegate.collectionView(collectionView, numberOfItemsInSection: section)
        } else
            if collectionView.isKindOfClass(MonthCollectionView) {
                //print("cell count: Month Collection")
                returnValue = MonthCollectionDelegate.collectionView(collectionView, numberOfItemsInSection: section)
            } else
                if collectionView.isKindOfClass(StrikeCollectionView) {
                    //print("cell count: Strike Collection")
                    if clientSuccess {
                        returnValue = StrikeCollectionDelegate.collectionView(collectionView, numberOfItemsInSection: section)
                    } else {
                        returnValue = StrikeCollectionDelegate.collectionView(collectionView, numberOfItemsInSection: section)
                    }
                } else {
                    //print("ERROR : EyeBookViewController:numberOfItemsInSection: KindOfClassError")
        }
        return returnValue
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        weak var newCollectionViewCell:UICollectionViewCell?
        if collectionView.isKindOfClass(ListingCollectionView) {
            newCollectionViewCell = FilterListingsCollectionDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else
            if collectionView.isKindOfClass(MonthCollectionView) {
                newCollectionViewCell = MonthCollectionDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            } else if collectionView.isKindOfClass(StrikeCollectionView) {
                if clientSuccess {
                    newCollectionViewCell = StrikeCollectionDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
                } else {
                    newCollectionViewCell = StrikeCollectionDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
                }
            } else {
                //print("ERROR : EyeBookViewController:numberOfItemsInSection: KindOfClassError")
        }
        return newCollectionViewCell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.isKindOfClass(MonthCollectionView) {
            MonthCollectionDelegate.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        } else if collectionView.isKindOfClass(StrikeCollectionView) {
            if clientSuccess {
                StrikeCollectionDelegate.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            } else {
                //print("selectedCell")
                //strikeDelegate.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            }
        }
    }
}
