//
//  StrikeCollectionViewCell.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/28/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class StrikeCollectionViewCell: UICollectionViewCell {
    var listingIndex:Int!
    var floorIndex:Int!
    var cellType:StrikeType = StrikeType.null
    deinit {
        //print("deinit: strikeCollectionViewCell")
        listingIndex = nil
        floorIndex = nil
    }
}
