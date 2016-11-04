//
//  EyeTableViewCell.swift
//  Electronic Eye Manager
//
//  Created by Grant on 9/28/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit


class ListingTableCell: UITableViewCell {

    @IBOutlet var listingSymbol: UILabel!
    @IBOutlet var monthCollection: MonthCollectionView!
    
    var showStrikes = false
    var filterByMonth = ""
    
}

class StrikesTableCell: UITableViewCell {
    @IBOutlet var strikeCollection: UICollectionView!
    
}

//class EyeTableViewCell: UITableViewCell {
//
//
//    @IBOutlet var month: UILabel!
//    @IBOutlet var bcQE: UILabel!
//    @IBOutlet var bpQE: UILabel!
//    @IBOutlet var scQE: UILabel!
//    @IBOutlet var spQE: UILabel!
//    @IBOutlet var aHedgeSwitch: UISwitch!
//    @IBOutlet var eTypeLabel: UILabel!
//    @IBOutlet var notifySwitch: UISwitch!
//    @IBOutlet var deltaLabel: UILabel!
//
//
//    @IBOutlet var bcStrikesBtn: UIButton!
//    @IBOutlet var scStrikesBtn: UIButton!
//    @IBOutlet var bpStrikesBtn: UIButton!
//    @IBOutlet var spStrikesBtn: UIButton!
//
//
//
//    weak var curMonthContainer:MonthContainer? = nil
//    weak var curStrikeEye:StrikeEye? = nil
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        print("EyeTableViewCell: Awakefromnib: I have awoken")
//        // Initialization code
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
//
//class EyeTableViewCellExtended: EyeTableViewCell {
//
//    @IBOutlet var eTypeSeg: UISegmentedControl!
//
//    @IBOutlet var bcQuantityTF: UITextField!
//    @IBOutlet var bcEdgeTF: UITextField!
//    @IBOutlet var bpQuantityTF: UITextField!
//    @IBOutlet var bpEdgeTF: UITextField!
//    @IBOutlet var scQuantityTF: UITextField!
//    @IBOutlet var scEdgeTF: UITextField!
//    @IBOutlet var spQuantityTF: UITextField!
//    @IBOutlet var spEdgeTF: UITextField!
//    @IBOutlet var deltaTF: UITextField!
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        print("EyeTableViewCellExtended: Awakefromnib: I have awoken")
//        eTypeSeg.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2.0));
//        for view in eTypeSeg.subviews {
//            for subview in view.subviews {
//                if subview.isKindOfClass(UILabel) {
//                    subview.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI / 2.0))
//                }
//            }
//        }
//
//
//    }
//
//}

