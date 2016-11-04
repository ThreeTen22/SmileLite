//
//  CollectionDelegates.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/3/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

public struct ListingCollectionDelegate {
   public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
   public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Inside of NumberOfItemsInSection")
//        if collectionView.isKindOfClass(ListingCollectionView) {
//            return eyeBook.listings.count
//        }
        return 1
    }
    
   public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let listingSymbol = eyeBook.listings[index].listingsymbol
        
        let listingCell = collectionView.dequeueReusableCellWithReuseIdentifier("ListingCell", forIndexPath: indexPath)
        
        (listingCell.viewWithTag(1) as! UIButton).setTitle(listingSymbol, forState: .Normal)
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
        return eyeBook.listings[collectionView.tag].registeredMonthContainers.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let monthCell = collectionView.dequeueReusableCellWithReuseIdentifier("MonthCell", forIndexPath: indexPath)
        
        let monthContainer = eyeBook.listings[collectionView.tag].registeredMonthContainers[indexPath.row]
        (monthCell.viewWithTag(1) as! UIButton).setTitle(monthContainer.expDateString, forState: .Normal)
        return monthCell
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
                
            case 6, 14, 17:
                strikeCell.backgroundColor = UIColor.greenColor()
                print(xonListingArray[indx] + "  \(indx)")
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
        //return oldCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }
    
}

