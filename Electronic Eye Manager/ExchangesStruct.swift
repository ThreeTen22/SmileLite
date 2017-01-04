//
//  ExchangesStruct.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/13/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import Foundation


//typealias ExInfo = (nameIndx:Int, orderValidity:Int)

struct ExInfo:Equatable {
    var nameIndx:Int
    var orderValidity:Int
    var orderPref:Int
    
    init(_ n:Int,_ o:Int, t:Int = 2) {
     nameIndx = n
     orderValidity = o
     orderPref = t
    }
}

func ==(lhs:ExInfo, rhs:ExInfo) -> Bool {
    return (lhs.nameIndx == rhs.nameIndx) && (lhs.orderValidity == rhs.orderValidity)
}

func !=(lhs:ExInfo, rhs:ExInfo) -> Bool {
    return (lhs.nameIndx != rhs.nameIndx) || (lhs.orderValidity != rhs.orderValidity)
}

struct Exchanges:Equatable {
    var exchange1:ExInfo = ExInfo(2,1)
    var exchange2:ExInfo = ExInfo(3,1)
    var exchange3:ExInfo = ExInfo(4,1)
    var exchange4:ExInfo = ExInfo(5,1)
    var exchange5:ExInfo = ExInfo(1,1)
    var exchange6:ExInfo = ExInfo(6,1)
    var exchange7:ExInfo = ExInfo(7,1)
    var exchange8:ExInfo = ExInfo(8,1)
    var exchange9:ExInfo = ExInfo(9,1)
    var exchange10:ExInfo = ExInfo(12,1)
    var exchange11:ExInfo = ExInfo(10,1)
    var exchange12:ExInfo = ExInfo(16,1)
    var exchange13:ExInfo = ExInfo(0,0)
    var exchange14:ExInfo = ExInfo(0,0)
    var exchange15:ExInfo = ExInfo(0,0)
    
    private var exchanges:Int = 12
    private var listExchanges:Int = 12
    private var orderValidities:Int = 12
    private var orderPrefs:Int = 12
    
    subscript(index:Int) -> ExInfo {
        get {
            switch index {
            case 1:
                return exchange1
            case 2:
                return exchange2
            case 3:
                return exchange3
            case 4:
                return exchange4
            case 5:
                return exchange5
            case 6:
                return exchange6
            case 7:
                return exchange7
            case 8:
                return exchange8
            case 9:
                return exchange9
            case 10:
                return exchange10
            case 11:
                return exchange11
            case 12:
                return exchange12
            case 13:
                return exchange13
            case 14:
                return exchange14
            case 15:
                return exchange15
            default:
                assertionFailure("Get: Provided Exchange Number Out of Bounds")
                return exchange15
            }
        }
        set(newValue) {
            switch index {
            case 1:
                exchange1 = newValue
            case 2:
                exchange2 = newValue
            case 3:
                exchange3 = newValue
            case 4:
                exchange4 = newValue
            case 5:
                exchange5 = newValue
            case 6:
                exchange6 = newValue
            case 7:
                exchange7 = newValue
            case 8:
                exchange8 = newValue
            case 9:
                exchange9 = newValue
            case 10:
                exchange10 = newValue
            case 11:
                exchange11 = newValue
            case 12:
                exchange12 = newValue
            case 13:
                exchange13 = newValue
            case 14:
                exchange14 = newValue
            case 15:
                exchange15 = newValue
            default:
                assertionFailure("Set: Provided Exchange Number Out of Bounds")
                break
            }
            
        }
    }
    
    subscript(isActiveExchange index:Int) -> Bool {
        get {
            switch index {
            case 1:
                return exchange1.orderValidity.isNotZero()
            case 2:
                return exchange2.orderValidity.isNotZero()
            case 3:
                return exchange3.orderValidity.isNotZero()
            case 4:
                return exchange4.orderValidity.isNotZero()
            case 5:
                return exchange5.orderValidity.isNotZero()
            case 6:
                return exchange6.orderValidity.isNotZero()
            case 7:
                return exchange7.orderValidity.isNotZero()
            case 8:
                return exchange8.orderValidity.isNotZero()
            case 9:
                return exchange9.orderValidity.isNotZero()
            case 10:
                return exchange10.orderValidity.isNotZero()
            case 11:
                return exchange11.orderValidity.isNotZero()
            case 12:
                return exchange12.orderValidity.isNotZero()
            case 13:
                return exchange13.orderValidity.isNotZero()
            case 14:
                return exchange14.orderValidity.isNotZero()
            case 15:
                return exchange15.orderValidity.isNotZero()
            default:
                assertionFailure("Get: Provided Exchange Number Out of Bounds \(index)")
                return exchange15.orderValidity.isNotZero()
            }
        }
        set(newValue) {
            switch index {
            case 1:
                exchange1.orderValidity = newValue.hashValue
            case 2:
                exchange2.orderValidity = newValue.hashValue
            case 3:
                exchange3.orderValidity = newValue.hashValue
            case 4:
                exchange4.orderValidity = newValue.hashValue
            case 5:
                exchange5.orderValidity = newValue.hashValue
            case 6:
                exchange6.orderValidity = newValue.hashValue
            case 7:
                exchange7.orderValidity = newValue.hashValue
            case 8:
                exchange8.orderValidity = newValue.hashValue
            case 9:
                exchange9.orderValidity = newValue.hashValue
            case 10:
                exchange10.orderValidity = newValue.hashValue
            case 11:
                exchange11.orderValidity = newValue.hashValue
            case 12:
                exchange12.orderValidity = newValue.hashValue
            case 13:
                exchange13.orderValidity = newValue.hashValue
            case 14:
                exchange14.orderValidity = newValue.hashValue
            case 15:
                exchange15.orderValidity = newValue.hashValue
            default:
                assertionFailure("Set: Provided Exchange Number Out of Bounds")
                break
            }
            
        }
    }
    
    
    init() {
        
    }
    
