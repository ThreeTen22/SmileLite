//
//  ExchangesTableCell.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/11/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {
    
    @IBOutlet weak var selectAllButton:UIButton!
    
    override func awakeFromNib() {
        selectAllButton.setFAText(prefixText: " ", icon: FAType.FASquareO, postfixText: "  select all markets", size: 15.0, forState: .Normal)
    }
}

class ExchangeTableView:UITableView {
    var exchanges:Exchanges!
    
    @IBOutlet weak var tableHeader:TableHeaderView!
    
    var allSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(tableHeaderView)
    }
}

class ExchangesTableCell: UITableViewCell {

    var exchangeSelected = false
    
    @IBOutlet weak var radioButton: UIButton!
    
    @IBOutlet weak var exchangeOrderType: UIButton!
    
    @IBAction func radioPressed(sender: UIButton) {
        exchangeSelected = !exchangeSelected
        if exchangeSelected {
            sender.setFAIcon(FAType.FADotCircleO, iconSize: 20, forState: .Normal)
            sender.setFATitleColor(UIColor.blueColor())
        } else {
            sender.setFAIcon(FAType.FACircleO, iconSize: 20, forState: .Normal)
            sender.setFATitleColor(UIColor.lightGrayColor())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Layout.monthEyeBGColor
        radioPressed(radioButton)
        
        //setSelected(true, animated: false)
    }
}
