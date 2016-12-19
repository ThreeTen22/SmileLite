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
    }
}

class ExchangeTableView:UITableView {
    
    var exchanges:Exchanges = Exchanges()
    
    //@IBOutlet weak var tableHeader:TableHeaderView!
    
    var allSelected: Bool = false
    
    @IBAction func radioPressed(sender: UIButton) {
        if exchanges[isActiveExchange: sender.tag] == true {
            exchanges[isActiveExchange: sender.tag] = false
        } else {
            exchanges[isActiveExchange: sender.tag] = true
        }
        setButtonLayout(sender)
    
        //exchanges[isActive: sender.tag] = !exchanges[isActive: sender.tag]
        
    }
    func setButtonLayout(sender:UIButton) {
        Layout.setRadioButtonLayout(sender, isOn: exchanges[isActiveExchange: sender.tag])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class ExchangesTableCell: UITableViewCell {
    
    @IBOutlet weak var radioButton: RadioButton!
    
    @IBOutlet weak var exchangeName: UILabel!
    @IBOutlet weak var exchangeOrderType: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Layout.monthEyeBGColor
    }
}
