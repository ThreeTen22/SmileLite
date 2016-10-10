//
//  EyeTableViewCell.swift
//  Electronic Eye Manager
//
//  Created by Grant on 9/28/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EyeTableViewCell: UITableViewCell {
   
    
    @IBOutlet var month: UILabel!
    @IBOutlet var scspQ: UITextField!
    @IBOutlet var bcbpQ: UITextField!
    @IBOutlet var aHedgeLabel: UILabel!
    @IBOutlet var eTypeLabel: UILabel!
    @IBOutlet var notifySwitch: UISwitch!
    @IBOutlet var deltaLabel: UILabel!
    
    weak var curMonthContainer:MonthContainer? = nil
    weak var curStrikeEye:StrikeEye? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class EyeTableViewCellExtended: EyeTableViewCell {
    
    @IBOutlet var modifyQuantityCollectionView: UICollectionView!

    @IBOutlet var eTypeSeg: UISegmentedControl!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eTypeSeg.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2.0));
        for view in eTypeSeg.subviews {
            for subview in view.subviews {
                if subview.isKindOfClass(UILabel) {
                    subview.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI / 2.0))
                }
            }
        }
        
        
    }
    
    
    
}
