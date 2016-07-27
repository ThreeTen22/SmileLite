//
//  EyeClass.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/17/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class Listing {
    var listingsymbol = ""
    var registeredMonthEyes = [MonthEye]()
    var registeredStrikeEyes = [StrikeEye]()
    
    init() {
        
    }
    init(symbol symb:String) {
        listingsymbol = symb
    }
    
    func AddEye(MonthEye eye:MonthEye) {
        registeredMonthEyes.append(eye)
    }
    func AddEye(StrikeEye eye:StrikeEye) {
        registeredStrikeEyes.append(eye)
    }
}

class Eye {
     //             SC      BP     BC     SP
    var isActive = [false, false, false, false]
    var symbol = ""
    var expDate = ""
    
    init(symbol sym:String, expDate date:String) {
        symbol = sym
        expDate = date
    }
}

class MonthEye: Eye {
    var bcspER = [["Buy Call | Sell Put","$ Edge", "0.00", "0", "0.01"],["0","0","0","0","1"]]
    var scbpER = [["Sell Call | Buy Put","$ Edge", "0.00", "0", "0.01"],["0","0","0","0","1"]]
}

class StrikeEye: Eye {
    var strikePrice = 0.0
    var isUsingEdgeRule = false
    var priceOverride = 0.0
    var quantityOverride = 0
    
    init(symbol sym:String, expDate date:String, strikePrice price:Double, priceOverride priceOvr:Double?, quantityOverride quantityOvr:Int?) {
        super.init(symbol: sym, expDate: date)
        strikePrice = price
        if priceOvr != nil {
            priceOverride = priceOvr!
        }
        if quantityOvr != nil {
            quantityOverride = quantityOvr!
        }
    }
}

func getListingBySymbol(array:[Listing],symbol sym:String) -> Listing {
    for i in array {
        if i.listingsymbol == sym {
            return i
        }
    }
    return Listing()
}

