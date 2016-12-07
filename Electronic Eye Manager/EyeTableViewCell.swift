//
//  EyeTableViewCell.swift
//  Electronic Eye Manager
//
//  Created by Grant on 9/28/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit


class ListingTableCell: UITableViewCell {

    @IBOutlet weak var listingSymbol: UILabel!
    @IBOutlet weak var monthCollection: MonthCollectionView!
    
}



class StrikesTableCell: UITableViewCell {
    @IBOutlet weak var strikeCollection: UICollectionView!
    deinit {
        //print("StrikesTableCell: Deinit")
    }
    
    
}
