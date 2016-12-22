//
//  EyeClass.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/17/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

enum Order {
    case buycall
    case sellcall
    case buyput
    case sellput
    case NA
}

class EyeBook {
    var listings:Array = [Listing]()
    
    init() {
        
    }
    
    init(fromEyesJSON jsonEyesObject:JSON, fromPortfolioJSON jsonPortfolioObject:JSON) {
        // add listings from retrieved eyes
        var successful = false
        
        if addListingsFromEyes(jsonEyesObject) {
            successful = true
        }
        //print("Debug: addListingsFromEyes: successful:  \(successful)")
        
        successful = false
        if addListingsFromPortfolio(jsonPortfolioObject) {
            successful = true
        }
        //print("Debug: addListingsFromPortfolio: successful:  \(successful)")
    }
    
    init(fromEyesJSON jsonEyesObject:JSON) {
        var successful = false
        
        if addListingsFromEyes(jsonEyesObject) {
            successful = true
        }
        //print("Debug: addListingsFromEyes: successful:  \(successful)")
        
    }
    
    init(fromPortfolioJSON jsonPortfolioObject:JSON) {
        var successful = false
        if addListingsFromPortfolio(jsonPortfolioObject) {
            successful = true
        }
        //print("Debug: addListingsFromPortfolio: successful:  \(successful)")
        
    }
    
    
    func getListingAtIndex(index:Int) -> Listing? {
        if listings.count <= index {
            return nil
        }
        return listings[index]
    }
    
    func addListingsFromEyes(jsonEyeObject:JSON) -> Bool {
        if let eyesJSONArray = jsonEyeObject["payload"]["rows"].array {
            addListingsFromJSONArray(eyesJSONArray)
            for (indx,eyeJSON) in eyesJSONArray.enumerate() {
                // var eyeDictionary = eyeJSON.dictionaryValue
                createAndAddEyeToListing(eyeJSON, listing: getListingBySymbol(eyeJSON["name"].stringValue)!, eyeJSONIndex: indx)
            }
            
            //Clean up any listings with no eyes
            var currentIndex = 0
            weak var currentListing:Listing?
            
            while currentIndex < (listings.count) {
                currentListing = listings[currentIndex]
                //print(currentListing?.listingSymbol)
                //print(currentListing?.registeredMonthContainers.count)
                if currentListing?.registeredMonthContainers.count == 0 {
                    listings.removeAtIndex(currentIndex)
                    currentIndex = 0
                }
                currentIndex += 1
            }
            return true
        }
        return false
    }
    
    func addListingsFromPortfolio(jsonPortObject:JSON) -> Bool {
        if let portJSONArray = jsonPortObject["payload"]["rows"].array {
            addListingsFromJSONArray(portJSONArray)
            return true
        }
        return false
        
    }
    
    func getListingBySymbol(symbol:String) -> Listing? {
        for i in listings {
            if i.listingSymbol == symbol {
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
                    let newListing = Listing(symbol: symbol)
                    //print("Debug: addListingFromJSONArray:  securityID: \(eye["securityid"].stringValue)  securityName: \(symbol)")
                    newListing.listingId = Int(eye["securityid"].stringValue)!
                    addListing(newListing)
                }
            } else {
                //print("ERROR: addListingsFromJSON(eyeBookJSON:JSON) 'NAME' field does not exist for: eye -> eye.description")
                //print(eye.debugDescription)
            }
        }
    }
    
    func createAndAddEyeToListing(eyeDict:JSON, listing:Listing, eyeJSONIndex index:Int) {
        let eyeExpDate = smileDateFormat.dateFromString(eyeDict["edate"].string!)!
        //print(eyeExpDate)
        let eyeExpString:String = smileDateFormat.stringFromDate(eyeExpDate)
        let entityType:Int = eyeDict["entitytype"].intValue
        let strike:String = eyeDict["strike"].stringValue
        let minDelta:String = eyeDict["mindelta"].stringValue
        
        var newMonth:MonthEye!
        var newStrike:StrikeEye!
        var success = false
        
        //print("eyeExpDate: \(listing.listingSymbol)  \(eyeExpString)  entityType: \(entityType)  strike: \(strike)  mindelta: \(minDelta)")
        if entityType != 0 {
            if strike != ""{
                newStrike = StrikeEye(eyeDict: eyeDict)
                newStrike.jsonIndex = index
            } else {
                newMonth = MonthEye(eyeDict: eyeDict)
                newMonth.jsonIndex = index
            }
            
            
            if let curContainer = listing.getContainerByDate(eyeExpDate) {
                if strike != "" {
                    
                    success = curContainer.AddEye(StrikeEye: newStrike)
                    //print("added strikeeye - curContainer \(success)")
                } else {
                    success = curContainer.AddMonthEye(newMonth)
                    //print("added strikeeye - curContainer \(success)")
                }
            } else {
                let newContainer = MonthContainer(listingSymbol: listing.listingSymbol, exp: eyeExpDate , expString: eyeExpString)
                if strike != "" {
                    success = newContainer.AddEye(StrikeEye: newStrike)
                    listing.AddContainer(newContainer)
                    //print("added montheye - newcontainer \(success)")
                } else if newContainer.AddMonthEye(newMonth) {
                    success = true
                    //print("added montheye - newcontainer \(success)")
                    listing.AddContainer(newContainer)
                }
            }
        }
    }
}

