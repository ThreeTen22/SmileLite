//
//  EyeListViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/12/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EyeBookViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {
    enum FilterType {
        case ShowAll
        case ShowListing
    }
    
    var currentFilter = FilterType.ShowAll
    var selectedSymbol = ""

    var eyeContainerArray:Array = [AnyObject]()
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var popOverSegueAnchor: UIView!
    weak var filteredListing:Listing?
    
    var sectionRowCounts:Array = [Int]()
    
    var selectedIndx:(Int, Int) = (-1, -1)
    
    var listDelegate = FilterListingsCollectionDelegate()
    var monthDelegate = MonthCollectionDelegate()
    var strikeDelegate = StrikeCollectionDelegate()
    
    var xonStrikeDelegate = XONStrikeCollectionDelegate()
    
    
    var childViewController:UIViewController?
    
    @IBOutlet var eyeBookTableView: UITableView!
    
    
    
    @IBAction func pressedListingInFilterCollection(sender: ListingFilterButton) {
        //Clear Other Listings:
        let listingTest = eyeBook.getListingBySymbol(sender.listingSymbol)
        var modifyFilteredListing = false
        if let fListing = filteredListing {
            if fListing.listingsymbol == listingTest?.listingsymbol {
                fListing.isSelectedInEyebook = false
                filteredListing = nil
                currentFilter = .ShowAll
            }
            else {
                fListing.isSelectedInEyebook = false
                modifyFilteredListing = true
            }
        } else {
            modifyFilteredListing = true
        }
        //If not clearing, or selecting a different listing to filter
        if modifyFilteredListing {
            listingTest?.isSelectedInEyebook = true
            filteredListing = listingTest
            currentFilter = .ShowListing
        }
        print("DEBUG:  filteredListing: \(filteredListing) + \(filteredListing?.listingsymbol) ")
        print("")
        print("DEBUG:  Listing.isSelectedInEyebook check : ")
        for listing in eyeBook.listings {
            print("\(listing.listingsymbol)  :  \(listing.isSelectedInEyebook)")
        }
        print("DEBUG:  reloadData: ")
        
        eyeBookTableView.reloadData()
    }
    
    override func viewDidLoad() {
        monthDelegate.initalize()
        (clientSuccess, clientErrmsg) = client.connect(timeout: 3)
        
        eyeContainerArray.removeAll()
        sectionRowCounts.removeAll()
        
        //self.popoverPresentationController
        super.viewDidLoad()
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        childViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ModEyeViewController")
        //self.addChildViewController(childViewController!)
        //self.view.addSubview(childViewController!.view)
        
        
        //let containerViewController:UIViewController = containerView
        //presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("ModEyeViewController"))!, animated: true, completion: .None)
        
        childViewController!.modalPresentationStyle = UIModalPresentationStyle.Popover
        //childViewController!.transitioningDelegate = self
        childViewController!.view.backgroundColor = UIColor.redColor()
        
        self.presentViewController(childViewController!, animated: true, completion: nil)
        
        let myController:UIPopoverPresentationController = (childViewController?.popoverPresentationController)!
        let senderView:StrikeCollectionView = (sender! as! StrikeCollectionView)
        let senderCell = senderView.cellForItemAtIndexPath(senderView.currentIndexPath!)!
        myController.permittedArrowDirections = [UIPopoverArrowDirection.Up, UIPopoverArrowDirection.Down]
        myController.sourceView = self.view
        myController.sourceRect = senderCell.convertRect((senderCell.bounds), toView: myController.sourceView!)
        
        myController.delegate = self
        return false
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare for seg")
       if segue.identifier == "embedEye"
       {
        
        }
        //popOverSegueAnchor.x
        //(sender as UICollectionViewCell).rect
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if filteredListing != nil {
            return 1
        }
        print("NumberOfSections Hit")
        return eyeBook.listings.count
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var fListing:Listing {
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
        
        var fListing:Listing {
            if filteredListing != nil {
                return filteredListing!
            } else {
                return eyeBook.listings[indexPath.section]
            }
        }
        
        var isFiltered:Bool {
            return (self.currentFilter == .ShowListing)
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
                print("Making Maturities")
                let maturityJSON = JSON.parse(getMaturities(clientSuccess, errmsg: clientErrmsg, client: client, listingID: fListing.listingId)!)
                if let maturityArray = maturityJSON["payload"]["rows"].array {
                    fListing.listingMaturities.appendContentsOf(maturityArray)
                } else {
                    print("ERROR: TableView:  Maturities Not Set")
                }
            } else {
                print("SKIPPING MATURITIES")
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
            print("StrikesCollection Tag: \(strikesCell.strikeCollection.tag)")
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
        //collectionView.top
        print("hitheader")
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionHeadersPinToVisibleBounds = true
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "StrikesHeader", forIndexPath: indexPath)
        let stackView = header.viewWithTag(1) as! UIStackView
        for i in 0...17 {
            let newLabel = UILabel()
            newLabel.text = xonListingArray[i]
            CellLayout.setLayout(newLabel, label: newLabel, type: CellType.Title)
            stackView.addArrangedSubview(newLabel)
        }
        
        return header
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnValue = 1
        if collectionView.isKindOfClass(ListingCollectionView) {
            print("cell count: Listing Collection")
            returnValue = listDelegate.collectionView(collectionView, numberOfItemsInSection: section)
        } else
        if collectionView.isKindOfClass(MonthCollectionView) {
            print("cell count: Month Collection")
            returnValue = monthDelegate.collectionView(collectionView, numberOfItemsInSection: section)
        } else
        if collectionView.isKindOfClass(StrikeCollectionView) {
            print("cell count: Strike Collection")
            if clientSuccess {
                returnValue = strikeDelegate.collectionView(collectionView, numberOfItemsInSection: section)
            } else {
                returnValue = xonStrikeDelegate.collectionView(collectionView, numberOfItemsInSection: section)
            }
        } else {
            print("ERROR : EyeBookViewController:numberOfItemsInSection: KindOfClassError")
        }
        return returnValue
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var newCollectionViewCell:UICollectionViewCell = UICollectionViewCell()
        if collectionView.isKindOfClass(ListingCollectionView) {
            newCollectionViewCell = listDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else
        if collectionView.isKindOfClass(MonthCollectionView) {
            newCollectionViewCell = monthDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else
        if collectionView.isKindOfClass(StrikeCollectionView) {
            if clientSuccess {
                newCollectionViewCell = strikeDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
             } else {
                newCollectionViewCell = xonStrikeDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
             }
        } else {
        print("ERROR : EyeBookViewController:numberOfItemsInSection: KindOfClassError")
        }
        return newCollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.isKindOfClass(MonthCollectionView) {
            monthDelegate.collectionView(collectionView, didSelectItemAtIndexPath: indexPath, viewController: self as EyeBookViewController)
        } else
        if collectionView.isKindOfClass(StrikeCollectionView) {
            if clientSuccess {
                strikeDelegate.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            } else {
                xonStrikeDelegate.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            }
        }
    }
    
}