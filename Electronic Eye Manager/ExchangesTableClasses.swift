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

    var exchange:ExInfo!
    
    @IBOutlet weak var radioButton: UIButton!
    
    @IBOutlet weak var exchangeOrderType: UIButton!
    
    @IBAction func radioPressed(sender: UIButton) {
      exchange.orderValidity.OneOrZero()
      setRadioState(sender)
    }
    
    func setRadioState(sender:UIButton) {
        if exchange.orderValidity == 1 {
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
        //setRadioState(radioButton)
        radioButton.addTarget(self, action: #selector(ExchangesTableCell.radioPressed(_:)), forControlEvents: .TouchUpInside)
        
        //setSelected(true, animated: false)
    }
}
