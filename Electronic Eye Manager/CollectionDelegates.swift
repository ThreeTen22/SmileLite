//
//  CollectionDelegates.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/3/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

public struct FilterListingsCollectionDelegate {
   public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
   public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eyeBook.listings.count
    }
    
   public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let listingSymbol = eyeBook.listings[index].listingsymbol
        
        let listingCell = collectionView.dequeueReusableCellWithReuseIdentifier("ListingCell", forIndexPath: indexPath)
        let listingButton = (listingCell.viewWithTag(1) as! ListingFilterButton)
        listingButton.setTitle(listingSymbol, forState: .Normal)
        listingButton.listingSymbol = listingSymbol
    
        return listingCell
        //return oldCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }
    
    
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //oldCollectionViewDidSelectRow(collectionView, didSelectItemAtIndexPath: indexPath)
        
    }
}



public struct MonthCollectionDelegate {
   public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("DEBUG: MonthCollectionDelegate.collectionViewNumberOfItemsInSection")
        print("\(eyeBook.listings[collectionView.tag].registeredMonthContainers.count)")
        return eyeBook.listings[collectionView.tag].registeredMonthContainers.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let monthCell = collectionView.dequeueReusableCellWithReuseIdentifier("MonthCell", forIndexPath: indexPath)
        
        let monthContainer = eyeBook.listings[collectionView.tag].registeredMonthContainers[indexPath.row]
        (monthCell.viewWithTag(1) as! UILabel).text = monthContainer.expDateString
        return monthCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("MonthCollectionDelegate: didSelectItemAtIndexPath: \(indexPath.row)")
        
    }
    
}


public struct StrikeCollectionDelegate {
   public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return xonListingArray.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let indx = indexPath.row
        let modIndx = indexPath.row%18
        let strikeCell = collectionView.dequeueReusableCellWithReuseIdentifier("StrikeCell", forIndexPath: indexPath)
        let strikeLabel = (strikeCell.viewWithTag(1) as! UILabel)
        strikeLabel.text = xonListingArray[indx]
        if indx < 18 {
            strikeCell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 128.0, alpha: 1.0)
            strikeLabel.textColor = UIColor.whiteColor()
        } else {
            switch modIndx {
            case 0:
                strikeCell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 128.0, alpha: 1.0)
                strikeLabel.textColor = UIColor.whiteColor()
            case 1:
                strikeCell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 128.0, alpha: 1.0)
                strikeLabel.textColor = UIColor.whiteColor()
            case 4, 12:
                strikeCell.backgroundColor = UIColor.lightGrayColor()
                strikeLabel.textColor = UIColor.blackColor()
            case 6, 14, 17:
                strikeCell.backgroundColor = UIColor.greenColor()
                if Int(xonListingArray[indx])! < 0 {
                    strikeLabel.textColor = UIColor.redColor()
                } else if Int(xonListingArray[indx])! > 0 {
                    strikeLabel.textColor = UIColor.blueColor()
                } else {
                    strikeLabel.textColor = UIColor.blackColor()
                }
            default:
                strikeCell.backgroundColor = UIColor.whiteColor()
                strikeLabel.textColor = UIColor.blackColor()
            }
        }
        
        return strikeCell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("StrikeCollectionDelegate: didSelectItemAtIndexPath: \(indexPath.row)")
        
    }
    
}

