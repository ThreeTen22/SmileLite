//
//  ExchangesTableCell.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/11/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {
    
    var exchangeInfo:Exchanges!
    
    @IBOutlet weak var selectAllButton:UIButton!
    
    @IBAction func radioPressed(sender: UIButton) {
        print("I have been pressed")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //selectAllButton.setFAText(prefixText: " ", icon: FAType.FASquareO, postfixText: "  select all markets", size: 12.0, forState: .Normal, iconSize: 20.0)
        //selectAllButton.addTarget(nil, action: #selector(TableHeaderView.radioPressed(_:)), forControlEvents: .TouchUpInside)
        //selectAllButton.set
    }
}

class ExchangeTableView:UITableView {
    var exchanges:Exchanges!
    
    //@IBOutlet weak var tableHeader:TableHeaderView!
    
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
