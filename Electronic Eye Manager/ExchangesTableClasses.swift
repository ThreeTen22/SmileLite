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
    //var eyeExchanges:Exchanges = Exchanges()

    
    //@IBOutlet weak var tableHeader:TableHeaderView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class ExchangesTableCell: UITableViewCell {
    
    @IBOutlet weak var radioButton: RadioButton!
    
    @IBOutlet weak var toggleRadioButton: RadioButton!
    @IBOutlet weak var notifyOnlyradioButton:RadioButton!
    
    @IBOutlet weak var exchangeName: UILabel!
    @IBOutlet weak var exchangeOrderType: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Layout.monthEyeBGColor
    }
}