    init(nameIndx e1:Int, e2:Int, e3:Int, e4:Int, e5:Int, e6:Int, e7:Int, e8:Int, e9:Int, e10:Int, e11:Int, e12:Int, e13:Int, e14:Int, e15:Int) {
        
        exchange1 =  ExInfo(e1, 0)
        exchange2 =  ExInfo(e2, 0)
        exchange3 =  ExInfo(e3, 0)
        exchange4 =  ExInfo(e4, 0)
        exchange5 =  ExInfo(e5, 0)
        exchange6 =  ExInfo(e6, 0)
        exchange7 =  ExInfo(e7, 0)
        exchange8 =  ExInfo(e8, 0)
        exchange9 =  ExInfo(e9, 0)
        exchange10 = ExInfo(e10, 0)
        exchange11 = ExInfo(e11, 0)
        exchange12 = ExInfo(e12, 0)
        exchange13 = ExInfo(e13, 0)
        exchange14 = ExInfo(e14, 0)
        exchange15 = ExInfo(e15, 0)
        updateCounts()
        
    }
    init(map:[ExInfo]) {
        
        exchange1 = map[1]
        exchange2 = map[2]
        exchange3 = map[3]
        exchange4 = map[4]
        exchange5 = map[5]
        exchange6 = map[6]
        exchange7 = map[7]
        exchange8 = map[8]
        exchange9 = map[9]
        exchange10 = map[10]
        exchange11 = map[11]
        exchange12 = map[12]
        exchange13 = map[13]
        exchange14 = map[14]
        exchange15 = map[15]
        updateCounts()
    }
    
    init(Full e1:ExInfo, e2:ExInfo, e3:ExInfo, e4:ExInfo, e5:ExInfo, e6:ExInfo, e7:ExInfo, e8:ExInfo, e9:ExInfo, e10:ExInfo, e11:ExInfo, e12:ExInfo, e13:ExInfo, e14:ExInfo, e15:ExInfo) {
        
        exchange1 = e1
        exchange2 = e2
        exchange3 = e3
        exchange4 = e4
        exchange5 = e5
        exchange6 = e6
        exchange7 = e7
        exchange8 = e8
        exchange9 = e9
        exchange10 = e10
        exchange11 = e11
        exchange12 = e12
        exchange13 = e13
        exchange14 = e14
        exchange15 = e15
        updateCounts()
    }
    
