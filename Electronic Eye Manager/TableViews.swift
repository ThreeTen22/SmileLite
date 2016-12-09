//
//  TableViews.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/7/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EyebookTableView: UITableView {
    
    override func awakeFromNib() {
        backgroundColor = Layout.eyeBookListingTableCellBGColor
    }
    deinit {
        //print("deinit: EyebookTableView")
    }
}
