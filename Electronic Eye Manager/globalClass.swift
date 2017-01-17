//
//  globalVars.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/7/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

var eyeBook:EyeBook = EyeBook()
var eyebookJSON:JSON = JSON(nilLiteral: ())

var usingDemo = false

var xonDemoData:Array = [String]()

//var currentStrikeEye:StrikeEye = StrikeEye(symbol: "XON", expDate: "06/27/16", strikePrice: 37.5, priceOverride: 0, quantityOverride: 0)

//will use the keyboard when inputting
var bWillUseKeyboard = false

let smileDateFormat:NSDateFormatter = {
    let newSmileDate = NSDateFormatter()
    newSmileDate.dateFormat = "MM/dd/yy"
    return newSmileDate
}()


var xonListingArray:Array = [String]()

var client:TCPClient = TCPClient(addr: "jdempseylxdt05", port: 9400)
var (clientSuccess, clientErrmsg) = (false, "HAVENT CONNECTED")

let timeout:Int = 1

enum FilterType {
    case all
    case listing
}

enum StrikeType {
    
    case buycallmonthqe
    case buycallstrikeqe
    case buyputmonthqe
    case buyputstrikeqe
    case calldelta
    case callinventory
    case callposition
    case calltheo
    case callvolume
    case defaultcell
    case inventory
    case maturity
    case position
    case putdelta
    case putinventory
    case putposition
    case puttheo
    case putvolume
    case sellcallmonthqe
    case sellcallstrikeqe
    case sellputmonthqe
    case sellputstrikeqe
    case strike
    case title
    case null
    
}

struct StrikeCellOrder {
    
    static var visibleCellPositionIndx:[StrikeType] = [.maturity,
                                      .strike,
                                      .buycallmonthqe,
                                      .buycallstrikeqe,
                                      .calltheo,
                                      .calldelta,
                                      .callinventory,
                                      .sellcallstrikeqe,
                                      .sellcallmonthqe,
                                      .defaultcell,
                                      .buyputmonthqe,
                                      .buyputstrikeqe,
                                      .puttheo,
                                      .putdelta,
                                      .putinventory,
                                      .sellputstrikeqe,
                                      .sellputmonthqe,
                                      .inventory]
    
    static var allStrikes:[StrikeType] = [.maturity,
                                      .strike,
                                      .buycallmonthqe,
                                      .buycallstrikeqe,
                                      .calltheo,
                                      .calldelta,
                                      .callinventory,
                                      .sellcallstrikeqe,
                                      .sellcallmonthqe,
                                      .defaultcell,
                                      .buyputmonthqe,
                                      .buyputstrikeqe,
                                      .puttheo,
                                      .putdelta,
                                      .putinventory,
                                      .sellputstrikeqe,
                                      .sellputmonthqe,
                                      .inventory,
                                      .callposition,
                                      .callvolume,
                                      .position,
                                      .putposition,
                                      .putvolume,
                                      .title]
    
    
    static func strikeCellTypeAt(indx:Int) -> StrikeType {
        if let strikeType  = visibleCellPositionIndx[tryWith: indx] {
            return strikeType
        }
        return StrikeType.null
    }
    
}

//typealias StrikeType = Int



enum Position {
    case long
    case short
    case neutral
    case null
}

let dotChar:Character = "."
let dotString:String = "."

func parseXonString() {
    xonListingArray = (xonListingData.characters.split(",", maxSplit: Int.max, allowEmptySlices: true).map(String.init))
}
/*

func addEyesToArray(inout eyeArray:[Eye], listing:Listing, bAddMonthEyes:Bool = true, bAddStrikeEyes:Bool = true) {
    for monthContainer in listing.registeredMonthContainers {
        if bAddMonthEyes {
            for eye in monthContainer.monthEyes {
              eyeArray.append(eye! as Eye)
            }
        }
        //TODO : addStrikeEyes when available
    }
    
}
*/


func removeAfterIndex(Source str:String, CutOffIndex indx:Int) -> String {
    if str.characters.count >= indx {
        return str.stringByPaddingToLength(indx, withString: "", startingAtIndex: (str.characters.count-1))
    }
    return str
}

func removeExtraZeros(str:String, alsoBeforeDot:Bool = false) -> String {
    if let strDouble = str.asDouble() {
        if alsoBeforeDot {
            if strDouble < 1.0 {
                return removeBeforeCharacter(Source: String(strDouble), Character: ".")
            }
        }
    return String(strDouble)
    
    }
    return str
}