    init(fromEyeJson eye:JSON) {
        exchanges = eye["exchanges"].intValue
        orderPrefs = eye["ordervalidities"].intValue
        orderValidities = eye["orderprefs"].intValue
        listExchanges = eye["listexchanges"].intValue
        
        
        
        //Get Listing Names
        exchange1.nameIndx = eye["listexchange1"].intValue
        exchange2.nameIndx = eye["listexchange2"].intValue
        exchange3.nameIndx = eye["listexchange3"].intValue
        exchange4.nameIndx = eye["listexchange4"].intValue
        exchange5.nameIndx = eye["listexchange5"].intValue
        exchange6.nameIndx = eye["listexchange6"].intValue
        exchange7.nameIndx = eye["listexchange7"].intValue
        exchange8.nameIndx = eye["listexchange8"].intValue
        exchange9.nameIndx = eye["listexchange9"].intValue
        exchange10.nameIndx = eye["listexchange10"].intValue
        exchange11.nameIndx = eye["listexchange11"].intValue
        exchange12.nameIndx = eye["listexchange12"].intValue
        exchange13.nameIndx = eye["listexchange13"].intValue
        exchange14.nameIndx = eye["listexchange14"].intValue
        exchange15.nameIndx = eye["listexchange15"].intValue
        
        //getOrderTypes:
        exchange1.orderValidity = eye["ordervalidity1"].intValue
        exchange2.orderValidity = eye["ordervalidity2"].intValue
        exchange3.orderValidity = eye["ordervalidity3"].intValue
        exchange4.orderValidity = eye["ordervalidity4"].intValue
        exchange5.orderValidity = eye["ordervalidity5"].intValue
        exchange6.orderValidity = eye["ordervalidity6"].intValue
        exchange7.orderValidity = eye["ordervalidity7"].intValue
        exchange8.orderValidity = eye["ordervalidity8"].intValue
        exchange9.orderValidity = eye["ordervalidity9"].intValue
        exchange10.orderValidity = eye["ordervalidity10"].intValue
        exchange11.orderValidity = eye["ordervalidity11"].intValue
        exchange12.orderValidity = eye["ordervalidity12"].intValue
        exchange13.orderValidity = eye["ordervalidity13"].intValue
        exchange14.orderValidity = eye["ordervalidity14"].intValue
        exchange15.orderValidity = eye["ordervalidity15"].intValue
        //get isActive
        
        exchange1.orderPref =  eye["orderpref1"].intValue
        exchange2.orderPref =  eye["orderpref2"].intValue
        exchange3.orderPref =  eye["orderpref3"].intValue
        exchange4.orderPref =  eye["orderpref4"].intValue
        exchange5.orderPref =  eye["orderpref5"].intValue
        exchange6.orderPref =  eye["orderpref6"].intValue
        exchange7.orderPref =  eye["orderpref7"].intValue
        exchange8.orderPref =  eye["orderpref8"].intValue
        exchange9.orderPref =  eye["orderpref9"].intValue
        exchange10.orderPref = eye["orderpref10"].intValue
        exchange11.orderPref = eye["orderpref11"].intValue
        exchange12.orderPref = eye["orderpref12"].intValue
        exchange13.orderPref = eye["orderpref13"].intValue
        exchange14.orderPref = eye["orderpref14"].intValue
        exchange15.orderPref = eye["orderpref15"].intValue
        
        updateCounts()
    }
    func printExchanges() {
        print(exchange1)
        print(exchange2)
        print(exchange3)
        print(exchange4)
        print(exchange5)
        print(exchange6)
        print(exchange7)
        print(exchange8)
        print(exchange9)
        print(exchange10)
        print(exchange11)
        print(exchange12)
        print(exchange13)
        print(exchange14)
        print(exchange15)
    }

}



func ==(left:Exchanges, right:Exchanges) -> Bool {
    let leftMap = left.map()
    let rightMap = right.map()
    
    
    for (indx,leftElement) in leftMap.enumerate() {
        if leftElement != rightMap[indx] {
            return false
        }
    }
    return true
}

func !=(left:Exchanges, right:Exchanges) -> Bool {
    let leftMap = left.map()
    let rightMap = right.map()
    for (indx,leftElement) in leftMap.enumerate() {
        if leftElement != rightMap[indx] {
            return true
        }
    }
    return false
}

extension Exchanges {
    var visibleExchangeCount:Int {
        get {
            return orderValidities
        }
    }
    /*
    subscript(isActive index:Int) -> Bool {
        get {
            return self[index].orderValidity.isNotZero()
        }
        mutating set {
            var newExchange = self[index]
            print(newExchange)
            newExchange.orderValidity = newValue.hashValue
            self[index] = newExchange
            print(self[index])
        }
    }
    */
    
    subscript(mappedIndx index:Int) -> ExInfo {
        get {
            return self[index+1]
        }
    }
    
    subscript(namedIndx index:Int) -> Int {
        get {
            return self[index].nameIndx
        }
    }
    
    mutating func updateCounts() {
        var exchanges:Int = 0
        var listExchanges:Int = 0
        var orderValidities:Int = 0
        var orderPrefs:Int = 0
        let exchangesArray = self.map()
        
        for ex in exchangesArray {
            if ex.nameIndx.isNotZero() {
                listExchanges += 1
                orderPrefs += 1
            }
            if ex.orderValidity.isNotZero() {
                orderValidities += 1
                exchanges += 1
            }
        }
        
        if listExchanges != self.listExchanges {
            self.listExchanges = listExchanges
            self.orderPrefs = orderPrefs
        }
        
        if exchanges != self.exchanges {
            self.exchanges = exchanges
            self.orderValidities = orderValidities
        }
        
    }
    
    
    func map() -> [ExInfo] {
        return [
            exchange1,
            exchange2,
            exchange3,
            exchange4,
            exchange5,
            exchange6,
            exchange7,
            exchange8,
            exchange9,
            exchange10,
            exchange11,
            exchange12,
            exchange13,
            exchange14,
            exchange15
        ]
    }
    
    
    static func exchangeNames(exchangeNum:Int) ->String {
        
        switch exchangeNum {
        case 1:
            return "Amex"
        case 2:
            return "Cboe"
        case 3:
            return "Ise"
        case 4:
            return "PCoast"
        case 5:
            return "Phlx"
        case 6:
            return "Box"
        case 7:
            return "Nasdaq"
        case 8:
            return "Bats"
        case 9:
            return "C2"
        case 10:
            return "Miax"
        case 11:
            return "Unknown11"
        case 12:
            return "Nasdaq-Bx"
        case 13:
            return "Unknown13"
        case 14:
            return "Unknown14"
        case 15:
            return "Unknown15"
        case 16:
            return "Edgx"
        default:
            return "OutOfBounds"
        }
    }
}


