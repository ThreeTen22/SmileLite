//
//  EyeListViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/12/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EyeBookViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate{
    enum FilterType {
        case ShowAll
        case ShowListing
    }
    
    var currentFilter = FilterType.ShowAll
    var selectedSymbol = ""
    var eyeContainerArray:Array = [AnyObject]()
    
    
    weak var filteredListing:Listing?
    
    var sectionRowCounts:Array = [Int]()
    
    var selectedIndx:(Int, Int) = (-1, -1)
    
    let listDelegate = FilterListingsCollectionDelegate()
    let monthDelegate = MonthCollectionDelegate()
    let strikeDelegate = StrikeCollectionDelegate()
    
    @IBOutlet var eyeBookTableView: UITableView!
    
    @IBAction func showStrikes(sender: UIButton) {

        
    }
    
    
    
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
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = false
        eyeContainerArray.removeAll()
        sectionRowCounts.removeAll()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
        if let fListing = filteredListing {
           let willDisplayType = fListing.willDisplay
            switch willDisplayType {
            case .NoStrikes:
                return 1
            default:
                return 2
            }
        } else {
            for listing in eyeBook.listings {
                let willDisplayType = listing.willDisplay
                switch willDisplayType {
                case .NoStrikes:
                    return 1
                default:
                    return 2
                }
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(45.0)
        } else if indexPath.row == 1 && indexPath.section == 0 {
            return CGFloat(430.0)
        } else {
            return CGFloat(30.0)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let listingCell = tableView.dequeueReusableCellWithIdentifier("ListingTableCell", forIndexPath: indexPath) as! ListingTableCell
        
        if let fListing = filteredListing {
            for (indx,listing) in eyeBook.listings.enumerate() {
                if listing.listingsymbol == fListing.listingsymbol {
                    listingCell.monthCollection.tag = indx
                    break
                }
            }
            listingCell.listingSymbol.text = fListing.listingsymbol
        } else {
            print("cellCreate: Listing")
            let listingAtIndexPath = eyeBook.listings[indexPath.section]
            
            listingCell.monthCollection.tag = indexPath.section
            listingCell.listingSymbol.text = listingAtIndexPath.listingsymbol
        }
        listingCell.monthCollection.reloadData()
        return listingCell
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        var returnValue = 1
        if collectionView.isKindOfClass(ListingCollectionView) {
            returnValue = listDelegate.numberOfSectionsInCollectionView(collectionView)
        }
        if collectionView.isKindOfClass(MonthCollectionView) {
            returnValue = monthDelegate.numberOfSectionsInCollectionView(collectionView)
        }
        if collectionView.isKindOfClass(StrikeCollectionView) {
            returnValue = strikeDelegate.numberOfSectionsInCollectionView(collectionView)
        }
        return returnValue
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
            returnValue = strikeDelegate.collectionView(collectionView, numberOfItemsInSection: section)
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
            newCollectionViewCell = strikeDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else {
        print("ERROR : EyeBookViewController:numberOfItemsInSection: KindOfClassError")
        }
        return newCollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.isKindOfClass(StrikeCollectionView) {
            strikeDelegate.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
        }
        
    }
    
    
    
}