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
    
    //var sectionRowCounts:Array = [Int]()
    
    var listDelegate = FilterListingsCollectionDelegate()
    var monthDelegate = MonthCollectionDelegate()
    var strikeDelegate = StrikeCollectionDelegate()
    var xonStrikeDelegate = XONStrikeCollectionDelegate()
    
    var deleteTable:Bool = false
    
    var isTableAnimatedProgramatically = false
    //var newView = ((UINib.init(nibName: "InputView", bundle: nil)).instantiateWithOwner(nil, options: nil)[0] as! UIView)
    
    weak var eyePopoverViewController:EyePopoverViewController?
    //weak var selectedCell:StrikeCollectionViewCell?
    weak var selectedCellTextField:StrikeCellTextField?
    
    @IBOutlet weak var eyeBookTableView: UITableView!
    
    @IBAction func testAction(sender:AnyObject) {
        //eyeBookTableView.removeFromSuperview()
        //filteredListing = nil
        //print("TestButton")
    }
    
    
    @IBAction func pressedListingInFilterCollection(sender: ListingFilterButton) {
        
        let listingTest = eyeBook.getListingBySymbol(sender.listingSymbol)
        var modifyFilteredListing = false
        
        if let fListing = filteredListing {
            if fListing.listingsymbol == listingTest?.listingsymbol {
                fListing.isSelectedInEyebook = false
                filteredListing = nil
                currentFilter = .all
            }
            else {
                fListing.isSelectedInEyebook = false
                modifyFilteredListing = true
            }
        } else {
            modifyFilteredListing = true
        }
        
        if modifyFilteredListing {
            listingTest?.isSelectedInEyebook = true
            filteredListing = listingTest
            currentFilter = .listing
        }
        
        
        //print("DEBUG:  filteredListing: \(filteredListing) + \(filteredListing?.listingsymbol) ")
        //print("")
        //print("DEBUG:  Listing.isSelectedInEyebook check : ")
        for listing in eyeBook.listings {
            print("\(listing.listingsymbol)  :  \(listing.isSelectedInEyebook)")
        }
        //print("DEBUG:  reloadData: ")
        
        eyeBookTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthDelegate.initalize()
        deleteTable = false
        
        parseXonString()
        //print("Strike Eyes:")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        deleteTable = false
        
        let jsonString = getEyes(clientSuccess, errmsg: clientErrmsg, client: client)
        if jsonString == eyebookRaw {
            clientSuccess = false
        }
        eyebookJSON = JSON.parse(jsonString)
        
        eyeBook = EyeBook(fromEyesJSON: eyebookJSON)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //print("/n EYEBOOK VIEW CONROLLER:  I Disappearing /n")
        deleteTable = true
        eyeBookTableView.reloadData()
        filteredListing = nil
        
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
        
        print(owningCollectionCell.cellType)
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
        //print(#function)
        
        //let owningCollectionView = (textField.superview?.superview?.superview as! StrikeCollectionView)
        //let owningIndexPath = owningCollectionView.indexPathForCell(owningCollectionCell)
        //let newIndexPath = NSIndexPath(forRow: (owningIndexPath?.row)!-18, inSection: (owningIndexPath?.section)!)
        
        //owningCollectionView.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
        
        if isTableAnimatedProgramatically {
            isTableAnimatedProgramatically = false
            
            let textField:StrikeCellTextField! = selectedCellTextField
            let owningCollectionCell = (textField.superview?.superview) as! StrikeCollectionViewCell
            eyePopoverViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("EyePopoverViewController") as? EyePopoverViewController)
            
            if let popOver = eyePopoverViewController {
                var isMonth = false
                var isBuy = false
                
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        //textField.inputView = nil
        //strikeInputViewController = nil
    }
    
    
    
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        //unowned let popOver = popoverPresentationController.presentedViewController as! EyePopoverViewController
    }
    
    // Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the
    // dismissal of the view.
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        let childViewController = popoverPresentationController.presentedViewController
        debugPrint("\(self) - ChildTag \(childViewController.view!.tag)")
        
        //selectedCellTextField!.resignFirstResponder()
        selectedCellTextField!.backgroundColor = UIColor.clearColor()
        selectedCellTextField = nil
        
        return true
    }
    
    // Called on the delegate when the user has taken action to dismiss the popover. This is not called when the popover is dimissed programatically.
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        //popoverPresentationController.presentedViewController.removeFromParentViewController()
        popoverPresentationController.delegate = nil
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
        if deleteTable {
            return 0
        }
        if filteredListing != nil {
            return 1
        }
        //print("NumberOfSections Hit")
        return eyeBook.listings.count
    }
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        unowned var fListing:Listing {
            if filteredListing != nil {
                return filteredListing!
            } else {
                return eyeBook.listings[section]
            }
        }
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
            return CGFloat(430.0)
        } else {
            return CGFloat(30.0)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        unowned var fListing:Listing {
            if filteredListing != nil {
                return filteredListing!
            } else {
                return eyeBook.listings[indexPath.section]
            }
        }
        
        var isFiltered:Bool {
            return (currentFilter == .listing)
        }
        
        
        if indexPath.row == 0 {
            let listingCell = (tableView.dequeueReusableCellWithIdentifier("ListingTableCell", forIndexPath: indexPath) as! ListingTableCell)
            if isFiltered {
                for (indx,listing) in eyeBook.listings.enumerate() {
                    if listing.listingsymbol == fListing.listingsymbol {
                        listingCell.monthCollection.tag = indx
                        break
                    }
                }
            } else {
                listingCell.monthCollection.tag = indexPath.section
            }
            
            if fListing.listingMaturities.count == 0 {
                //print("Making Maturities")
                let maturityJSON = JSON.parse(getMaturities(clientSuccess, errmsg: clientErrmsg, client: client, listingID: fListing.listingId)!)
                //print("Maturities: \(maturityJSON)")
                if let maturityArray = maturityJSON["payload"]["rows"].array {
                    fListing.listingMaturities.appendContentsOf(maturityArray)
                } else {
                    //print("ERROR: TableView:  Maturities Not Set")
                    
                }
            } else {
                //print("SKIPPING MATURITIES")
            }
            
            
            listingCell.listingSymbol.text = fListing.listingsymbol
            listingCell.monthCollection.reloadData()
            return listingCell
        } else {
            let strikesCell = tableView.dequeueReusableCellWithIdentifier("StrikesTableCell", forIndexPath: indexPath) as! StrikesTableCell
            if isFiltered {
                for (indx,listing) in eyeBook.listings.enumerate() {
                    if listing.listingsymbol == fListing.listingsymbol {
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
            returnValue = listDelegate.numberOfSectionsInCollectionView(collectionView)
        } else
            if collectionView.isKindOfClass(MonthCollectionView) {
                returnValue = monthDelegate.numberOfSectionsInCollectionView(collectionView)
            } else
                if collectionView.isKindOfClass(StrikeCollectionView) {
                    if clientSuccess {
                        returnValue = strikeDelegate.numberOfSectionsInCollectionView(collectionView)
                    } else {
                        returnValue = xonStrikeDelegate.numberOfSectionsInCollectionView(collectionView)
                    }
        }
        return returnValue
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //print("hitheader")
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionHeadersPinToVisibleBounds = true
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "StrikesHeader", forIndexPath: indexPath)
        let stackView = header.viewWithTag(1) as! UIStackView
        if stackView.arrangedSubviews.count != 0 {
            for i in stackView.arrangedSubviews {
                stackView.removeArrangedSubview(i)
            }
        }
        for i in 0...17 {
            let newLabel = UILabel()
            newLabel.text = xonListingArray[i]
            CellLayout.setLayout(newLabel, label: newLabel, type: StrikeType.title)
            stackView.addArrangedSubview(newLabel)
        }
        
        return header
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnValue = 1
        if collectionView.isKindOfClass(ListingCollectionView) {
            //print("cell count: Listing Collection")
            returnValue = listDelegate.collectionView(collectionView, numberOfItemsInSection: section)
        } else
            if collectionView.isKindOfClass(MonthCollectionView) {
                //print("cell count: Month Collection")
                returnValue = monthDelegate.collectionView(collectionView, numberOfItemsInSection: section)
            } else
                if collectionView.isKindOfClass(StrikeCollectionView) {
                    //print("cell count: Strike Collection")
                    if clientSuccess {
                        returnValue = strikeDelegate.collectionView(collectionView, numberOfItemsInSection: section)
                    } else {
                        returnValue = xonStrikeDelegate.collectionView(collectionView, numberOfItemsInSection: section)
                    }
                } else {
                    //print("ERROR : EyeBookViewController:numberOfItemsInSection: KindOfClassError")
        }
        return returnValue
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        weak var newCollectionViewCell:UICollectionViewCell?
        if collectionView.isKindOfClass(ListingCollectionView) {
            newCollectionViewCell = listDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else
            if collectionView.isKindOfClass(MonthCollectionView) {
                newCollectionViewCell = monthDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            } else if collectionView.isKindOfClass(StrikeCollectionView) {
                if clientSuccess {
                    newCollectionViewCell = strikeDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
                } else {
                    newCollectionViewCell = xonStrikeDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
                }
            } else {
                //print("ERROR : EyeBookViewController:numberOfItemsInSection: KindOfClassError")
        }
        return newCollectionViewCell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.isKindOfClass(MonthCollectionView) {
            monthDelegate.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        } else if collectionView.isKindOfClass(StrikeCollectionView) {
            if clientSuccess {
                strikeDelegate.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            } else {
                //print("selectedCell")
                //strikeDelegate.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            }
        }
    }
}