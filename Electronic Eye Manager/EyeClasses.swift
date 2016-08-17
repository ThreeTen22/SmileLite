//
//  EyeClass.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/17/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

enum Order {
    case buyCall
    case sellCall
    case buyPut
    case sellPut
}


class Listing {
    var listingsymbol = ""
    var registeredMonthEyes = [MonthEye]()
    var registeredStrikeEyes = [StrikeEye]()
    var isSelected:Bool = false
    
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
    var orderType = ["LMT", "LMT", "LMT", "LMT"]
    var minEdge = [0.0, 0.0, 0.0, 0.0]
    
    init(symbol sym:String, expDate date:String) {
        symbol = sym
        expDate = date
    }
}

class MonthEye: Eye {
    //for old eye
    //var bcspER = [["Buy Call | Sell Put","$ Edge", "0.00", "0", "0.01"],["0","0","0","0","1"]]
    //var scbpER = [["Sell Call | Buy Put","$ Edge", "0.00", "0", "0.01"],["0","0","0","0","1"]]
    //var eyeParameters = ["Delta","Quanity","Min Edge", "Max Delta","Order Type"]
    var quantity = [0.0, 0.0, 0.0, 0.0]
    var quantityDelta = [0.0, 0.0, 0.0, 0.0]
    var minDelta = [0.0, 0.0, 0.0, 0.0]
    var maxDelta = [0.0, 0.0, 0.0, 0.0]
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