func removeBeforeCharacter(Source str:String, Character char:Character) -> String {
    if let charIndex = str.characters.indexOf(char) {
        let subStr = str.substringFromIndex(charIndex)
        return subStr
    }
    return str
}

func removeAfterCharacter(Source str:String, Character char:Character, CutOffIndex indx:Int) -> String {
    if let dotIndex = str.characters.indexOf(char) {
        
        let startIndex = str.characters.startIndex.distanceTo(dotIndex)+1
        //print("characterCount: \(str.characters.count)  - startIndex: \(startIndex)")
        if (str.characters.count <= startIndex+indx) {
            return str
        }
        return str.stringByPaddingToLength(startIndex+indx, withString: "", startingAtIndex: startIndex)
    } else {
        return removeAfterIndex(Source: str, CutOffIndex: indx)
    }
    
}

func isEven(i:Int)->Bool {
    if (i%2 == 0) {
        return true
    }
    return false
}

func isOdd(i:Int)->Bool {
    if isEven(i) {
        return false
    }
    return true
}
///Will prepend the appopriate amount of Zeros before a string so as to keep the character length consistant
func prependZerosToString(numberToString str:String, MinCharLength charLength:Int)-> String {
    var newStr = str
    while newStr.characters.count < (charLength) {
        newStr = "0"+newStr
    }
    return newStr
}

///Will append the appopriate amount of Zeros before a string so as to keep the character length consistant
func appendZerosToString(numberAsString str:String, MinCharLength charLength:Int)-> String {
    var newStr = str
    
    while newStr.characters.count < (charLength) {
        newStr = newStr + "0"
    }
    return newStr
}


func readMoreData(client:TCPClient, readData:[UInt8]?, lengthValue:Int, totalData:[UInt8], isFirst:Bool) -> [UInt8] {
    var newTotalData:[UInt8] = totalData
    let recData = readData
    
    if recData != nil {

        if recData!.count == lengthValue {
                newTotalData.appendContentsOf(recData!)
                return newTotalData
        } else {
                newTotalData.appendContentsOf(recData!)
            }
            return readMoreData(client, readData: client.read(lengthValue, timeout: timeout), lengthValue: (lengthValue-recData!.count), totalData: newTotalData, isFirst: false)
    }
    //print("ERROR:  readMoreData: recData couldn't be unwrapped")
    return totalData
}

func testData(testUInt8:[UInt8]) {
    var newUInt8:[UInt8] = [UInt8]()
    var count = 1
    var count2 = 1
    //print("count: \(testUInt8.count)")
    //print(String.init(bytes: testUInt8, encoding: NSUTF8StringEncoding))
    newUInt8.append(testUInt8[0])
    while String.init(bytes: newUInt8, encoding: NSUTF8StringEncoding) != nil {
        newUInt8.append(testUInt8[count])
        count += 1
    }
    //print("number To Be Removed: \(newUInt8[newUInt8.count-1])")
    newUInt8.removeLast()
    //print("count \(count-1)")
    //print(String.init(bytes: newUInt8, encoding: NSUTF8StringEncoding)!)
    newUInt8.removeAll()
    count = testUInt8.count-2
    newUInt8.append(testUInt8[count+1])
    while String.init(bytes: newUInt8, encoding: NSUTF8StringEncoding) != nil {
        newUInt8.insert(testUInt8[count], atIndex: 0)
        count -= 1
        count2 += 1
    }
    //print("number To Be Removed: \(newUInt8[0])")
    newUInt8.removeFirst()
    count2 -= 1
    if let newString = String(bytes: newUInt8, encoding: NSUTF8StringEncoding) {
      //print(newString)
    }
    //print("count2 \(count2)")

}

func dateToString(date:NSDate) -> String {
    return date.descriptionWithLocale(smileDateFormat)
}

func stringToDate(str:String) -> NSDate {
    return smileDateFormat.dateFromString(str)!
}


func numberOrZero(number:Double) -> Double {
    //print(number)
    if number <= 0.0 {
        return 0.0
    }
    return number
}


//let testUInt8:[UInt8] = [48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 34, 44, 34, 115, 116, 114, 105, 107, 101, 34, 58, 34, 56, 50, 189, 34, 44, 34, 115, 116, 114, 105, 107, 101, 105, 100, 34, 58, 34, 49, 52, 56, 53, 55, 54, 57, 56, 34, 44]


