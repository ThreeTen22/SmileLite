//
//  ExchangesTableCell.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/11/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class ExchangesTableCell: UITableViewCell {

    var exchangeSelected = false
    @IBOutlet weak var radioButton: UIButton!
    
    @IBOutlet weak var exchangeOrderType: UIButton!
    
    @IBAction func radioPressed(sender: UIButton) {
        exchangeSelected = !exchangeSelected
        if exchangeSelected {
            sender.setFAIcon(FAType.FADotCircleO, iconSize: 20, forState: .Normal)
        } else {
            sender.setFAIcon(FAType.FACircleO, iconSize: 20, forState: .Normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Layout.monthEyeBGColor
        radioPressed(radioButton)
        
        //setSelected(true, animated: false)
    }
}
