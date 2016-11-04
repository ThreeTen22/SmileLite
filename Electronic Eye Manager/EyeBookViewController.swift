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
    
    var filteredListing:Listing = Listing()
    var currentFilter = FilterType.ShowAll
    var selectedSymbol = ""
    var eyeContainerArray:Array = [AnyObject]()
    
    
    weak var focusedListing:Listing?
    
    var sectionRowCounts:Array = [Int]()
    
    var selectedIndx:(Int, Int) = (-1, -1)
    
    //@IBOutlet var tableViewDelegate: EyeBookTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        eyeContainerArray.removeAll()
        sectionRowCounts.removeAll()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //(self.view as! UITableView).beginUpdates()
        //(self.view as! UITableView).endUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eyeBook.listings.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(45.0)
        } else  {
            
            return CGFloat(500.0)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            print("cellCreate: Listing")
            let listingAtIndexPath = eyeBook.listings[indexPath.section]
            let listingCell = tableView.dequeueReusableCellWithIdentifier("ListingTableCell", forIndexPath: indexPath) as! ListingTableCell
            
            listingCell.monthCollection.tag = indexPath.section
            listingCell.listingSymbol.text = listingAtIndexPath.listingsymbol
            
            return listingCell
        }
        if indexPath.row == 1 && indexPath.section == 0 {
            print("cellCreate: Strikes")
            let strikeCell = tableView.dequeueReusableCellWithIdentifier("StrikesCell", forIndexPath: indexPath) as! StrikesTableCell
            return strikeCell
        }
        
        return UITableViewCell()
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        if collectionView.isKindOfClass(ListingCollectionView) {
            let listDelegate = ListingCollectionDelegate()
            return listDelegate.numberOfSectionsInCollectionView(collectionView)
        }
        if collectionView.isKindOfClass(MonthCollectionView) {
            let monthDelegate = MonthCollectionDelegate()
            return monthDelegate.numberOfSectionsInCollectionView(collectionView)
        }
        if collectionView.isKindOfClass(StrikeCollectionView) {
            let strikeDelegate = StrikeCollectionDelegate()
            return strikeDelegate.numberOfSectionsInCollectionView(collectionView)
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.isKindOfClass(ListingCollectionView) {
            let listDelegate = ListingCollectionDelegate()
            return listDelegate.collectionView(collectionView, numberOfItemsInSection: section)
        }
        if collectionView.isKindOfClass(MonthCollectionView) {
            let monthDelegate = MonthCollectionDelegate()
            return monthDelegate.collectionView(collectionView, numberOfItemsInSection: section)
        }
        if collectionView.isKindOfClass(StrikeCollectionView) {
            let strikeDelegate = StrikeCollectionDelegate()
            return strikeDelegate.collectionView(collectionView, numberOfItemsInSection: section)
        }
        print("ERROR : EyeBookViewController:numberOfItemsInSection: KindOfClassError")
        return 0
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.isKindOfClass(ListingCollectionView) {
            let listDelegate = ListingCollectionDelegate()
            return listDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        }
        if collectionView.isKindOfClass(MonthCollectionView) {
            let monthDelegate = MonthCollectionDelegate()
            return monthDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        }
        if collectionView.isKindOfClass(StrikeCollectionView) {
            let strikeDelegate = StrikeCollectionDelegate()
            return strikeDelegate.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        }
        print("ERROR : EyeBookViewController:numberOfItemsInSection: KindOfClassError")
        return UICollectionViewCell()
    }

    
    
    
    


    
}