//
//  MonthEyeActivateCell.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/20/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class MonthEyeActivateCell: UITableViewCell {
    
    
    var isBtnActive = [false, false, false, false]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 1...4 {
            if let btn = self.viewWithTag(i) as! UIButton! {
                btn.layer.borderWidth = 1.0
                //btn.setTitle("", forState: .Normal)
            }
            
        }
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
