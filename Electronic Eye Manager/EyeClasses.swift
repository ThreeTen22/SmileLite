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
    case NA
}


class EyeBook {
    var listings:Array = [Listing]()
    
    init() {
        
    }
    
    init(fromJSON jsonObject:JSON) {
        // add listings to eyebook
        if let eyebookJSONArray = jsonObject["payload"]["rows"].array {
            addListingsFromJSONArray(eyebookJSONArray)
            
            for eyeJSON in eyebookJSONArray {
                var eyeDictionary = eyeJSON.dictionaryValue
                createAndAddEyeToListing(eyeDictionary, listing: getListingBySymbol(eyeDictionary["name"]!.string!)!)
            }
        }
        //Clean up any listings with no eyes
        var currentIndex = 0
        var currentListing = Listing()
        
        while currentIndex < (listings.count) {
            currentListing = listings[currentIndex]
            if currentListing.registeredMonthContainers.count == 0 && currentListing.registeredStrikeEyes.count == 0 {
                listings.removeAtIndex(currentIndex)
                continue
            }
            currentIndex += 1
        }
        
        
    }
    
    func getListingBySymbol(symbol:String) -> Listing? {
        for i in listings {
            if i.listingsymbol == symbol {
                return i
            }
        }
        return nil
    }
    
    func addListing(newListing:Listing) {
        listings.append(newListing)
    }
    
    func addListingsFromJSONArray(eyeBookArray:[JSON]) {
        for eye in eyeBookArray {
            if let symbol = eye["name"].string {
                if getListingBySymbol(symbol) == nil {
                    //CREATE NEW LISTING
                    addListing(Listing(symbol: symbol))
                }
            } else {
                print("ERROR: addListingsFromJSON(eyeBookJSON:JSON) 'NAME' field does not exist for: eye -> eye.description")
                print(eye.debugDescription)
            }
        }
    }
    
    func createAndAddEyeToListing(eyeDict:[String:JSON], listing:Listing) {
        let eyeExpString:String = eyeDict["edate"]!.string!
        let eyeExpDate = smileDateFormat.dateFromString(eyeExpString)!
        let newMonth = MonthEye(eyeDict: eyeDict)
        if let curContainer = listing.getContainerByDate(eyeExpDate) {
            curContainer.AddMonthEye(newMonth)
        } else {
            let newContainer = MonthContainer(listingSymbol: listing.listingsymbol, exp: eyeExpDate , expString: eyeExpString)
            if newContainer.AddMonthEye(newMonth) {
                listing.AddContainer(newContainer)
            }
        }
    }
}

class Listing {
    var listingsymbol = ""
    var registeredMonthContainers = [MonthContainer]()
    var registeredStrikeEyes = [StrikeEye]()
    var notifyOnly:Bool = false
    var isSelected:Bool = false
    
    init() {
        
    }
    init(symbol symb:String) {
        listingsymbol = symb
    }
    
    func AddContainer(monthContainer:MonthContainer) {
        registeredMonthContainers.append(monthContainer)
    }
    func AddEye(StrikeEye eye:StrikeEye) {
        registeredStrikeEyes.append(eye)
    }
    
    func getContainerByDate(expDate:NSDate) -> MonthContainer? {
        if registeredMonthContainers.count > 0 {
            for container in registeredMonthContainers {
                if expDate.isEqualToDate(container.expDate) {
                    return container
                }
            }
        }
        return nil
    }
    
    func getContainerByDate(expDateString:String) -> MonthContainer? {
        let expDate:NSDate = smileDateFormat.dateFromString(expDateString)!
        
        return getContainerByDate(expDate)
    }
}



class MonthContainer {
    var listingSymbol:String = ""
    var expDate = NSDate()
    var expDateString:String = ""
    var monthEyes:Array = [MonthEye?(), MonthEye?(), MonthEye?(), MonthEye?()]
    var isActive = true
    var notifyOnly:Bool = false
    
    init() {
        
    }
    
    init(listingSymbol sym:String, exp:NSDate, expString:String) {
        listingSymbol = sym
        expDateString = expString
        expDate = exp
    }
    
    func AddMonthEye(eye:MonthEye) -> Bool {
        switch eye.order {
        case Order.sellCall:
            monthEyes[0] = eye
            return true
        case Order.buyPut:
            monthEyes[1] = eye
            return true
        case Order.buyCall:
            monthEyes[2] = eye
            return true
        case Order.sellPut:
            //monthEyes[3] = eye
            return false
        default:
            print("AddMonthEye Failed")
            return false
        }
    }
    