func getStrikes(success:Bool, errmsg:String, client:TCPClient, listingID: Int, expDate:NSDate) -> String? {
    
    let readableDateformat:NSDateFormatter = NSDateFormatter()
    readableDateformat.dateFormat = "MM/dd/yyyy"
    let expDateString = readableDateformat.stringFromDate(expDate)
    let listingIDString:String = String(listingID)
    
    let fieldSelection:String = "[\"odate\",\"strike\",\"Inventory\",\"CallBid1\",\"CallAsk1\",\"CallPrice\",\"CallDelta\",\"CallInventory\",\"Fv\",\"PutBid1\",\"PutAsk1\",\"PutPrice\",\"PutDelta\",\"PutInventory\"]"
    
    let sendStr:String = "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{\"command\":\"get_atm_strikes\",\"rangesize\":15,\"securityid\":\(listingIDString),\"expdate\":\"\(expDateString)\",\"range_prev\":15,\"range_next\":15,\"fieldselection\":\(fieldSelection)}}"
    
    let strLength:UInt = strlen(sendStr)
    var networkLen:UInt = strLength.bigEndian

    let data:NSMutableData = NSMutableData(bytes: &networkLen, length: sizeof(Int))
    data.appendBytes(sendStr, length: Int(strLength))
    
    
    //print("Debug: GetStrikes: listingID: \(listingID) expDate: \(expDateString)")
    
    if success  && (usingDemo == false) {
        let (success1, _) = client.send(data: data)
        if success1 {
            //print("strikes: I sent something (1)")
            //print(" strLength: " + "\(strLength)")
            //print("NSDATA:")
            
            let lengthSize:Int = sizeof(Int)
            let recData = client.read(lengthSize, timeout: timeout)
            
            if let d = recData {
                let recDataNS = NSData(bytes: d, length: lengthSize )
                var lengthValue:Int = 0
                recDataNS.getBytes(&lengthValue, length: lengthSize )
                lengthValue = Int(bigEndian: lengthValue)
                
                //print("First Read: Querying lenghtValue: \(lengthValue)")
                
                let finalData:[UInt8] = readMoreData(client, readData: client.read(lengthValue, timeout: timeout), lengthValue: lengthValue, totalData: [UInt8](), isFirst: true)
                //print(finalData.count)
                
                if let str = String(bytes: finalData, encoding: NSASCIIStringEncoding) {
                    //print("strikesString: " + str)
                    return str
                }
            }
        } else {
            //print("Strikes: FailedToSendData: \(errmsg1)")
            
        }
    }
    else {
        return adtnStrikesDemoString
    }
    return nil
    
}

func getMaturities(success:Bool, errmsg:String, client:TCPClient, listingID: Int) -> String? {
    let sendStr:String = "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{\"tab_data\":\"\(listingID)\",\"tablename\":\"Maturity\",\"command\":\"view_table\",\"fieldselection\":[\"edate\"]}}"
    //let sendStr:String = "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{\"tab_data\":\"1917\",\"tablename\":\"Maturity\",\"command\":\"view_table\",\"fieldselection\":[\"edate\"]}}"

    let strLength:UInt = strlen(sendStr)
    var networkLen:UInt = strLength.bigEndian
    let data:NSMutableData = NSMutableData(bytes: &networkLen, length: sizeof(Int))
    data.appendBytes(sendStr, length: Int(strLength))
    
    if success && (usingDemo == false) {
        let (success1, _) = client.send(data: data)
        if success1 {
            //print("maturities: I sent something (1)")
            //print(" strLength: " + "\(strLength)")
           
            
            let lengthSize:Int = sizeof(Int)
            let recData = client.read(lengthSize, timeout: timeout)

            if let d = recData {
                let recDataNS = NSData(bytes: d, length: lengthSize )
                var lengthValue:Int = 0
                recDataNS.getBytes(&lengthValue, length: lengthSize )
                lengthValue = Int(bigEndian: lengthValue)
                
                //print("  First Read: Querying lenghtValue: \(lengthValue)")
                let finalData:[UInt8] = readMoreData(client, readData: client.read(lengthValue, timeout: timeout), lengthValue: lengthValue, totalData: [UInt8](), isFirst: true)
                //print(finalData.count)
                
                //print("NSDATA:")
                if let str = String(bytes: finalData, encoding: NSASCIIStringEncoding) {
                    print("Maturities: " + str)
                    return str
                    
                }
                
                
            }
            //print("  Maturities: couldnt resolve recData")
        } else {
            //print("  Maturities: FailedToSendData  \(errmsg1)")
            
        }
    }
    else {
        //print("Maturities: Couldnt connect to server")
    }
    //print("Maturities: ERROR")
    return ""
    
}