class Listing {
    
    enum DisplayType {
        case NoStrikes
        case AllStrikes
        case FilteredStrikes
    }
    
    
    var listingSymbol = ""
    var listingId:Int!
    var registeredMonthContainers = [MonthContainer]()
    var notifyOnly:Bool = false
    var isSelectedInEyebook:Bool = false
    var visibleStrikes:Array = [JSON]()
    var listingMaturities:Array = [JSON]()
    
    var maturitiesToDisplay:Array = [NSDate]()
    
    
    
    //FRONT END DISPLAY VARIABLES
    var willDisplay:DisplayType = .NoStrikes
    
    init() {
        
    }
    init(symbol symb:String) {
        listingSymbol = symb
    }
    
    deinit {
        //print("Listing: Deinit: Sym: \(listingSymbol)")
        visibleStrikes.removeAll()
        listingMaturities.removeAll()
        maturitiesToDisplay.removeAll()
    }
    
    func AddContainer(monthContainer:MonthContainer) {
        registeredMonthContainers.append(monthContainer)
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
        
        let expDate:NSDate = dateStringToNSDate(expDateString)
        return getContainerByDate(expDate)
    }
    
    func dateStringToNSDate(expDateString:String) -> NSDate {
        let expDate:NSDate = smileDateFormat.dateFromString(expDateString)!
        return expDate
    }
    
    func getMaturityIndex(date:NSDate) -> Int {
        if let indxRange = maturitiesToDisplay.indexOf(date) {
            return Int(indxRange)
        }
        return -1
    }
    
    func sortedAppend(strikeJSONData:[JSON]) {
        var indexToPlace = -1
        var strikeNumber:Double = 0.0
        var sortedStrikeArray:Array = [JSON]()
        
        for strikeJSON in strikeJSONData {
            indexToPlace = -1
            strikeNumber = Double(strikeJSON["strike"].stringValue)!
            for (indx,strike) in (sortedStrikeArray).enumerate() {
                let strikeToTest = Double(strike["strike"].stringValue)!
                //print("SortedAppend: strikeToTest: \(strikeToTest)")
                if strikeToTest > strikeNumber {
                    indexToPlace = (indx)
                    break
                }
            }
            
            if indexToPlace == -1 {
                sortedStrikeArray.append(strikeJSON)
            } else {
                sortedStrikeArray.insert(strikeJSON, atIndex: indexToPlace)
            }
        }
        
        visibleStrikes = visibleStrikes + sortedStrikeArray
    }
    
    func getVisibleStrikes(index:Int) -> JSON? {
        if visibleStrikes.count <= index {
            return nil
        }
        return visibleStrikes[index]
    }
    
}



class MonthContainer {
    var listingSymbol:String = ""
    var expDate = NSDate()
    var expDateString:String = ""
    var monthEyes:Array = [MonthEye?(), MonthEye?(), MonthEye?(), MonthEye?()]
    
    var isActive = true
    
    var notifyOnly:Bool = false
    
    var strikeEyes:Array = [[StrikeEye](),[StrikeEye](),[StrikeEye](),[StrikeEye]()]
    
    deinit {
        
        //print("deinit:MonthContainer: listingSymbol: \(listingSymbol)")
        strikeEyes.removeAll()
        monthEyes.removeAll()
    }
    
    init() {
        strikeEyes.removeAll()
        monthEyes.removeAll()
        
    }
    
    init(listingSymbol sym:String, exp:NSDate, expString:String) {
        listingSymbol = sym
        expDateString = expString
        expDate = exp
    }
    
