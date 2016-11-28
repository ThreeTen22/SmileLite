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
}

class MonthCollectionView: UICollectionView {
    var listingSymbol = ""
}

class StrikeCollectionView: UICollectionView {
    weak var currentIndexPath:NSIndexPath?
}