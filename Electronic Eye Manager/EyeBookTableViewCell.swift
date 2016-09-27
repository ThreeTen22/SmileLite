//
//  EyeListTableViewCell.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/15/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EyeBookTableViewCell: UITableViewCell {

    var curMonthContainer:MonthContainer? = nil
    var curStrikeEye:StrikeEye? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        for i in 1...4 {
//            if let btn = self.viewWithTag(i) as! UIButton! {
//                btn.layer.borderWidth = 1.0
//                btn.setTitle("", forState: .Normal)
//            }
//            
//        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func changeActiveButton(index:Int,_ btnToModify:UIButton) {
        if let curME = curMonthContainer {
            if curME.isActive {
                btnToModify.backgroundColor = UIColor.whiteColor()
                curME.isActive = false
                btnToModify.setTitleColor(UIColor.blueColor(), forState: .Normal)
            }
            else {
                btnToModify.backgroundColor = UIColor.blueColor()
                btnToModify.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                curME.isActive = true
            }
            return
        }
        
        if let curSE = curStrikeEye {
            if curSE.isActive {
                btnToModify.backgroundColor = UIColor.whiteColor()
                curSE.isActive = false
                btnToModify.setTitleColor(UIColor.blueColor(), forState: .Normal)
            }
            else {
                btnToModify.backgroundColor = UIColor.blueColor()
                btnToModify.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                curSE.isActive = true
            }
            return
        }
    }

}