    func AddMonthEye(eye:MonthEye) -> Bool {
        switch eye.order {
        case Order.buycall:
            monthEyes[0] = eye
            return true
        case Order.sellcall:
            monthEyes[1] = eye
            return true
        case Order.buyput:
            monthEyes[2] = eye
            return true
        case Order.sellput:
            monthEyes[3] = eye
            return true
        default:
            //print("AddMonthEye Failed")
            return false
        }
    }
    
    func AddEye(StrikeEye eye:StrikeEye) -> Bool {
        switch eye.order {
        case Order.buycall:
            strikeEyes[0].append(eye)
            return true
        case Order.sellcall:
            strikeEyes[1].append(eye)
            return true
        case Order.buyput:
            strikeEyes[2].append(eye)
            return true
        case Order.sellput:
            strikeEyes[3].append(eye)
            return true
        default:
            //print("AddStrikeEye Failed")
            return false
        }
    }
    
    func GetMonthByOrder(order:Order) -> MonthEye? {
        switch order {
        case Order.buycall:
            return monthEyes[0]
        case Order.sellcall:
            return monthEyes[1]
        case Order.buyput:
            return monthEyes[2]
        case Order.sellput:
            return monthEyes[3]
        default:
            //print("No Month Found")
            return nil
        }
    }
    
    func GetStrikesByOrder(order:Order) -> [StrikeEye]? {
        switch order {
        case Order.buycall:
            return strikeEyes[0]
        case Order.sellcall:
            return strikeEyes[1]
        case Order.buyput:
            return strikeEyes[2]
        case Order.sellput:
            return strikeEyes[3]
        default:
            //print("No Month Found")
            return nil
        }
    }
    
}

//????????????
//Low Delta = minDelta
//High Delta = maxDelta
//Max Delta = delta
//Total Delta = totalDelta
//Current Delta = currentDelta


class Eye {
    //     SC      BP     BC     SP
    
    
    
    
    var order:Order = Order.NA
    var isActive = false
    var symbol:String
    var expDate:NSDate
    var expDateString:String
    var orderType = "LMT"
    var minEdge = 0.0
    var notifyOnly = false
    var id:Int = 0
    var autoHedge = "Off"
    var eyeType = "TheoBid"
    var currentDelta = 0.0
    var totalDelta:Double
    var cmdType = ("", "")
    var entityType = 0
    var quantity = 0
    var delta = 0.0
    var securityId = 0
    
    var exchangeData = Exchanges()
    
    var eyeParams = EyeParams()
    
    var eyeJson:JSON
    
    var jsonIndex:Int = -1
    
    var showDebug = false
    
    deinit {
        //print("Eye: Deinit")
        
    }
    
    
    
    init(Symbol sym:String, ExpDate date:String, MinEdge edge:Double = 0.0,Quantity quantitiy:Int = 1, MaxDelta delta:Double,  TotalDelta tDelta:Double = 1000.0) {
        self.delta = delta
        symbol = sym
        expDateString = date
        expDate = smileDateFormat.dateFromString(date)!
        totalDelta = tDelta
        eyeJson = JSON(nilLiteral: ())
    }
    
    init(eyeDict:JSON) {
        
        eyeJson = eyeDict
        symbol = eyeDict["name"].stringValue
        expDateString = (eyeDict["edate"].stringValue)
        expDate = smileDateFormat.dateFromString(expDateString)!
        minEdge = eyeDict["edge"].doubleValue
        eyeType = eyeDict["eyetype"].stringValue
        id = eyeDict["id"].intValue
        autoHedge = eyeDict["autohedge"].stringValue
        totalDelta = Double(eyeDict["totaldelta"].stringValue)!
        currentDelta = eyeDict["currentdelta"].doubleValue
        cmdType = (eyeDict["command"].stringValue, eyeDict["type"].stringValue)
        order = getOrderEnum(eyeDict["command"].stringValue, type: eyeDict["type"].stringValue)
        entityType = eyeDict["entitytype"].intValue
        quantity = eyeDict["quantity"].intValue
        
        if let deltaReal = Double(eyeDict["delta"].stringValue) {
            delta = deltaReal
        }
        securityId = Int(eyeDict["securityid"].stringValue)!
        
        //print("eyeTest:  \(eyeDict["id"].trueInt)")
        
        eyeParams = EyeParams(eyeDict)
        exchangeData = Exchanges(fromEyeJson: eyeDict)
        
    }
    
