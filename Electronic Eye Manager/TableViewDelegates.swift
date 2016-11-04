//
//  File.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/3/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit



class EyeBookTableViewDelegate: NSObject, UITableViewDelegate {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eyeBook.listings.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            print("cellCreate: Listing")
            let listingAtIndexPath = eyeBook.listings[indexPath.section]
            let listingCell = tableView.dequeueReusableCellWithIdentifier("ListingTableCell", forIndexPath: indexPath) as! ListingTableCell
            
            listingCell.monthCollection.tag = indexPath.row
            listingCell.listingSymbol.text = listingAtIndexPath.listingsymbol
            
            return listingCell
        }
        if indexPath.row == 1 {
            print("cellCreate: Strikes")
            let strikeCell = tableView.dequeueReusableCellWithIdentifier("StrikesCell", forIndexPath: indexPath) as! StrikesTableCell
            return strikeCell
        }
        
        return UITableViewCell()
       
    }
    
    //func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}

}