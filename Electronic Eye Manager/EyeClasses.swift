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
        print("Debug: addListingsFromEyes: successful:  \(successful)")
        
        successful = false
        if addListingsFromPortfolio(jsonPortfolioObject) {
            successful = true
        }
        print("Debug: addListingsFromPortfolio: successful:  \(successful)")
    }
    
    init(fromEyesJSON jsonEyesObject:JSON) {
        var successful = false
        
        if addListingsFromEyes(jsonEyesObject) {
            successful = true
        }
        print("Debug: addListingsFromEyes: successful:  \(successful)")
        
    }
    
    init(fromPortfolioJSON jsonPortfolioObject:JSON) {
        var successful = false
        if addListingsFromPortfolio(jsonPortfolioObject) {
            successful = true
        }
        print("Debug: addListingsFromPortfolio: successful:  \(successful)")
        
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
                var eyeDictionary = eyeJSON.dictionaryValue
                createAndAddEyeToListing(eyeDictionary, listing: getListingBySymbol(eyeDictionary["name"]!.string!)!, eyeJSONIndex: indx)
            }
            
            //Clean up any listings with no eyes
            var currentIndex = 0
            var currentListing:Listing!
            
            while currentIndex < (listings.count) {
                currentListing = listings[currentIndex]
                if currentListing.registeredMonthContainers.count == 0 {
                    listings.removeAtIndex(currentIndex)
                    continue
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
    
    func createAndAddEyeToListing(eyeDict:[String:JSON], listing:Listing, eyeJSONIndex index:Int) {
        
        let eyeExpDate = smileDateFormat.dateFromString(eyeDict["edate"]!.string!)!
        //print(eyeExpDate)
        let eyeExpString:String = smileDateFormat.stringFromDate(eyeExpDate)
        let entityType:Int = eyeDict["entitytype"]!.intValue
        let strike:String = eyeDict["strike"]!.stringValue
        
        
        var newMonth:MonthEye!
        var newStrike:StrikeEye!
        
        if strike != "" && entityType != 0 {
            newStrike = StrikeEye(eyeDict: eyeDict)
            newStrike.jsonIndex = index
        } else {
            newMonth = MonthEye(eyeDict: eyeDict)
            newMonth.jsonIndex = index
        }
        
        if let curContainer = listing.getContainerByDate(eyeExpDate) {
            if strike != "" {
                curContainer.AddEye(StrikeEye: newStrike)
            } else {
                curContainer.AddMonthEye(newMonth)
            }
        } else {
            let newContainer = MonthContainer(listingSymbol: listing.listingsymbol, exp: eyeExpDate , expString: eyeExpString)
            if strike != "" && entityType != 0 {
                newContainer.AddEye(StrikeEye: newStrike)
                listing.AddContainer(newContainer)
            } else if newContainer.AddMonthEye(newMonth) {
                listing.AddContainer(newContainer)
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
    
    
    var listingsymbol = ""
    var listingId = 0
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
        listingsymbol = symb
    }
    
    deinit {
        //print("Listing: Deinit: Sym: \(listingsymbol)")
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
    
    func addMaturities(success:Bool, errMsg:String, client:TCPClient) {
        
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
        
        visibleStrikes.appendContentsOf(sortedStrikeArray)
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
     //print("MonthContainer: Deinit: listingSymbol: \(listingSymbol)")
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
    var autohedge = "Off"
    var eyeType = "TheoBid"
    var currentDelta = 0.0
    var totalDelta = 1.0
    var cmdType = ("", "")
    var entityType = 0
    var quantity = 0
    var delta = 0.0
    var securityId = 0
    
    var jsonIndex:Int = -1
    
    deinit {
        //print("Eye: Deinit")
        
    }
    
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
        autohedge = eyeDict["autohedge"]!.stringValue
        totalDelta = Double(eyeDict["totaldelta"]!.stringValue)!
        currentDelta = eyeDict["currentdelta"]!.doubleValue
        cmdType = (eyeDict["command"]!.stringValue, eyeDict["type"]!.stringValue)
        order = getOrderEnum(eyeDict["command"]!.stringValue, type: eyeDict["type"]!.stringValue)
        entityType = eyeDict["entitytype"]!.intValue
        quantity = eyeDict["quantity"]!.intValue
        if let deltaReal = Double(eyeDict["delta"]!.stringValue) {
            delta = deltaReal
        } else {
            delta = 0.0
        }
        securityId = Int(eyeDict["securityid"]!.stringValue)!
        
    }
    
    init() {
        
    }
    
}

class MonthEye: Eye {
    //for old eye
    
    var quantityDelta = 0.0
    var lowDelta = 0.0
    var highDelta = 0.0
    
    var minDelta = 0.0
    var maxDelta = 100.0
    
    
    
    init(symbol sym:String, expDate date:String, id:Int, order cmdType:Order, quantity qntity:Int, quanitityDelta qDelta:Double, minDelta mnDelta:Double, maxDelta mxDelta:Double) {
        //let indx = enumToIndex(cmdType)
        super.init(symbol: sym, expDate: date)
        self.id = id
        self.order = cmdType
        self.quantity = qntity
        self.quantityDelta = qDelta
        self.lowDelta = mnDelta
        self.highDelta = mxDelta
    }
    
    override init(eyeDict:[String:JSON]) {
        super.init(eyeDict: eyeDict)
        if clientSuccess {
            lowDelta = Double(eyeDict["mindelta"]!.stringValue)!
            highDelta = Double(eyeDict["maxdelta"]!.stringValue)!
        } else {
            lowDelta = 0.0
            highDelta = 100.0
        }
        
        minDelta = lowDelta
        //highDelta = maxDelta
    }
    
    override init(symbol sym: String, expDate date: String) {
        super.init(symbol: sym, expDate: date)
    }
    override init() {
        super.init()
    }
}

class StrikeEye: Eye {
    var strike = 0.0
    var isUsingEdgeRule = false
    var quantityOverride = 0
    var deltaOverride = 0.0
    
    override init(eyeDict:[String:JSON]) {
        super.init(eyeDict: eyeDict)
        if clientSuccess {
            //print(eyeDict["strike"]!.doubleValue)
            strike = eyeDict["strike"]!.doubleValue
        } else {
            strike = 15.0
        }
        deltaOverride = delta
        print("InitStrike: - \(symbol) \(expDateString) - \(strike) - \(cmdType)")
    }
    
    init(symbol sym:String, expDate date:String, strikePrice price:Double, priceOverride priceOvr:Double?, quantityOverride quantityOvr:Int?) {
        super.init(symbol: sym, expDate: date)
        self.strike = price
    }
    override init() {
        super.init()
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

let eyebookRaw:String = "{\"payload\":{\"rows\":[{\"dfiller_45_13\":\"0.00000000\", \"type\":\"Put\", \"entitytype\":\"2\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"4\", \"id\":\"56\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"6\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"9\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"12\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"1\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"1.00000000\", \"ordervalidity12\":\"1\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"11/18/2016\", \"orderprefs\":\"12\", \"expirationid\":\"433132\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"2\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"5\", \"delta\":\"1500.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"7\", \"securityid\":\"1917\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Sell\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"16\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"50.00000000\", \"entityid\":\"433132\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"ADTN\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"TheoAsk\", \"maxdelta\":\"100.00000000\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"3\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Put\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"1\", \"strikeid\":\"0\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"8\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"12\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"10\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.25000000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"12\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"Call\", \"entitytype\":\"1\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"4\", \"id\":\"57\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"6\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"9\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"12\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"1\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"1.00000000\", \"ordervalidity12\":\"1\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"02/17/2017\", \"orderprefs\":\"12\", \"expirationid\":\"486541\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"2\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"5\", \"delta\":\"1500.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"7\", \"securityid\":\"1917\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Buy\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"16\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"50.00000000\", \"entityid\":\"486541\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"ADTN\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"TheoBid\", \"maxdelta\":\"100.00000000\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"3\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Call\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"1\", \"strikeid\":\"0\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"8\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"12\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"10\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.10100000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"12\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"Put\", \"entitytype\":\"2\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"4\", \"id\":\"58\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"6\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"9\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"12\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"1\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"1.00000000\", \"ordervalidity12\":\"1\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"02/17/2017\", \"orderprefs\":\"12\", \"expirationid\":\"486541\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"2\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"5\", \"delta\":\"1500.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"7\", \"securityid\":\"1917\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Sell\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"16\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"50.00000000\", \"entityid\":\"486541\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"ADTN\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"TheoAsk\", \"maxdelta\":\"100.00000000\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"3\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Put\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"1\", \"strikeid\":\"0\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"8\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"12\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"10\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.10100000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"12\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"\", \"entitytype\":\"0\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"1.00000000\", \"listexchange6\":\"0\", \"autohedge\":\"\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"65\", \"id\":\"36\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"0\", \"filler_45_20\":\"0\", \"listexchange1\":\"71\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"0\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"0\", \"ordervalidity5\":\"0\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"0\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"0\", \"quantity\":\"1\", \"ordervalidity10\":\"0\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"0\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"0\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"\", \"ordervalidity12\":\"0\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"01/01/1970\", \"orderprefs\":\"3\", \"expirationid\":\"0\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"0\", \"exchange1\":\"71\", \"ordervalidity4\":\"0\", \"filler_45_3\":\"0\", \"exchange4\":\"0\", \"delta\":\"\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"0\", \"securityid\":\"2209\", \"listexchange7\":\"0\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"82\", \"command\":\"Buy\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"0\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"0\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"25000.00000000\", \"entityid\":\"2209\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"0\", \"name\":\"AA\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"MarketAsk\", \"maxdelta\":\"\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"82\", \"listexchange13\":\"0\", \"ordervalidity7\":\"0\", \"product\":\"\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"0\", \"strikeid\":\"0\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"0\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"3\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"0\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"0\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"0\", \"listexchange3\":\"65\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"3\", \"listexchange12\":\"0\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"0\", \"ordervalidities\":\"3\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"Put\", \"entitytype\":\"2\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"4\", \"id\":\"59\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"6\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"9\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"12\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"1\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"1.00000000\", \"ordervalidity12\":\"1\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"02/17/2017\", \"orderprefs\":\"12\", \"expirationid\":\"486541\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"2\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"5\", \"delta\":\"1500.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"7\", \"securityid\":\"1917\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Buy\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"16\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"50.00000000\", \"entityid\":\"486541\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"ADTN\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"TheoBid\", \"maxdelta\":\"100.00000000\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"3\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Put\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"1\", \"strikeid\":\"0\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"8\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"12\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"10\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.10100000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"12\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"Call\", \"entitytype\":\"1\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"4\", \"id\":\"60\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"6\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"9\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"12\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"1\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"1.00000000\", \"ordervalidity12\":\"1\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"02/17/2017\", \"orderprefs\":\"12\", \"expirationid\":\"486541\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"2\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"5\", \"delta\":\"1500.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"7\", \"securityid\":\"1917\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Sell\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"16\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"50.00000000\", \"entityid\":\"486541\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"ADTN\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"TheoAsk\", \"maxdelta\":\"100.00000000\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"3\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Call\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"1\", \"strikeid\":\"0\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"8\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"12\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"10\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.10100000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"12\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"Call\", \"entitytype\":\"1\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"4\", \"id\":\"41\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"6\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"9\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"12\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"1\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"1.00000000\", \"ordervalidity12\":\"1\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"11/18/2016\", \"orderprefs\":\"12\", \"expirationid\":\"433132\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"2\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"5\", \"delta\":\"1500.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"7\", \"securityid\":\"1917\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Buy\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"16\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"50.00000000\", \"entityid\":\"433132\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"ADTN\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"TheoBid\", \"maxdelta\":\"100.00000000\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"3\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Call\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"1\", \"strikeid\":\"0\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"8\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"12\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"10\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.25000000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"12\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"Call\", \"entitytype\":\"1\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"38\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"4\", \"id\":\"65\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"6\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"9\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"12\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"20\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"\", \"ordervalidity12\":\"1\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"10/22/2016\", \"orderprefs\":\"12\", \"expirationid\":\"562588\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"2\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"5\", \"delta\":\"283.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"7\", \"securityid\":\"2209\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Buy\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"16\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"0.00000000\", \"entityid\":\"15936772\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"AA\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"Theo\", \"maxdelta\":\"\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"3\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Call\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"1\", \"strikeid\":\"15936772\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"8\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"12\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"10\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.01000000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"12\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"Call\", \"entitytype\":\"1\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"110.00\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"5\", \"id\":\"66\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"7\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"12\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"10\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"11\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"\", \"ordervalidity12\":\"0\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"10/21/2016\", \"orderprefs\":\"11\", \"expirationid\":\"380728\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"3\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"1\", \"delta\":\"1049.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"8\", \"securityid\":\"1500\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Buy\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"0\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"0.00000000\", \"entityid\":\"10266591\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"AAPL\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"Theo\", \"maxdelta\":\"\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"4\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Call\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"6\", \"strikeid\":\"10266591\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"9\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"11\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"16\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.01000000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"11\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"Call\", \"entitytype\":\"1\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"17\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"5\", \"id\":\"67\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"7\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"12\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"10\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"30\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"\", \"ordervalidity12\":\"0\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"02/17/2017\", \"orderprefs\":\"11\", \"expirationid\":\"486541\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"3\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"1\", \"delta\":\"3000.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"8\", \"securityid\":\"1917\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Sell\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"0\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"1000.00000000\", \"entityid\":\"13682299\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"ADTN\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"Theo\", \"maxdelta\":\"\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"4\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Call\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"6\", \"strikeid\":\"13682299\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"9\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"11\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"16\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.01000000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"11\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"Call\", \"entitytype\":\"1\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"4\", \"id\":\"54\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"6\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"9\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"12\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"1\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"1.00000000\", \"ordervalidity12\":\"1\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"11/18/2016\", \"orderprefs\":\"12\", \"expirationid\":\"433132\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"2\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"5\", \"delta\":\"1500.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"7\", \"securityid\":\"1917\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Sell\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"16\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"50.00000000\", \"entityid\":\"433132\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"ADTN\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"TheoAsk\", \"maxdelta\":\"100.00000000\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"3\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Call\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"1\", \"strikeid\":\"0\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"8\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"12\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"10\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.25000000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"12\"}, {\"dfiller_45_13\":\"0.00000000\", \"type\":\"Put\", \"entitytype\":\"2\", \"orderpref14\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"strike\":\"\", \"lfiller_45_8\":\"\", \"filler_45_13\":\"0\", \"ordervalidity15\":\"0\", \"ordervalidity1\":\"1\", \"price\":\"\", \"listexchange6\":\"6\", \"autohedge\":\"Off\", \"filler_45_2\":\"0\", \"prefs\":\"1000000000000000000000000000000000000000000000000000000000000000\", \"exchange3\":\"4\", \"id\":\"55\", \"lfiller_45_19\":\"\", \"dfiller_45_3\":\"0.00000000\", \"exchange6\":\"6\", \"filler_45_20\":\"0\", \"listexchange1\":\"2\", \"orderpref3\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange9\":\"9\", \"filler_45_5\":\"0\", \"trader\":\"61\", \"filler_45_16\":\"0\", \"lfiller_45_14\":\"\", \"orderpref6\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_1\":\"\", \"dfiller_45_16\":\"0.00000000\", \"orderpref9\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"filler_45_8\":\"0\", \"listexchange11\":\"10\", \"ordervalidity5\":\"1\", \"dfiller_45_6\":\"0.00000000\", \"collection\":\"45\", \"dfiller_45_11\":\"0.00000000\", \"exchange10\":\"12\", \"lfiller_45_20\":\"\", \"filler_45_19\":\"0\", \"exchange13\":\"0\", \"lfiller_45_4\":\"\", \"listexchange9\":\"9\", \"quantity\":\"1\", \"ordervalidity10\":\"1\", \"dfiller_45_9\":\"0.00000000\", \"listexchange4\":\"5\", \"notifyauditstate\":\"\", \"lfiller_45_17\":\"\", \"listexchange15\":\"0\", \"ordervalidity9\":\"1\", \"orderpref12\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"currentdelta\":\"0.00000000\", \"lfiller_45_7\":\"\", \"dfiller_45_19\":\"0.00000000\", \"filler_45_12\":\"0\", \"lfiller_45_12\":\"\", \"orderpref15\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"mindelta\":\"1.00000000\", \"ordervalidity12\":\"1\", \"dfiller_45_14\":\"0.00000000\", \"edate\":\"11/18/2016\", \"orderprefs\":\"12\", \"expirationid\":\"433132\", \"dfiller_45_2\":\"0.00000000\", \"listexchange10\":\"12\", \"exchange1\":\"2\", \"ordervalidity4\":\"1\", \"filler_45_3\":\"0\", \"exchange4\":\"5\", \"delta\":\"1500.00000000\", \"filler_45_15\":\"0\", \"orderpref2\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange7\":\"7\", \"securityid\":\"1917\", \"listexchange7\":\"7\", \"orderpref5\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_20\":\"0.00000000\", \"filler_45_6\":\"0\", \"orderpref8\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_5\":\"0.00000000\", \"ordervalidity14\":\"0\", \"missingexchangesstate\":\"\", \"listexchange2\":\"3\", \"command\":\"Buy\", \"filler_45_18\":\"0\", \"filler_45_9\":\"0\", \"lfiller_45_15\":\"\", \"listexchange14\":\"0\", \"ordervalidity8\":\"1\", \"exchangeauditstate\":\"\", \"lfiller_45_3\":\"\", \"dfiller_45_17\":\"0.00000000\", \"lfiller_45_10\":\"\", \"exchange12\":\"16\", \"dfiller_45_8\":\"0.00000000\", \"exchange15\":\"0\", \"dfiller_45_12\":\"0.00000000\", \"ticksize\":\"100\", \"orderpref10\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordertype\":\"LMT\", \"ordervalidity3\":\"1\", \"status\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"lfiller_45_6\":\"\", \"filler_45_11\":\"0\", \"totaldelta\":\"50.00000000\", \"entityid\":\"433132\", \"orderpref13\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"listexchange5\":\"1\", \"name\":\"ADTN\", \"lfiller_45_18\":\"\", \"dfiller_45_1\":\"0.00000000\", \"eyetype\":\"TheoBid\", \"maxdelta\":\"100.00000000\", \"filler_45_1\":\"0\", \"lfiller_45_9\":\"\", \"filler_45_14\":\"0\", \"lfiller_45_13\":\"\", \"exchange2\":\"3\", \"listexchange13\":\"0\", \"ordervalidity7\":\"1\", \"product\":\"Put\", \"orderpref1\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"exchange5\":\"1\", \"strikeid\":\"0\", \"filler_45_4\":\"0\", \"dfiller_45_15\":\"0.00000000\", \"exchange8\":\"8\", \"orderpref4\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_4\":\"0.00000000\", \"exchanges\":\"12\", \"orderpref7\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"dfiller_45_10\":\"0.00000000\", \"filler_45_7\":\"0\", \"ordervalidity11\":\"1\", \"filler_45_17\":\"0\", \"ordervalidity2\":\"1\", \"executedquantity\":\"0\", \"lfiller_45_2\":\"\", \"listexchange8\":\"8\", \"dfiller_45_7\":\"0.00000000\", \"exchange11\":\"10\", \"listexchange3\":\"4\", \"lfiller_45_16\":\"\", \"exchange14\":\"0\", \"edge\":\"0.25000000\", \"ordervalidity13\":\"0\", \"lfiller_45_5\":\"\", \"filler_45_10\":\"0\", \"dfiller_45_18\":\"0.00000000\", \"lfiller_45_11\":\"\", \"listexchanges\":\"12\", \"listexchange12\":\"16\", \"orderpref11\":\"0000000000000000000000000000000000000000000000000000000000000000\", \"ordervalidity6\":\"1\", \"ordervalidities\":\"12\"} ] }, \"type\":\"response\", \"origrequestid\":1, \"success\":true }"

var eyebookJSON:JSON = JSON.parse("")

let strikesDemoString:String = "{\"origrequestid\":1,\"payload\":{\"ADTN:1917\":{\"11/18/2016\":{\"rows\":[{\"CallAsk1\":\"0.55\",\"CallBid1\":\"0.15\",\"CallDelta\":\"0.92039844\",\"CallInventory\":\"0\",\"CallPrice\":\"16.75\",\"CallPriceStatus\":6,\"Fv\":\"29.99960786\",\"Inventory\":\"0\",\"PutAsk1\":\"0.40\",\"PutBid1\":\"0.20\",\"PutDelta\":\"-0.07960681\",\"PutInventory\":\"0\",\"PutPrice\":\"16.82\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"20.00000000\"},{\"CallAsk1\":\"1.15\",\"CallBid1\":\"0.75\",\"CallDelta\":\"0.92299739\",\"CallInventory\":\"0\",\"CallPrice\":\"16.83\",\"CallPriceStatus\":6,\"Fv\":\"30.00055302\",\"Inventory\":\"0\",\"PutAsk1\":\"0.40\",\"PutBid1\":\"\",\"PutDelta\":\"-0.07700767\",\"PutInventory\":\"0\",\"PutPrice\":\"15.90\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"19.00000000\"},{\"CallAsk1\":\"2.20\",\"CallBid1\":\"1.60\",\"CallDelta\":\"0.92567113\",\"CallInventory\":\"0\",\"CallPrice\":\"16.91\",\"CallPriceStatus\":6,\"Fv\":\"30.00147800\",\"Inventory\":\"0\",\"PutAsk1\":\"0.20\",\"PutBid1\":\"\",\"PutDelta\":\"-0.07433420\",\"PutInventory\":\"0\",\"PutPrice\":\"14.99\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"18.00000000\"},{\"CallAsk1\":\"3.10\",\"CallBid1\":\"2.55\",\"CallDelta\":\"0.92843047\",\"CallInventory\":\"0\",\"CallPrice\":\"17.00\",\"CallPriceStatus\":6,\"Fv\":\"30.00238254\",\"Inventory\":\"0\",\"PutAsk1\":\"0.25\",\"PutBid1\":\"\",\"PutDelta\":\"-0.07157410\",\"PutInventory\":\"0\",\"PutPrice\":\"14.07\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"17.00000000\"},{\"CallAsk1\":\"4.30\",\"CallBid1\":\"3.20\",\"CallDelta\":\"0.93128662\",\"CallInventory\":\"0\",\"CallPrice\":\"17.09\",\"CallPriceStatus\":6,\"Fv\":\"30.00326627\",\"Inventory\":\"0\",\"PutAsk1\":\"0.45\",\"PutBid1\":\"\",\"PutDelta\":\"-0.06871814\",\"PutInventory\":\"0\",\"PutPrice\":\"13.16\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"16.00000000\"},{\"CallAsk1\":\"5.30\",\"CallBid1\":\"4.20\",\"CallDelta\":\"0.93424996\",\"CallInventory\":\"0\",\"CallPrice\":\"17.18\",\"CallPriceStatus\":6,\"Fv\":\"30.00412889\",\"Inventory\":\"0\",\"PutAsk1\":\"0.25\",\"PutBid1\":\"\",\"PutDelta\":\"-0.06575441\",\"PutInventory\":\"0\",\"PutPrice\":\"12.26\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"15.00000000\"},{\"CallAsk1\":\"6.30\",\"CallBid1\":\"5.10\",\"CallDelta\":\"0.93732851\",\"CallInventory\":\"0\",\"CallPrice\":\"17.28\",\"CallPriceStatus\":6,\"Fv\":\"30.00497014\",\"Inventory\":\"0\",\"PutAsk1\":\"0.30\",\"PutBid1\":\"\",\"PutDelta\":\"-0.06267593\",\"PutInventory\":\"0\",\"PutPrice\":\"11.36\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"14.00000000\"},{\"CallAsk1\":\"7.30\",\"CallBid1\":\"6.10\",\"CallDelta\":\"0.94052641\",\"CallInventory\":\"0\",\"CallPrice\":\"17.38\",\"CallPriceStatus\":6,\"Fv\":\"30.00578993\",\"Inventory\":\"0\",\"PutAsk1\":\"0.30\",\"PutBid1\":\"\",\"PutDelta\":\"-0.05947760\",\"PutInventory\":\"0\",\"PutPrice\":\"10.46\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"13.00000000\"},{\"CallAsk1\":\"10.10\",\"CallBid1\":\"7.10\",\"CallDelta\":\"0.94384294\",\"CallInventory\":\"0\",\"CallPrice\":\"17.49\",\"CallPriceStatus\":6,\"Fv\":\"30.00658828\",\"Inventory\":\"0\",\"PutAsk1\":\"0.20\",\"PutBid1\":\"\",\"PutDelta\":\"-0.05616120\",\"PutInventory\":\"0\",\"PutPrice\":\"9.56\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"12.00000000\"},{\"CallAsk1\":\"9.30\",\"CallBid1\":\"8.20\",\"CallDelta\":\"0.94727333\",\"CallInventory\":\"0\",\"CallPrice\":\"17.60\",\"CallPriceStatus\":6,\"Fv\":\"30.00736534\",\"Inventory\":\"0\",\"PutAsk1\":\"0.25\",\"PutBid1\":\"\",\"PutDelta\":\"-0.05273169\",\"PutInventory\":\"0\",\"PutPrice\":\"8.68\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"11.00000000\"},{\"CallAsk1\":\"0.15\",\"CallBid1\":\"\",\"CallDelta\":\"0.91786432\",\"CallInventory\":\"0\",\"CallPrice\":\"16.67\",\"CallPriceStatus\":6,\"Fv\":\"29.99864276\",\"Inventory\":\"0\",\"PutAsk1\":\"1.55\",\"PutBid1\":\"0.70\",\"PutDelta\":\"-0.08214222\",\"PutInventory\":\"0\",\"PutPrice\":\"17.74\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"21.00000000\"},{\"CallAsk1\":\"0.20\",\"CallBid1\":\"\",\"CallDelta\":\"0.91538593\",\"CallInventory\":\"0\",\"CallPrice\":\"16.59\",\"CallPriceStatus\":6,\"Fv\":\"29.99765983\",\"Inventory\":\"0\",\"PutAsk1\":\"2.55\",\"PutBid1\":\"1.55\",\"PutDelta\":\"-0.08461979\",\"PutInventory\":\"0\",\"PutPrice\":\"18.67\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"22.00000000\"},{\"CallAsk1\":\"0.10\",\"CallBid1\":\"\",\"CallDelta\":\"0.91295596\",\"CallInventory\":\"0\",\"CallPrice\":\"16.52\",\"CallPriceStatus\":6,\"Fv\":\"29.99666364\",\"Inventory\":\"0\",\"PutAsk1\":\"3.90\",\"PutBid1\":\"2.85\",\"PutDelta\":\"-0.08705096\",\"PutInventory\":\"0\",\"PutPrice\":\"19.59\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"23.00000000\"},{\"CallAsk1\":\"0.20\",\"CallBid1\":\"\",\"CallDelta\":\"0.91056903\",\"CallInventory\":\"0\",\"CallPrice\":\"16.45\",\"CallPriceStatus\":6,\"Fv\":\"29.99565982\",\"Inventory\":\"0\",\"PutAsk1\":\"4.90\",\"PutBid1\":\"3.70\",\"PutDelta\":\"-0.08943609\",\"PutInventory\":\"0\",\"PutPrice\":\"20.52\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"24.00000000\"},{\"CallAsk1\":\"0.25\",\"CallBid1\":\"\",\"CallDelta\":\"0.90822143\",\"CallInventory\":\"0\",\"CallPrice\":\"16.38\",\"CallPriceStatus\":6,\"Fv\":\"29.99465409\",\"Inventory\":\"0\",\"PutAsk1\":\"5.90\",\"PutBid1\":\"4.70\",\"PutDelta\":\"-0.09178437\",\"PutInventory\":\"0\",\"PutPrice\":\"21.45\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"25.00000000\"},{\"CallAsk1\":\"0.30\",\"CallBid1\":\"\",\"CallDelta\":\"0.90591081\",\"CallInventory\":\"0\",\"CallPrice\":\"16.31\",\"CallPriceStatus\":6,\"Fv\":\"29.99365173\",\"Inventory\":\"0\",\"PutAsk1\":\"6.90\",\"PutBid1\":\"5.70\",\"PutDelta\":\"-0.09409579\",\"PutInventory\":\"0\",\"PutPrice\":\"22.38\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"26.00000000\"},{\"CallAsk1\":\"0.30\",\"CallBid1\":\"\",\"CallDelta\":\"0.90363587\",\"CallInventory\":\"0\",\"CallPrice\":\"16.24\",\"CallPriceStatus\":6,\"Fv\":\"29.99265727\",\"Inventory\":\"0\",\"PutAsk1\":\"7.80\",\"PutBid1\":\"6.70\",\"PutDelta\":\"-0.09637016\",\"PutInventory\":\"0\",\"PutPrice\":\"23.32\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"27.00000000\"},{\"CallAsk1\":\"0.25\",\"CallBid1\":\"\",\"CallDelta\":\"0.90139609\",\"CallInventory\":\"0\",\"CallPrice\":\"16.18\",\"CallPriceStatus\":6,\"Fv\":\"29.99167437\",\"Inventory\":\"0\",\"PutAsk1\":\"8.90\",\"PutBid1\":\"7.70\",\"PutDelta\":\"-0.09860908\",\"PutInventory\":\"0\",\"PutPrice\":\"24.25\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"28.00000000\"},{\"CallAsk1\":\"0.25\",\"CallBid1\":\"\",\"CallDelta\":\"0.89919142\",\"CallInventory\":\"0\",\"CallPrice\":\"16.12\",\"CallPriceStatus\":6,\"Fv\":\"29.99070583\",\"Inventory\":\"0\",\"PutAsk1\":\"9.90\",\"PutBid1\":\"8.40\",\"PutDelta\":\"-0.10081424\",\"PutInventory\":\"0\",\"PutPrice\":\"25.19\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"29.00000000\"}]}}},\"success\":true,\"type\":\"response\"}"


//Date[0] Strk[1] CBid[2] CAsk[3] CTheo[4] Cpos[5] PBid[6] PAsk[7] PTheo[8] PPos[9], pDelta[10] cDelta[11] (12 total)

let xonData:NSArray = [["06/17/16", 20, 7.4, 11.6, 9.16, 0, 0, 0.2, 0.0090191984, -81,-0.5283484502, 100.0],
                       ["06/17/16", 21, 6.4, 10.6, 8.160028459, 0, 0, 0.25, 0.0192737981, 0,-1.0862216339, 99.9268857087],
                       ["06/17/16", 22, 5.5, 9.6, 7.1687611388, -10, 0, 0.25, 0.039092773, 156,-2.1141476529, 98.5544587447],
                       ["06/17/16", 23, 4.5, 8.6, 6.1974402883, 0, 0, 0.25, 0.0754634837, 0,-3.8989373447, 96.5212339718],
                       ["06/17/16", 24, 3.5, 7.6, 5.2554943743, -57, 0, 0.25, 0.1388304296, 2,-6.8095421444, 93.43136346],
                       ["06/17/16", 24.5, 3.1, 7.2, 4.7996358271, 0, 0, 0.3, 0.1849672826, 0,-8.8136527044, 91.3574293139],
                       ["06/17/16", 25, 3.3, 5.3, 4.3565390159, 3, 0.05, 0.35, 0.2435195187, -25,-11.2470674736, 88.8648699163],
                       ["06/17/16", 25.5, 3.4, 4.7, 3.9284667429, 0, 0.05, 0.45, 0.3168068198, 0,-14.1473505873, 85.9145754712],
                       ["06/17/16", 26, 3.2, 4.3, 3.5178002348, -25, 0.1, 0.5, 0.4072583397, 50,-17.5380189061, 82.4817063136],
                       ["06/17/16", 26.5, 2.85, 3.9, 3.1269443894, 0, 0.15, 0.45, 0.517319361, 0,-21.4235662127, 78.5606324433],
                       ["06/17/16", 27, 2.45, 3.5, 2.7582134046, 18, 0.4, 0.75, 0.6493380897, 1211,-25.7853403547, 74.1690273506],
                       ["06/17/16", 27.5, 2.1, 3.1, 2.4137044908, 0, 0.35, 0.95, 0.8054403372, 0,-30.5790489686, 69.3503389161],
                       ["06/17/16", 28, 1.8, 2.75, 2.0951706514, 50, 0.5, 0.95, 0.9874031174, 41,-35.7345723401, 64.1739575724],
                       ["06/17/16", 28.5, 1.5, 2.4, 1.8039055978, 0, 0.65, 1.5, 1.1965402503, 0,-41.1584973132, 58.7326668216],
                       ["06/17/16", 29, 1.25, 2.05, 1.5406540445, 61, 0.9, 1.8, 1.4336132451, 20,-46.7385379574, 53.1382093361],
                       ["06/17/16", 29.5, 1.1, 1.75, 1.305315783, 0, 1.1, 2.1, 1.698535854, 0,-52.2297262949, 47.6350847385],
                       ["06/17/16", 30, 0.85, 1.3, 1.0968779931, 192, 1.35, 2.5, 1.9903070171, -10,-57.5913229278, 42.2636922433],
                       ["06/17/16", 30.5, 0.7, 1.25, 0.9142887268, 0, 1.6, 2.8, 2.3078846147, 0,-62.7561418616, 37.0908459809],
                       ["06/17/16", 31, 0.55, 0.85, 0.7560925901, 57, 1.95, 2.85, 2.6498212331, 0,-67.6393831216, 32.2010284411],
                       ["06/17/16", 31.5, 0.4, 0.75, 0.6205050562, 0, 2.3, 3.2, 3.0143388127, 0,-72.174250501, 27.6607736834],
                       ["06/17/16", 32, 0.3, 0.45, 0.5055129131, -122, 2.6, 3.9, 3.3994293772, 0,-76.3138542174, 23.5167556169],
                       ["06/17/16", 32.5, 0.15, 0.55, 0.408974976, 0, 3, 4.2, 3.8029559774, 0,-80.0313027841, 19.7956883813],
                       ["06/17/16", 33, 0.15, 0.3, 0.3287152949, 73, 3.4, 4.6, 4.2227460874, 0,-83.3182578629, 16.5057649166],
                       ["06/17/16", 33.5, 0, 0.35, 0.2626031614, 0, 3.9, 5, 4.6566717669, 0,-86.1823603493, 13.6392253295],
                       ["06/17/16", 34, 0, 0.3, 0.2086165539, 68, 3.9, 5.5, 5.1027132318, 0,-88.6439861744, 11.1755964371],
                       ["06/17/16", 34.5, 0, 0.3, 0.1648878745, 0, 3.7, 6.4, 5.5590046931, 0,-90.7327670246, 9.0851671631],
                       ["06/17/16", 35, 0.1, 0.15, 0.1297326635, 82, 3.6, 7.8, 6.0238631544, 107,-92.4842358079, 7.3323398465],
                       ["06/17/16", 35.5, 0, 0.25, 0.101663287, 0, 4.1, 8.3, 6.4958021663, 0,-93.9368542089, 5.8786000179],
                       ["06/17/16", 36, 0, 0.25, 0.0793903475, 0, 4.5, 8.8, 6.9735332908, 0,-95.1295726816, 4.6849542082],
                       ["06/17/16", 36.5, 0, 0.25, 0.0618148417, 0, 5, 9.2, 7.4559583029, 0,-96.0999783762, 3.7137802163],
                       ["06/17/16", 37, 0, 0.25, 0.0480139836, -248, 5.5, 9.7, 7.9421550488, 0,-96.8830132737, 2.9301074944],
                       ["06/17/16", 37.5, 0, 0.25, 0.0372232606, -1285, 5.9, 10.2, 8.4313595298, 0,-97.5101962321, 2.3023938936],
                       ["06/17/16", 38, 0, 0.2, 0.0288168089, 0, 6.5, 10.7, 8.922946301, 0,-98.0092569591, 1.8028907056],
                       ["06/17/16", 39, 0, 0.5, 0.0172290813, 0, 7.5, 11.7, 9.9113403798, 0,-98.7148830894, 1.0965849789],
                       ["06/17/16", 40, 0, 0.1, 0.0102964705, -115, 8.5, 12.7, 10.9043850088, 0,-99.1487566684, 0.6622321465],
                       ["06/24/16", 29.5, 1.35, 2.5, 1.6728928974, 0, 1.55, 2.65, 2.1086566211, -3,-51.1151362821, 48.6438324272],
                       ["07/15/16", 15, 12.3, 16.5, 14.16, -6, 0, 0.25, 0.0190853458, 0,-0.6850570203, 100.0],
                       ["07/15/16", 20, 7.5, 11.6, 9.2451896153, 0, 0.05, 0.45, 0.214885325, 0,-6.006174176, 94.8464263468],
                       ["07/15/16", 21, 6.6, 10.8, 8.3282488267, 0, 0.1, 0.55, 0.3122944115, 0,-8.3152899554, 92.2334279451],
                       ["07/15/16", 22.5, 6.2, 8, 7.0197702268, 1, 0.25, 0.75, 0.5196426878, 0,-12.8508671587, 87.3531071795],
                       ["07/15/16", 24, 5.5, 8.1, 5.8077087662, 0, 0.5, 1.05, 0.8185090109, 0,-18.7544154931, 81.2005980474],
                       ["07/15/16", 25, 4.7, 6, 5.0620881865, -12, 0.7, 1.3, 1.0782113499, -94,-23.4342589959, 76.3934305556],
                       ["07/15/16", 26, 4.1, 5, 4.3718858695, 231, 0.95, 1.75, 1.3921419554, 0,-28.6477960367, 71.0762568147],
                       ["07/15/16", 27, 3.5, 4.3, 3.7407635925, 0, 1.35, 2.2, 1.7642068149, 0,-34.3022478605, 65.3372194165],
                       ["07/15/16", 28, 3, 3.9, 3.1711325045, -4, 1.65, 2.5, 2.1970084739, 37,-40.2736037439, 59.296693305],
                       ["07/15/16", 29, 2.6, 3.3, 2.6639507028, 28, 2.1, 2.9, 2.6916560803, 0,-46.40888051, 53.1047784491],
                       ["07/15/16", 30, 2.2, 2.4, 2.2180480854, -1328, 3.1, 3.5, 3.2470996751, 0,-52.4475234184, 47.0198235872],
                       ["07/15/16", 31, 1.35, 2.35, 1.830717599, 95, 3.2, 4.2, 3.8607293475, 0,-58.3198500408, 41.1097294431],
                       ["07/15/16", 32, 0.95, 1.95, 1.4985015544, 4, 3.7, 4.9, 4.5291650132, 6,-63.9012078907, 35.4975505822],
                       ["07/15/16", 33, 1, 1.25, 1.2170395725, -5, 4.4, 5.5, 5.2481079504, -10,-69.0903160433, 30.2832705943],
                       ["07/15/16", 34, 0.8, 1.1, 0.9813686033, 3, 5.1, 6.4, 6.0126441547, 9,-73.8153047945, 25.5377055144],
                       ["07/15/16", 35, 0.55, 1.05, 0.7862210729, 137, 5.9, 7.1, 6.8175451076, 102,-78.0344258528, 21.3017475147],
                       ["07/15/16", 36, 0.35, 0.85, 0.6262938839, 618, 6.7, 8.3, 7.6575388446, 0,-81.7338644637, 17.5885156472],
                       ["07/15/16", 37, 0.2, 0.7, 0.496469827, -40, 7.6, 9.1, 8.5275329988, 0,-84.9234788975, 14.3875863162],
                       ["07/15/16", 38, 0.1, 0.7, 0.3919823718, 0, 8.4, 10, 9.4227808851, 0,-87.6313987342, 11.6703706153],
                       ["07/15/16", 39, 0.05, 0.5, 0.3085231447, -9, 9.1, 11.1, 10.3389900017, 0,-89.8983407583, 9.3957786057],
                       ["07/15/16", 40, 0.1, 0.4, 0.2422976157, -32, 8.9, 13, 11.2723785296, 0,-91.7723119848, 7.5155001504],
                       ["07/15/16", 41, 0, 0.35, 0.1900382822, 0, 9.9, 14, 12.2196891601, 0,-93.3041317706, 5.9784696575],
                       ["07/15/16", 42, 0, 0.5, 0.1489861325, 0, 10.7, 15, 13.1781710697, 0,-94.5439759139, 4.7343112787],
                       ["07/15/16", 43, 0, 0.25, 0.1168509173, 1, 11.7, 15.9, 14.1455405985, 0,-95.538961246, 3.7357456086],
                       ["07/15/16", 44, 0, 0.25, 0.0917593801, 60, 12.7, 16.9, 15.1199298024, -36,-96.3316643804, 2.9400638557],
                       ["07/15/16", 45, 0, 0.25, 0.072198672, 143, 13.8, 17.9, 16.0998301245, 0,-96.9594014067, 2.3098423974],
                       ["07/15/16", 46, 0, 0.25, 0.0569601544, 0, 14.7, 18.8, 17.0840364015, 0,-97.4540750363, 1.8130909682],
                       ["07/15/16", 47, 0, 0.25, 0.045086968, 0, 15.7, 19.8, 18.0715945951, 0,-97.8424070992, 1.4230163801],
                       ["07/15/16", 48, 0, 0.2, 0.0358272559, 0, 16.7, 20.8, 19.0617551434, 0,-98.146403202, 1.1175548009],
                       ["07/15/16", 49, 0, 0.15, 0.0285938194, 0, 17.7, 21.7, 20.0539327206, 0,-98.3839317111, 0.87879029],
                       ["07/15/16", 50, 0, 0.15, 0.0229302336, 0, 18.7, 22.8, 21.0476724341, -24,-98.5693336635, 0.6923428815],
                       ["07/15/16", 55, 0, 0.1, 0.0082490536, -3, 23.7, 27.7, 26.0299290714, 0,-99.0384738341, 0.2198957468],
                       ["07/15/16", 60, 0, 0.1, 0.0034215154, 0, 28.7, 32.7, 31.0219656337, 0,-99.1790147575, 0.0778119711],
                       ["10/21/16", 20, 9.8, 11.3, 10.1266735789, 0, 0.05, 4.5, 1.4601876232, 0,-16.887246852, 82.7223000832],
                       ["10/21/16", 21, 9.1, 10.6, 9.4013469421, 0, 1.3, 2.4, 1.7504218885, 0,-19.4410795908, 79.9442701393],
                       ["10/21/16", 22, 7.6, 11.1, 8.7108743948, 0, 0.05, 4.5, 2.0730303574, 0,-22.1340500813, 77.0584204492],
                       ["10/21/16", 23, 7.7, 9.3, 8.0553457473, 0, 1.95, 2.85, 2.4285195581, 0,-24.9494692653, 74.0759937458],
                       ["10/21/16", 24, 5.9, 10, 7.4347225407, 0, 2.35, 3.3, 2.8171837473, 0,-27.8695034546, 71.0105131537],
                       ["10/21/16", 25, 6.5, 8.1, 6.8488245904, 0, 2.75, 3.7, 3.2391111337, 0,-30.8754111956, 67.8772732098],
                       ["10/21/16", 26, 4.7, 8.6, 6.2973230857, 0, 3.2, 4.2, 3.6941914681, 0,-33.9477900775, 64.6928938439],
                       ["10/21/16", 27, 5.4, 7, 5.7797388161, -4, 3.6, 4.7, 4.1821250783, 0,-37.0668356745, 61.4749136526],
                       ["10/21/16", 28, 4.9, 6.5, 5.2954445542, 0, 4.1, 5.2, 4.7024334096, 0,-40.212612248, 58.241408222],
                       ["10/21/16", 29, 4.5, 6, 4.8436299483, 0, 4.7, 5.8, 5.254430224, 0,-43.3476811867, 55.0283172881],
                       ["10/21/16", 30, 4, 5.6, 4.4230777045, -50, 5.2, 6.4, 5.837003462, 0,-46.4426258372, 51.8638811961],
                       ["10/21/16", 31, 3.6, 5.2, 4.0326265376, -5, 5.8, 7, 6.4490811982, 0,-49.4966139229, 48.7478345826],
                       ["10/21/16", 32, 3.2, 4.8, 3.6710694754, -10, 6.4, 7.6, 7.08953238, 0,-52.4931207462, 45.6957768234],
                       ["10/21/16", 33, 3.1, 4, 3.337123148, 0, 7, 8.2, 7.7571384785, 0,-55.4172437345, 42.7218215406],
                       ["10/21/16", 34, 2.5, 4, 3.0294456135, 0, 6.3, 8.9, 8.4506131771, 0,-58.2558294738, 39.8384459622],
                       ["10/21/16", 35, 2.2, 3.7, 2.7466538022, 0, 8.4, 10.2, 9.1686213214, 0,-60.9975540017, 37.0563916966],
                       ["10/21/16", 36, 1.95, 3.4, 2.4873402124, 0, 7.7, 11.6, 9.9097968392, 0,-63.6329579846, 34.3846142651],
                       ["10/21/16", 37, 1.7, 3.1, 2.2500885545, 0, 8.5, 11.6, 10.6727593872, 0,-66.1544397185, 31.8302776744],
                       ["10/21/16", 38, 1.5, 2.85, 2.0334881124, 0, 10.4, 12, 11.4561295371, 0,-68.5562099912, 29.398789391],
                       ["10/21/16", 39, 1.3, 2.6, 1.8361466473, 0, 11.1, 12.8, 12.2585423645, 0,-70.8342136922, 27.0938703714],
                       ["10/21/16", 40, 1.15, 2.4, 1.6567017367, 8, 12.1, 13.6, 13.0786593565, 0,-72.9860236352, 24.9176543242],
                       ["10/21/16", 41, 0.95, 2.2, 1.4938304902, 0, 12.9, 14.4, 13.915178605, 0,-75.0107123641, 22.8708101525],
                       ["10/21/16", 42, 0.85, 2.05, 1.3462576378, 0, 13.7, 15.2, 14.7668432969, 0,-76.9087077622, 20.9526815361],
                       ["10/21/16", 43, 0.7, 1.85, 1.212762028, 0, 13.3, 17, 15.6324485501, 0,-78.6816381024, 19.1614378417],
                       ["10/21/16", 44, 0.6, 1.7, 1.092181606, 0, 15.4, 17, 16.5108466807, 0,-80.3321718026, 17.4942309576],
                       ["10/21/16", 45, 0.5, 1.6, 0.9834169745, 30, 15.1, 18, 17.4009510088, 0,-81.863856622, 15.9473532035],
                       ["10/21/16", 46, 0.4, 1.45, 0.8854336581, 0, 17.2, 18.8, 18.3017383332, 0,-83.2809624068, 14.5163921216],
                       ["10/21/16", 47, 0.35, 1.35, 0.7972632067, 0, 18.1, 19.7, 19.2122502143, 0,-84.5883307955, 13.1963786623],
                       ["10/21/16", 48, 0.25, 1.25, 0.7180032812, 0, 19, 21.1, 20.131593216, 0,-85.7912345806, 11.981926011],
                       ["10/21/16", 49, 0.2, 1.15, 0.6468168673, 0, 19.9, 22, 21.0589382537, 0,-86.8952487205, 10.8673570136],
                       ["10/21/16", 50, 0.15, 1.05, 0.5829307616, 5, 20.8, 22.6, 21.9935191959, 0,-87.9061343319, 9.846818831],
                       ["10/21/16", 55, 0.2, 0.75, 0.3501093905, 20, 25.3, 27.7, 26.7522662347, 0,-91.7665739385, 5.9490372426],
                       ["10/21/16", 60, 0, 0.5, 0.2158653224, 4, 29.3, 33.2, 31.608693868, 0,-94.1288206405, 3.5625738559],
                       ["01/20/17", 20, 10.6, 12.3, 10.9295570929, -108, 1.95, 3.4, 2.5287788208, 0,-20.1327624336, 78.5349990487],
                       ["01/20/17", 21, 10, 11.6, 10.2898686286, 0, 2.35, 3.8, 2.9046658515, 0,-22.308679164, 76.1438163157],
                       ["01/20/17", 22.5, 8.1, 11.8, 9.3853536439, 0, 2.95, 4.1, 3.5190466993, 0,-25.6664251992, 72.5095758165],
                       ["01/20/17", 24, 8.2, 9.9, 8.5447195899, 0, 3.6, 4.8, 4.1929619514, 0,-29.110541651, 68.8336140188],
                       ["01/20/17", 25, 7.7, 9, 8.0186001448, -18, 4.1, 5.7, 4.6745659986, -1,-31.4406020854, 66.3690714802],
                       ["01/20/17", 26, 7.2, 8.9, 7.5190841471, 0, 4.5, 5.8, 5.1814343849, 0,-33.7884365223, 63.9002453997],
                       ["01/20/17", 27, 6.7, 8.5, 7.0454404373, -1, 5.1, 6.4, 5.7130049799, 0,-36.1462629718, 61.4331353205],
                       ["01/20/17", 28, 6.2, 8, 6.5969250753, 0, 5.6, 6.9, 6.268676238, 0,-38.5065503048, 58.9737843162],
                       ["01/20/17", 29, 5.9, 7.6, 6.1727318219, -10, 6.2, 7.5, 6.8477629715, 0,-40.8493400078, 56.5409751155],
                       ["01/20/17", 30, 6, 7.2, 5.7719526175, -70, 6.7, 8.1, 7.4494612402, 0,-43.1709987757, 54.137305909],
                       ["01/20/17", 31, 4.9, 6.8, 5.3937397787, -1, 7.3, 8.7, 8.0730127567, 0,-45.4672619099, 51.7661353061],
                       ["01/20/17", 32, 4.5, 6.4, 5.037239596, 0, 8, 9.4, 8.7176411017, 0,-47.7316868006, 49.4331373457],
                       ["01/20/17", 33, 4.2, 6, 4.7015925353, 0, 8.6, 10, 9.3825539023, 0,-49.9583432259, 47.1435787081],
                       ["01/20/17", 34, 3.8, 5.7, 4.3859365444, 0, 9.3, 10.7, 10.0669477328, 0,-52.1418263429, 44.9022885794],
                       ["01/20/17", 35, 3.5, 5.4, 4.0894103759, -21, 9.9, 11.6, 10.7700127398, -1,-54.2772653766, 42.7136360319],
                       ["01/20/17", 36, 2.1, 6, 3.8111568571, 0, 10.6, 12.2, 11.490936984, 0,-56.3603277905, 40.5815144623],
                       ["01/20/17", 37, 1.9, 6, 3.5503260549, 0, 11.3, 13, 12.2289104914, 0,-58.3872188389, 38.509332672],
                       ["01/20/17", 38, 1.5, 5.8, 3.3060782886, 0, 10.8, 13.7, 12.9831290044, 0,-60.3546765146, 36.5000121719],
                       ["01/20/17", 39, 2.4, 4.2, 3.0775869569, 0, 12.8, 14.4, 13.7527974251, 0,-62.2599620171, 34.5559902748],
                       ["01/20/17", 40, 2.2, 3.4, 2.8640411488, -50, 13.5, 15.2, 14.5371329468, 0,-64.100845966, 32.6792285018],
                       ["01/20/17", 41, 2, 3.8, 2.6646480191, 0, 14.3, 16, 15.3353678672, 0,-65.8755906692, 30.8712257988],
                       ["01/20/17", 42, 1.8, 3.5, 2.4786349123, 5, 15.1, 16.8, 16.1467520857, 0,-67.5829288325, 29.133036021],
                       ["01/20/17", 43, 1.65, 3.3, 2.3052512266, 0, 15.9, 17.6, 16.9705552846, 0,-69.2220391504, 27.4652891185],
                       ["01/20/17", 44, 1.5, 3.1, 2.1437700132, 0, 16.7, 18.5, 17.8060688011, 0,-70.7925192618, 25.8682154419],
                       ["01/20/17", 45, 1.35, 2.95, 1.9934893123, 69, 17.5, 19.3, 18.6526071973, 0,-72.2943565772, 24.3416725768],
                       ["01/20/17", 46, 1.2, 2.75, 1.8537332299, 0, 18.4, 20.7, 19.5095095392, 0,-73.7278974961, 22.8851741234],
                       ["01/20/17", 47, 1.1, 2.6, 1.7238527639, -5, 19.2, 21.5, 20.3761403975, 0,-75.0938155268, 21.4979198544],
                       ["01/20/17", 48, 0.95, 2.45, 1.6032263903, 0, 20, 22, 21.2518905872, 0,-76.3930788072, 20.1788267088],
                       ["01/20/17", 49, 0.85, 2.3, 1.4912604239, 0, 20.9, 22.9, 22.1361776604, 0,-77.6269174936, 18.9265601153],
                       ["01/20/17", 50, 1, 2, 1.3873891682, -1, 21.8, 23.8, 23.0284461728, 0,-78.7967914535, 17.7395651816],
                       ["01/20/17", 55, 0.5, 1.55, 0.9715938276, 5, 25.3, 29.2, 27.5919523906, 0,-83.7499793255, 12.7175946622],
                       ["01/20/17", 60, 0.15, 1.25, 0.688893614, 75, 30.1, 33.8, 32.2868426638, 0,-87.403559749, 9.017638037],
                       ["01/20/17", 65, 0.05, 1.5, 0.49730692, 1, 34.9, 38.4, 37.071751334, 0,-90.0362757556, 6.355469674],
                       ["01/20/17", 70, 0.05, 4.5, 0.3672158882, 1, 39.7, 43.4, 41.9174851141, 0,-91.9057058316, 4.4699210344],
                       ["01/20/17", 75, 0.15, 0.6, 0.27832773, 0, 44.5, 48.2, 46.8040544806, 0,-93.2248571658, 3.1456208472],
                       ["01/20/17", 80, 0, 0.5, 0.2170144613, 0, 49.5, 53, 51.7180558756, 0,-94.1574380931, 2.2172912214],
                       ["01/20/17", 85, 0, 0.4, 0.1742314241, 0, 54.3, 58, 56.6506163408, 0,-94.8230957788, 1.5642139228],
                       ["01/20/17", 90, 0, 4.6, 0.1440037008, 0, 59.3, 63.1, 61.5958959946, 0,-95.306277047, 1.1011589311],
                       ["01/20/17", 95, 0, 0.3, 0.1223782686, 0, 64.3, 67.9, 66.5500499433, 0,-95.665145418, 0.7693162533],
                       ["01/19/18", 20, 12.5, 15.6, 13.5211678009, 0, 4.5, 6.5, 5.3643719572, -38,-21.2030651939, 75.4859711154],
                       ["01/19/18", 22.5, 11.3, 14.5, 12.3502031785, 0, 4.7, 8, 6.6930858916, 0,-24.6582388078, 71.7164267961],
                       ["01/19/18", 25, 10.3, 13.5, 11.2854612525, 0, 7, 8.4, 8.1195463057, 0,-28.0735916682, 68.0532609494],
                       ["01/19/18", 30, 7.9, 11, 9.4312251858, 0, 10, 13.2, 11.2307802951, 0,-34.7479153948, 61.0186048956],
                       ["01/19/18", 35, 6.4, 8.8, 7.8882056735, 0, 13.3, 16.4, 14.6389428354, 0,-41.1322052819, 54.3945177837],
                       ["01/19/18", 37, 6.8, 8.8, 7.3458611438, 0, 14.7, 17.8, 16.0744711924, 0,-43.5898842437, 51.8650690681],
                       ["01/19/18", 40, 6, 8, 6.6034579609, 0, 16.9, 20, 18.29690677, 0,-47.1643559916, 48.2035682904],
                       ["01/19/18", 42, 5.6, 7.6, 6.1522022671, 0, 18.4, 21.5, 19.8211788861, 0,-49.4690102166, 45.8529327658],
                       ["01/19/18", 45, 4.9, 7, 5.535030736, 0, 20.6, 24.2, 22.1661416304, 0,-52.8031721954, 42.4656149168],
                       ["01/19/18", 47, 3.5, 7.1, 5.1602952291, 0, 22.2, 25.7, 23.7655765145, 0,-54.9414987655, 40.3013855993],
                       ["01/19/18", 50, 2.9, 6.6, 4.6483848216, 0, 24.6, 28.1, 26.2143083142, 0,-58.0188859613, 37.1980850427],
                       ["01/19/18", 55, 2.3, 5.1, 3.9144195822, 0, 28.7, 32.4, 30.4138244181, 0,-62.7938779449, 32.4109993623],
                       ["01/19/18", 60, 1.7, 5, 3.3083455027, 0, 32.7, 36.6, 34.741006668, 0,-67.1232353803, 28.1042461723],
                       ["01/19/18", 65, 1.2, 4.3, 2.8089863947, 0, 37.1, 41, 39.1755173715, 0,-71.0142653678, 24.2668674835],
                       ["01/19/18", 70, 0.85, 3.8, 2.3982962354, 0, 42, 45.4, 43.6999621319, 0,-74.4849247468, 20.8779199697],
                       ["01/19/18", 75, 0.6, 3.4, 2.0609797547, 0, 46.2, 50, 48.2995574007, 0,-77.5614898928, 17.9083694303]]