    init(strikeJSON:JSON,Symbol sym:String,SecurityId securityId:Int, MinEdge edge:Double = 0.1, Quantity qntity:Int = 1, MaxDelta
        
        mxDelta:Double, TotalDelta tDelta:Double = 1000.0) {
        //print("init: eye wStrikeJSON")
        symbol = sym
        id = securityId
        minEdge = edge
        quantity = qntity
        delta = mxDelta
        totalDelta = tDelta
        expDateString = strikeJSON["odate"].stringValue
        expDate = smileDateFormat.dateFromString(expDateString)!
        eyeJson = JSON(nilLiteral: ())
        
    }
    
    
    
    init() {
        symbol = ""
        expDate = NSDate()
        expDateString = ""
        totalDelta = 1000.0
        eyeJson = JSON(nilLiteral: ())
    }
    
}

class MonthEye: Eye {
    //for old eye
    
    var quantityDelta = 0.0
    
    var minDelta = 1.0
    var maxDelta = 100.0
    
    
    override init(eyeDict:JSON) {
        super.init(eyeDict: eyeDict)
        if clientSuccess {
            //print("Mindelta: \(eyeDict["mindelta"].stringValue)")
            minDelta = Double(eyeDict["mindelta"].stringValue)!
            maxDelta = Double(eyeDict["maxdelta"].stringValue)!
        }
        //highDelta = maxDelta
    }
    
    override init() {
        super.init()
    }
    
    init(symbol sym:String, expDate date:String, minEdge edge:Double,Quantity quantity:Int, MaxDelta delta:Double, LowDelta mnDelta:Double, HighDelta mxDelta:Double, TotalDelta tDelta:Double) {
        super.init(Symbol: sym, ExpDate: date, MinEdge: edge, Quantity: quantity, MaxDelta: delta)
        minDelta = mnDelta
        maxDelta = mxDelta
        totalDelta = tDelta
    }
    
    init(strikeJSON:JSON,Symbol sym:String,SecurityId securityId:Int, MinEdge edge:Double = 0.1, MaxDelta delta:Double = 100.0, Quantity qntity:Int = 1, TotalDelta tDelta:Double = 1000.0) {
        super.init(strikeJSON: strikeJSON, Symbol: sym, SecurityId: securityId, MinEdge: edge, Quantity: qntity, MaxDelta: delta, TotalDelta: tDelta)
        
    }
}

class StrikeEye: Eye {
    
    var strike = 0.0
    var isUsingEdgeRule = false
    var quantityOverride = 0
    var deltaOverride = 0.0
    
    override init(eyeDict:JSON) {
        super.init(eyeDict: eyeDict)
        if clientSuccess {
            //print(eyeDict["strike"]!.doubleValue)
            strike = eyeDict["strike"].doubleValue
        } else {
            strike = 15.0
        }
        deltaOverride = delta
    }
    
    init(Symbol sym:String, ExpDate date:String, StrikePrice price:Double, Quantity quantity:Int, MaxDelta delta:Double, TotalDelta tDelta:Double = 1000.0) {
        super.init(Symbol: sym, ExpDate: date, Quantity: quantity, MaxDelta: delta, TotalDelta: tDelta)
        self.strike = price
    }
    override init() {
        super.init()
    }
    
    init(strikeJSON:JSON,Symbol sym:String,SecurityId securityId:Int, MinEdge edge:Double = 0.1, MaxDelta delta:Double = 100.0, Quantity qntity:Int = 1, TotalDelta tDelta:Double = 1000.0) {
        super.init(strikeJSON: strikeJSON, Symbol: sym, SecurityId: securityId, MinEdge: edge, Quantity: qntity, MaxDelta: delta, TotalDelta: tDelta)
        strike = strikeJSON["strike"].doubleValue
        
    }
    
    deinit {
        if showDebug {
         print("demoStrikeDeiniting")
        }
    }
    
}

func getOrderEnum(cmd:String, type:String) -> Order {
    switch (cmd, type) {
    case("Buy", "Call"):
        return Order.buycall
    case ("Sell", "Call"):
        return Order.sellcall
    case("Buy", "Put"):
        return Order.buyput
    case("Sell","Put"):
        return Order.sellput
    default:
        return Order.NA
    }
}

func enumToIndex(order:Order) -> Int {
    switch order {
    case Order.buycall:
        return 0
    case Order.sellcall:
        return 1
    case Order.buyput:
        return 2
    case Order.sellput:
        return 3
    default:
        //print("ERROR: enumToIndex(order:Order) DEFAULT HIT")
        return -1
    }
}