func getPortfolio(success:Bool, errmsg:String, client:TCPClient) -> String? {
   
    let sendStr:String = "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{ \"command\":\"view_table\",\"fieldselection\":[\"name\",\"id\"],\"tablename\":\"Portfolio\"}}"
    let strLength:UInt = strlen(sendStr)
    var networkLen:UInt = strLength.bigEndian
    let data:NSMutableData = NSMutableData(bytes: &networkLen, length: sizeof(Int))
    data.appendBytes(sendStr, length: Int(strLength))
    
    
    if success && (usingDemo == false) {
        let (success1, _) = client.send(data: data)
        if success1 {
            //print("portfolio: I sent something (1)")
            //print("strLength: " + "\(strLength)")
            //print("NSDATA:")
            
            let lengthSize:Int = sizeof(Int)
            let recData = client.read(lengthSize, timeout: timeout)
            //var lengthDifference:Int = 0
            if let d = recData {
                let recDataNS = NSData(bytes: d, length: lengthSize )
                var lengthValue:Int = 0
                recDataNS.getBytes(&lengthValue, length: lengthSize )
                lengthValue = Int(bigEndian: lengthValue)
                
                //print("First Read: Querying lenghtValue: \(lengthValue)")
                //lengthDifference = lengthValue
                let finalData:[UInt8] = readMoreData(client, readData: client.read(lengthValue, timeout: timeout), lengthValue: lengthValue, totalData: [UInt8](), isFirst: true)
                //print(finalData.count)
                
                if let str = String(bytes: finalData, encoding: NSASCIIStringEncoding) {
                    return str
                }
                
                
            }
            //print("coudnt resolve recData")
        } else {
            //print("FailedToSendData: \(errmsg1)")
            
        }
    }
    else {
        //print("Portfolio: Couldnt connect to server")
        
    }
    return ""
}


func getEyes(success:Bool, errmsg:String, client:TCPClient) -> String {
    let sendStr:String = "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{ \"command\":\"view_table\",\"tablename\":\"Eye\"}}"
    let strLength:UInt = strlen(sendStr)
    var networkLen:UInt = strLength.bigEndian
    let data:NSMutableData = NSMutableData(bytes: &networkLen, length: sizeof(Int))
    data.appendBytes(sendStr, length: Int(strLength))
    
    //let finalData = NSData(data: data)
    
    
    if success && (usingDemo == false) {
        let (success1, errmsg1) = client.send(data: data)
        if success1 {
            //print("eyes: I sent something (1)")
            //print("strLength: " + "\(strLength)")
            //print("NSDATA:")
            
            let lengthSize:Int = sizeof(Int)
            let recData = client.read(lengthSize, timeout: timeout)
            // var lengthDifference:Int = 0
            if let d = recData {
                let recDataNS = NSData(bytes: d, length: lengthSize )
                var lengthValue:Int = 0
                recDataNS.getBytes(&lengthValue, length: lengthSize )
                lengthValue = Int(bigEndian: lengthValue)
                
                //print("First Read: Querying lenghtValue: \(lengthValue)")
                //lengthDifference = lengthValue
                let finalData:[UInt8] = readMoreData(client, readData: client.read(lengthValue, timeout: timeout), lengthValue: lengthValue, totalData: [UInt8](), isFirst: true)
                //print("FinalData Count:")
                //print(finalData.count)
                
                if let str = String(bytes: finalData, encoding: NSASCIIStringEncoding) {
                    //print(str)
                    //eyebookJSON = JSON.parse(str)
                    return str
                }
                //print("failure when encoding string")
            }
            //print("coudnt resolve recData")
        } else {
            //print("failure when sending (1)")
            //print(errmsg1)
        }
    }
    else {
        //print("no connection")
        //print(errmsg)
    }
    //print("eyes: Using demo data")
    return eyebookRaw
}
