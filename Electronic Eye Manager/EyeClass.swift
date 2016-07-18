//
//  EyeClass.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/17/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import Foundation

class Eye:NSObject {
     //             SC      BP     BC     SP
    var isActive = [false, false, false, false]
    var listing = ""
    var expDate = ""
    
}

class MonthEye: Eye {
    var bcspER = [["Buy Call | Sell Put","$ Edge", "0.00", "0", "0.01"],["0","0","0","0","1"]]
    var scbpER = [["Sell Call | Buy Put","$ Edge", "0.00", "0", "0.01"],["0","0","0","0","1"]]
}

class StrikeEye: Eye {
    var strikePrice = ""
    var isUsingEdgeRule = false
    var priceOverride = 0.0
    var quantityOverride = 0
}