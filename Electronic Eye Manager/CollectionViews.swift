//
//  StockFilterView.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/13/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class ListingCollectionView: UICollectionView {
    var listingSymbol = ""
    
    override func awakeFromNib() {
        backgroundColor = Layout.eyeBookListingCollectionBGColor
    }
    deinit {
        //print("deinit: lisitngCollectionView: \(listingSymbol)")
    }
}

class MonthCollectionView: UICollectionView {
    var listingSymbol = ""
    override func awakeFromNib() {
        backgroundColor = Layout.eyeBookListingTableCellBGColor
    }
    deinit {
        //print("deinit: monthCollectionView: \(listingSymbol) ")
    }
}

class StrikeCollectionView: UICollectionView {
    weak var currentIndexPath:NSIndexPath?
    
    override func awakeFromNib() {
        backgroundColor = Layout.eyeBookListingTableCellBGColor
        //collectionViewLayout.
    }
    
    deinit {
        currentIndexPath = nil
        //print("deinit: strikeCollectionView: \(currentIndexPath)")
    }
}