    func GetMonthByOrder(order:Order) -> MonthEye? {
        switch order {
        case Order.sellCall:
            return monthEyes[0]
        case Order.buyPut:
            return monthEyes[1]
        case Order.buyCall:
            return monthEyes[2]
        case Order.sellPut:
            return monthEyes[3]
        default:
            print("No Month Found")
            return nil
        }
    }
    
    
    
}

class Eye {
    //             SC      BP     BC     SP
    var order:Order = Order.NA
    var isActive = false
    var symbol = ""
    var expDate:NSDate = NSDate()
    var expDateString = ""
    var orderType = "LMT"
    var minEdge = 0.0
    var notifyOnly = false
    var id = 0
    var autohedge = false
    var eyeType = "TheoBid"
    var currentDelta = 0.0
    var totalDelta = 1.0
    var cmdType = ("", "")
    var entityType = 0
    var quantity = 0
    
    init(symbol sym:String, expDate date:String) {
        symbol = sym
        expDate = smileDateFormat.dateFromString(date)!
    }
    
    init(eyeDict:[String:JSON]) {
        symbol = eyeDict["name"]!.stringValue
        expDateString = (eyeDict["edate"]!.stringValue)
        expDate = smileDateFormat.dateFromString(expDateString)!
        minEdge = eyeDict["edge"]!.doubleValue
        eyeType = eyeDict["eyetype"]!.stringValue
        id = eyeDict["id"]!.intValue
        autohedge = eyeDict["autohedge"]!.boolValue
        totalDelta = eyeDict["delta"]!.doubleValue
        currentDelta = eyeDict["eyetype"]!.doubleValue
        cmdType = (eyeDict["command"]!.stringValue, eyeDict["type"]!.stringValue)
        order = getOrderEnum(eyeDict["command"]!.stringValue, type: eyeDict["type"]!.stringValue)
        entityType = eyeDict["entitytype"]!.intValue
        quantity = eyeDict["quantity"]!.intValue
        
    }
    
    init() {
        
    }
    
}

class MonthEye: Eye {
    //for old eye
    //var bcspER = [["Buy Call | Sell Put","$ Edge", "0.00", "0", "0.01"],["0","0","0","0","1"]]
    //var scbpER = [["Sell Call | Buy Put","$ Edge", "0.00", "0", "0.01"],["0","0","0","0","1"]]
    //var eyeParameters = ["Delta","Quanity","Min Edge", "Max Delta","Order Type"]
    var quantityDelta = 0.0
    var minDelta = 0.0
    var maxDelta = 0.0
    
    
    
    init(symbol sym:String, expDate date:String, id:Int, order cmdType:Order, quantity qntity:Int, quanitityDelta qDelta:Double, minDelta mnDelta:Double, maxDelta mxDelta:Double) {
        let indx = enumToIndex(cmdType)
        super.init(symbol: sym, expDate: date)
        self.id = id
        self.order = cmdType
        self.quantity = qntity
        self.quantityDelta = qDelta
        self.minDelta = mnDelta
        self.maxDelta = mxDelta
    }
    
    override init(eyeDict:[String:JSON]) {
        super.init(eyeDict: eyeDict)
    }
    
    override init(symbol sym: String, expDate date: String) {
        super.init(symbol: sym, expDate: date)
    }
    override init() {
        super.init()
    }
}

class StrikeEye: Eye {
    var strikePrice = 0.0
    var isUsingEdgeRule = false
    var priceOverride = 0.0
    var quantityOverride = 0
    
    init(symbol sym:String, expDate date:String, strikePrice price:Double, priceOverride priceOvr:Double?, quantityOverride quantityOvr:Int?) {
        super.init(symbol: sym, expDate: date)
        self.strikePrice = price
        if priceOvr != nil {
            priceOverride = priceOvr!
        }
        if quantityOvr != nil {
            quantityOverride = quantityOvr!
        }
    }
    override init() {
        super.init()
    }
    
}

func getOrderEnum(cmd:String, type:String) -> Order {
    switch (cmd, type) {
    case ("Sell", "Call"):
        return Order.sellCall
    case("Buy", "Put"):
        return Order.buyPut
    case("Buy", "Call"):
        return Order.buyCall
    case("Sell","Put"):
        return Order.sellPut
    default:
        return Order.NA
    }
}

func enumToIndex(order:Order) -> Int {
    switch order {
    case Order.sellCall:
        return 0
    case Order.buyPut:
        return 1
    case Order.buyCall:
        return 2
    case Order.sellPut:
        return 3
    default:
        print("ERROR: enumToIndex(order:Order) DEFAULT HIT")
        return -1
    }
}
