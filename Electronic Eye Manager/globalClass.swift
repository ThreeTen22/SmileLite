//
//  globalVars.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/7/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

extension UILabel {
    
}

var eyeBook:EyeBook = EyeBook()


var bcspEdgeRule = [["Buy Call | Sell Put","$ Edge", "0.00", "0", "0.01"],["0","0","0","0","1"]]
var scbpEdgeRule = [["Sell Call | Buy Put","$ Edge", "0.00", "0", "0.01"],["0","0","0","0","1"]]
var eyeParameters = ["Delta","Quanity","Min Edge", "Max Delta","Order Type"]
let orderTypeParameters = ["LMT", "EOD"]


//var currentStrikeEye:StrikeEye = StrikeEye(symbol: "XON", expDate: "06/27/16", strikePrice: 37.5, priceOverride: 0, quantityOverride: 0)

//                          Stock   Last  Bid 	Ask
var xonTitleData:NSArray = ["XON", 29.17, 29.14, 29.18]

//will use the keyboard when inputting
var bWillUseKeyboard = false

let smileDateFormat = NSDateFormatter()

var xonListingArray:Array = [String]()

var client:TCPClient = TCPClient(addr: "jdempseylxdt05", port: 9400)
var (clientSuccess, clientErrmsg) = (false, "HAVENT CONNECTED")

let timeout:Int = 1

public enum FilterType {
    case all
    case listing
}

public enum StrikeType {
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
    case date
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

public enum Position {
    case long
    case short
    case neutral
    case null
}

func parseXonString() {
    xonListingArray = (xonListingData.characters.split(",", maxSplit: Int.max, allowEmptySlices: true).map(String.init))
}

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


func removeAfterIndex(Source str:String, CutOffIndex indx:Int) -> String {
    if str.characters.count >= indx {
        return str.stringByPaddingToLength(indx, withString: "", startingAtIndex: (str.characters.count-1))
    }
    return str
}

func removeAfterCharacter(Source str:String, Character char:Character, CutOffIndex indx:Int) -> String {
    if let dotIndex = str.characters.indexOf(char) {
        
        let startIndex = str.characters.startIndex.distanceTo(dotIndex)+1
        print("characterCount: \(str.characters.count)  - startIndex: \(startIndex)")
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
    var recData = readData
//    var hadError = false
//    var errorCount = 0
    if recData != nil {
//        let testString:String? = String(bytes: recData!, encoding: NSASCIIStringEncoding)
//        if testString == nil {
//            hadError = true
//            //print("NIL: \(recData)")
////            if errorCount%2 == 1 {
////                recData!.removeLast()
////            } else {
////                recData!.removeFirst()
////            }
//          testData(recData!)
//        }
//       if hadError {
//        //print("")
//        //print("ERROR: \(recData!)")
//        //print("")
//       } else {
//        //print(testString)
//       }
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
    if let newString = String.init(bytes: newUInt8, encoding: NSUTF8StringEncoding) {
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
    print(number)
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
    
    if success {
        let (success1, errmsg1) = client.send(data: data)
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
        //print("strikes: Couldnt connect to server")
    }
    return nil
    
}

func getMaturities(success:Bool, errmsg:String, client:TCPClient, listingID: Int) -> String? {
    let sendStr:String = "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{\"tab_data\":\"\(listingID)\",\"tablename\":\"Maturity\",\"command\":\"view_table\",\"fieldselection\":[\"edate\"]}}"
    let strLength:UInt = strlen(sendStr)
    var networkLen:UInt = strLength.bigEndian
    let data:NSMutableData = NSMutableData(bytes: &networkLen, length: sizeof(Int))
    data.appendBytes(sendStr, length: Int(strLength))
    
    if success {
        let (success1, errmsg1) = client.send(data: data)
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
                    //print("Maturities: " + str)
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
    return "NULL"
    
}

func getPortfolio(success:Bool, errmsg:String, client:TCPClient) {
   
    let sendStr:String = "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{ \"command\":\"view_table\",\"fieldselection\":[\"name\",\"id\"],\"tablename\":\"Portfolio\"}}"
    let strLength:UInt = strlen(sendStr)
    var networkLen:UInt = strLength.bigEndian
    let data:NSMutableData = NSMutableData(bytes: &networkLen, length: sizeof(Int))
    data.appendBytes(sendStr, length: Int(strLength))
    
    
    if success {
        let (success1, errmsg1) = client.send(data: data)
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
                    //print("gottenStr: " + str)
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
    
}


func getEyes(success:Bool, errmsg:String, client:TCPClient) -> String {
    let sendStr:String = "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{ \"command\":\"view_table\",\"tablename\":\"Eye\"}}"
    let strLength:UInt = strlen(sendStr)
    var networkLen:UInt = strLength.bigEndian
    let data:NSMutableData = NSMutableData(bytes: &networkLen, length: sizeof(Int))
    data.appendBytes(sendStr, length: Int(strLength))
    
    //let finalData = NSData(data: data)
    
    
    if success {
        let (success1, errmsg1) = client.send(data: data)
        if success1 {
            //print("eyes: I sent something (1)")
            //print("strLength: " + "\(strLength)")
            //print("NSDATA:")
            
            let lengthSize:Int = sizeof(Int)
            let recData = client.read(lengthSize, timeout: timeout)
            var lengthDifference:Int = 0
            if let d = recData {
                let recDataNS = NSData(bytes: d, length: lengthSize )
                var lengthValue:Int = 0
                recDataNS.getBytes(&lengthValue, length: lengthSize )
                lengthValue = Int(bigEndian: lengthValue)
                
                //print("First Read: Querying lenghtValue: \(lengthValue)")
                lengthDifference = lengthValue
                let finalData:[UInt8] = readMoreData(client, readData: client.read(lengthValue, timeout: timeout), lengthValue: lengthValue, totalData: [UInt8](), isFirst: true)
                //print("FinalData Count:")
                //print(finalData.count)
                
                if let str = String(bytes: finalData, encoding: NSASCIIStringEncoding) {
                    //print("gottenStr: " + str)
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

let adtnMonthDemoData = "[{\"CallAsk1\":\"0.55\",\"CallBid1\":\"0.15\",\"CallDelta\":\"0.92039844\",\"CallInventory\":\"0\",\"CallPrice\":\"16.75\",\"CallPriceStatus\":6,\"Fv\":\"29.99960786\",\"Inventory\":\"0\",\"PutAsk1\":\"0.40\",\"PutBid1\":\"0.20\",\"PutDelta\":\"-0.07960681\",\"PutInventory\":\"0\",\"PutPrice\":\"16.82\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"20.00000000\"},{\"CallAsk1\":\"1.15\",\"CallBid1\":\"0.75\",\"CallDelta\":\"0.92299739\",\"CallInventory\":\"0\",\"CallPrice\":\"16.83\",\"CallPriceStatus\":6,\"Fv\":\"30.00055302\",\"Inventory\":\"0\",\"PutAsk1\":\"0.40\",\"PutBid1\":\"\",\"PutDelta\":\"-0.07700767\",\"PutInventory\":\"0\",\"PutPrice\":\"15.90\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"19.00000000\"},{\"CallAsk1\":\"2.20\",\"CallBid1\":\"1.60\",\"CallDelta\":\"0.92567113\",\"CallInventory\":\"0\",\"CallPrice\":\"16.91\",\"CallPriceStatus\":6,\"Fv\":\"30.00147800\",\"Inventory\":\"0\",\"PutAsk1\":\"0.20\",\"PutBid1\":\"\",\"PutDelta\":\"-0.07433420\",\"PutInventory\":\"0\",\"PutPrice\":\"14.99\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"18.00000000\"},{\"CallAsk1\":\"3.10\",\"CallBid1\":\"2.55\",\"CallDelta\":\"0.92843047\",\"CallInventory\":\"0\",\"CallPrice\":\"17.00\",\"CallPriceStatus\":6,\"Fv\":\"30.00238254\",\"Inventory\":\"0\",\"PutAsk1\":\"0.25\",\"PutBid1\":\"\",\"PutDelta\":\"-0.07157410\",\"PutInventory\":\"0\",\"PutPrice\":\"14.07\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"17.00000000\"},{\"CallAsk1\":\"4.30\",\"CallBid1\":\"3.20\",\"CallDelta\":\"0.93128662\",\"CallInventory\":\"0\",\"CallPrice\":\"17.09\",\"CallPriceStatus\":6,\"Fv\":\"30.00326627\",\"Inventory\":\"0\",\"PutAsk1\":\"0.45\",\"PutBid1\":\"\",\"PutDelta\":\"-0.06871814\",\"PutInventory\":\"0\",\"PutPrice\":\"13.16\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"16.00000000\"},{\"CallAsk1\":\"5.30\",\"CallBid1\":\"4.20\",\"CallDelta\":\"0.93424996\",\"CallInventory\":\"0\",\"CallPrice\":\"17.18\",\"CallPriceStatus\":6,\"Fv\":\"30.00412889\",\"Inventory\":\"0\",\"PutAsk1\":\"0.25\",\"PutBid1\":\"\",\"PutDelta\":\"-0.06575441\",\"PutInventory\":\"0\",\"PutPrice\":\"12.26\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"15.00000000\"},{\"CallAsk1\":\"6.30\",\"CallBid1\":\"5.10\",\"CallDelta\":\"0.93732851\",\"CallInventory\":\"0\",\"CallPrice\":\"17.28\",\"CallPriceStatus\":6,\"Fv\":\"30.00497014\",\"Inventory\":\"0\",\"PutAsk1\":\"0.30\",\"PutBid1\":\"\",\"PutDelta\":\"-0.06267593\",\"PutInventory\":\"0\",\"PutPrice\":\"11.36\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"14.00000000\"},{\"CallAsk1\":\"7.30\",\"CallBid1\":\"6.10\",\"CallDelta\":\"0.94052641\",\"CallInventory\":\"0\",\"CallPrice\":\"17.38\",\"CallPriceStatus\":6,\"Fv\":\"30.00578993\",\"Inventory\":\"0\",\"PutAsk1\":\"0.30\",\"PutBid1\":\"\",\"PutDelta\":\"-0.05947760\",\"PutInventory\":\"0\",\"PutPrice\":\"10.46\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"13.00000000\"},{\"CallAsk1\":\"10.10\",\"CallBid1\":\"7.10\",\"CallDelta\":\"0.94384294\",\"CallInventory\":\"0\",\"CallPrice\":\"17.49\",\"CallPriceStatus\":6,\"Fv\":\"30.00658828\",\"Inventory\":\"0\",\"PutAsk1\":\"0.20\",\"PutBid1\":\"\",\"PutDelta\":\"-0.05616120\",\"PutInventory\":\"0\",\"PutPrice\":\"9.56\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"12.00000000\"},{\"CallAsk1\":\"9.30\",\"CallBid1\":\"8.20\",\"CallDelta\":\"0.94727333\",\"CallInventory\":\"0\",\"CallPrice\":\"17.60\",\"CallPriceStatus\":6,\"Fv\":\"30.00736534\",\"Inventory\":\"0\",\"PutAsk1\":\"0.25\",\"PutBid1\":\"\",\"PutDelta\":\"-0.05273169\",\"PutInventory\":\"0\",\"PutPrice\":\"8.68\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"11.00000000\"},{\"CallAsk1\":\"0.15\",\"CallBid1\":\"\",\"CallDelta\":\"0.91786432\",\"CallInventory\":\"0\",\"CallPrice\":\"16.67\",\"CallPriceStatus\":6,\"Fv\":\"29.99864276\",\"Inventory\":\"0\",\"PutAsk1\":\"1.55\",\"PutBid1\":\"0.70\",\"PutDelta\":\"-0.08214222\",\"PutInventory\":\"0\",\"PutPrice\":\"17.74\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"21.00000000\"},{\"CallAsk1\":\"0.20\",\"CallBid1\":\"\",\"CallDelta\":\"0.91538593\",\"CallInventory\":\"0\",\"CallPrice\":\"16.59\",\"CallPriceStatus\":6,\"Fv\":\"29.99765983\",\"Inventory\":\"0\",\"PutAsk1\":\"2.55\",\"PutBid1\":\"1.55\",\"PutDelta\":\"-0.08461979\",\"PutInventory\":\"0\",\"PutPrice\":\"18.67\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"22.00000000\"},{\"CallAsk1\":\"0.10\",\"CallBid1\":\"\",\"CallDelta\":\"0.91295596\",\"CallInventory\":\"0\",\"CallPrice\":\"16.52\",\"CallPriceStatus\":6,\"Fv\":\"29.99666364\",\"Inventory\":\"0\",\"PutAsk1\":\"3.90\",\"PutBid1\":\"2.85\",\"PutDelta\":\"-0.08705096\",\"PutInventory\":\"0\",\"PutPrice\":\"19.59\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"23.00000000\"},{\"CallAsk1\":\"0.20\",\"CallBid1\":\"\",\"CallDelta\":\"0.91056903\",\"CallInventory\":\"0\",\"CallPrice\":\"16.45\",\"CallPriceStatus\":6,\"Fv\":\"29.99565982\",\"Inventory\":\"0\",\"PutAsk1\":\"4.90\",\"PutBid1\":\"3.70\",\"PutDelta\":\"-0.08943609\",\"PutInventory\":\"0\",\"PutPrice\":\"20.52\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"24.00000000\"},{\"CallAsk1\":\"0.25\",\"CallBid1\":\"\",\"CallDelta\":\"0.90822143\",\"CallInventory\":\"0\",\"CallPrice\":\"16.38\",\"CallPriceStatus\":6,\"Fv\":\"29.99465409\",\"Inventory\":\"0\",\"PutAsk1\":\"5.90\",\"PutBid1\":\"4.70\",\"PutDelta\":\"-0.09178437\",\"PutInventory\":\"0\",\"PutPrice\":\"21.45\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"25.00000000\"},{\"CallAsk1\":\"0.30\",\"CallBid1\":\"\",\"CallDelta\":\"0.90591081\",\"CallInventory\":\"0\",\"CallPrice\":\"16.31\",\"CallPriceStatus\":6,\"Fv\":\"29.99365173\",\"Inventory\":\"0\",\"PutAsk1\":\"6.90\",\"PutBid1\":\"5.70\",\"PutDelta\":\"-0.09409579\",\"PutInventory\":\"0\",\"PutPrice\":\"22.38\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"26.00000000\"},{\"CallAsk1\":\"0.30\",\"CallBid1\":\"\",\"CallDelta\":\"0.90363587\",\"CallInventory\":\"0\",\"CallPrice\":\"16.24\",\"CallPriceStatus\":6,\"Fv\":\"29.99265727\",\"Inventory\":\"0\",\"PutAsk1\":\"7.80\",\"PutBid1\":\"6.70\",\"PutDelta\":\"-0.09637016\",\"PutInventory\":\"0\",\"PutPrice\":\"23.32\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"27.00000000\"},{\"CallAsk1\":\"0.25\",\"CallBid1\":\"\",\"CallDelta\":\"0.90139609\",\"CallInventory\":\"0\",\"CallPrice\":\"16.18\",\"CallPriceStatus\":6,\"Fv\":\"29.99167437\",\"Inventory\":\"0\",\"PutAsk1\":\"8.90\",\"PutBid1\":\"7.70\",\"PutDelta\":\"-0.09860908\",\"PutInventory\":\"0\",\"PutPrice\":\"24.25\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"28.00000000\"},{\"CallAsk1\":\"0.25\",\"CallBid1\":\"\",\"CallDelta\":\"0.89919142\",\"CallInventory\":\"0\",\"CallPrice\":\"16.12\",\"CallPriceStatus\":6,\"Fv\":\"29.99070583\",\"Inventory\":\"0\",\"PutAsk1\":\"9.90\",\"PutBid1\":\"8.40\",\"PutDelta\":\"-0.10081424\",\"PutInventory\":\"0\",\"PutPrice\":\"25.19\",\"PutPriceStatus\":6,\"odate\":\"11/18/2016\",\"strike\":\"29.00000000\"}]"

let xonListingData:String = "Date,Strk,MQ/E,Q/E,CTheo,CDlt,Cpos,Q/E,MQ/E,,MQ/E,Q/E,PTheo,PDlt,PPos,Q/E,MQ/E,PPos,10/21/16,17,,,8.975,100,0,,,,,,0.000001120727735,-0.0002520667068,-32,,,-32,10/21/16,22,,,3.976785003,99.45118175,0,,,,,,0.004497260959,-0.668872853,19,,,19,10/21/16,23,,,2.988847526,97.57128311,0,,,,,,0.0174112742,-2.478393783,-47,,,-47,10/21/16,23.5,,,2.50483389,95.39269117,0,,,,,,0.03363774581,-4.634760636,0,,,0,10/21/16,24,,,2.034773398,91.61570425,90,,,,,,0.06373474612,-8.395735067,-17,72/.03,,73,10/21/16,24.5,,,1.58838878,85.4525778,0,,,,,,0.1174480154,-14.54768693,0,,20/.15,0,10/21/16,25,,,1.179326953,76.21048929,201,,25/.15,,,,0.208442559,-23.78227543,-18,,20/.16,183,10/21/16,25.5,,,0.8236597928,63.77764972,0,,25/.16,,,,0.3528040485,-36.21029894,0,,20/.17,0,10/21/16,26,,,0.5357443747,49.14977005,0,50/.20,25/.17,,,,0.5648996139,-50.83522692,94,,20/.18,94,10/21/16,26.5,,,0.3215516061,34.61527557,0,,25/.18,,,,0.8507071087,-65.36800234,0,,20/.19,0,10/21/16,27,,,0.1765874429,21.95642415,38,,25/.19,,,100/.18,1.205737032,-78.02589399,-2,,20/.20,36,10/21/16,27.5,,,0.08834004372,12.45377244,5,,25/.20,,,,1.617480273,-87.52802202,0,,,5,10/21/16,28,,,0.04022894798,6.304372478,-32,,25/.21,,,,2.069357932,-93.67714118,-81,,,-113,10/21/16,28.5,,,0.0167289599,2.856262404,0,,25/.22,,,,2.545845684,-97.12510249,-20,,,-20,10/21/16,29,25/.15,,0.006395307727,1.166244057,50,,25/.23,,,,3.035499228,-98.81504256,0,,,50,10/21/16,29.5,25/.16,,0.002269445477,0.4335938464,0,,,,,,3.531360273,-99.54765167,0,,,0,10/21/16,30,25/.17,50/.20,0.0007564838759,0.1486556594,-18,,,,,,4.029834065,-99.83256823,2,,,-16,10/21/16,30.5,25/.18,,0.0002400161004,0.04766514026,0,,,,,,4.529304269,-99.93354729,0,,,0,10/21/16,31,25/.19,,0.00007348725037,0.01450371071,255,,,,,,5.029124367,-99.9667026,0,,,255,10/21/16,31.5,25/.20,20/.07,0.00002201022808,0.004248556183,99,,,,,,5.529059493,-99.97695444,0,,,99,10/21/16,32,25/.21,,0.000006533532869,0.001214373712,-202,,,,,,6.029030605,-99.9799868,0,,,-202,10/21/16,32.5,25/.22,,0.000001946334324,0.000342914286,207,,,,,,6.529012599,-99.98085724,0,,,207,10/21/16,33,25/.23,,0.0000005893139232,0.00009675139524,-416,,,,,,7.028997819,-99.98110283,0,,,-416,10/21/16,33.5,25/.24,,0.0000001840581968,0.00002757486495,0,,,,,,7.528983988,-99.98117167,0,,,0,10/21/16,34,25/.25,,0.00000006051976553,0.00000803571354,178,,,,,,8.028970437,-99.98119102,0,,,178,10/21/16,34.5,,,0.00000002159399182,0.000002433787627,0,,,,,,8.52895697,-99.9811965,0,,,0,10/21/16,35,,,0.000000008702540905,0.0000007853283931,73,,,,,,9.028943528,-99.98119808,0,,,73,10/21/16,37,,,0.000000001003141542,0.00000003089082911,-2,,,,,,11.0288898,-99.98119874,0,,,-2,10/21/16,40,,,0.0000000001957029597,0.00000000469670795,9,,,,,,14.02880922,-99.98119874,-5,,,4,10/21/16,45,,,0,0.0000000003553310801,27,,,,,,19.02867492,-99.98119874,0,,,27,10/21/16,50,,,0,0,11,,,,,,24.02854062,-99.98119874,0,,,11,10/21/16,55,,,0,0,17,,,,,,29.02840632,-99.98119874,0,,,17,10/21/16,60,,,0,0,4,,,,,,34.02827202,-99.98119874,0,,,4,10/28/16,24,,,2.360968278,77.26505594,0,,,,,,0.4042111947,-22.7075484,0,,,0,10/28/16,24.5,,,1.99182259,71.43080032,0,,,,,,0.5352453336,-28.52965879,0,,,0,10/28/16,25,,,1.653952364,64.86316574,0,,,,,,0.6975038341,-35.08744943,0,,,0,10/28/16,25.5,,,1.350541583,57.72426243,0,,,,,,0.8941805787,-42.21843291,0,,,0,10/28/16,26,,,1.083756992,50.26485564,0,,,,,,1.127450546,-49.67151589,0,,,0,10/28/16,26.5,,,0.854001203,42.89069601,0,,,,,,1.397723155,-57.04067936,0,,,0,10/28/16,27,,,0.6603359321,35.75988466,0,,,,,,1.70406579,-64.16758724,0,,,0,10/28/16,27.5,,,0.5008674387,29.10752842,8,,,,,,2.044589271,-70.81690887,0,,,8,10/28/16,28,,,0.3726598834,23.12174061,10,,,,,,2.416361362,-76.80034769,0,,,10,10/28/16,28.5,,,0.2720369064,17.92353256,0,,,,,,2.815708526,-81.99674412,0,,,0,10/28/16,29,,,0.1949280896,13.56263323,0,,,,,,3.238562549,-86.3562505,0,,,0,10/28/16,29.5,,,0.1372042139,10.02420558,0,,,,,,3.680795916,-89.89360967,0,,,0,10/28/16,30,,,0.09495629801,7.243299398,29,,,,,,4.138500963,-92.6736977,0,,,29,10/28/16,30.5,,,0.06469225778,5.122839165,0,,,,,,4.608186614,-94.79353217,0,,,0,10/28/16,31,,,0.04344521741,3.551208866,22,,,,,,5.086886769,-96.36468412,0,,,22,10/28/16,31.5,,,0.02880369122,2.416658119,0,,,,,,5.572190532,-97.4988692,0,,,0,10/28/16,32,,,0.01888331101,1.617228098,0,,,,,,6.062213985,-98.29801952,0,,,0,10/28/16,32.5,,,0.01226242638,1.066182952,0,,,,,,6.555535819,-98.8488505,0,,,0,10/28/16,33,,,0.007901506088,0.6937624853,0,,,,,,7.051116765,-99.22110672,0,,,0,11/04/16,24,,,2.642056119,72.0988229,0,,,,,,0.6995324989,-27.82809634,0,,,0,11/04/16,24.5,,,2.301886013,67.21226388,0,,,,,,0.8595877369,-32.70170807,0,,,0,11/04/16,25,,,1.987414939,61.97766664,0,,,,,,1.045285812,-37.925328,0,,,0,11/04/16,25.5,,,1.700000921,56.484963,0,,,,,,1.257993643,-43.40875081,0,,,0,11/04/16,26,,,1.440482923,50.85724159,0,,,,,,1.498557789,-49.02864841,0,,,0,11/04/16,26.5,,,1.20879735,45.29660605,0,,,,,,1.766921146,-54.58272318,0,,,0,11/04/16,27,,,1.004347764,39.84325881,0,,,,,,2.062492889,-60.03060046,0,,,0,11/04/16,27.5,,,0.8261899799,34.60150147,0,,,,,,2.384333583,-65.26780727,0,,,0,11/04/16,28,,,0.6729096962,29.66383304,0,,,,,,2.731032891,-70.20169748,0,,,0,11/04/16,28.5,,,0.5427092309,25.1040369,0,,,,,,3.100796438,-74.75836203,0,,,0,11/04/16,29,,,0.4335111769,20.97417543,0,,,,,,3.491549563,-78.88563178,0,,,0,11/04/16,29.5,,,0.3430686323,17.30372786,0,,,,,,3.901047639,-82.55393707,0,,,0,11/04/16,30,,,0.2690721205,14.10070938,1,,,,,,4.326983069,-85.75518659,0,,,1,11/04/16,30.5,,,0.2092449925,11.35437228,0,,,,,,4.767080755,-88.50006411,0,,,0,11/04/16,31,,,0.1614215788,9.038951739,2,,,,,,5.219176305,-90.81428098,0,,,2,11/04/16,31.5,,,0.1236051136,7.117885484,0,,,,,,5.681274001,-92.73435488,0,,,0,11/04/16,32,,,0.09400504005,5.54799464,0,,,,,,6.151584147,-94.30342763,0,,,0,11/04/16,32.5,,,0.07105537052,4.28323199,0,,,,,,6.628541463,-95.56751572,0,,,0,11/04/16,33,,,0.05341716704,3.277749532,0,,,,,,7.110807587,-96.57244176,0,,,0,11/04/16,33.5,,,0.03996888972,2.488179078,0,,,,,,7.597261453,-97.36155296,0,,,0,11/04/16,34,,,0.02978844742,1.875136185,0,,,,,,8.086981358,-97.97421649,0,,,0,11/04/16,34.5,,,0.0221304291,1.404038676,0,,,,,,8.579222207,-98.44500032,0,,,0,11/04/16,35,,,0.01640137902,1.045375241,0,,,,,,9.073390805,-98.80340407,0,,,0,11/11/16,22,,,4.380679374,83.49565983,0,,,,,,0.4504581183,-16.46091737,0,,,0,11/11/16,22.5,,,3.981442585,80.4332915,0,,,,,,0.5518339738,-19.49957142,0,,,0,11/11/16,23,,,3.599300766,77.04388464,0,,,,,,0.6701953869,-22.86835224,0,,,0,11/11/16,23.5,,,3.235769881,73.34103731,0,,,,,,0.807073529,-26.55326398,0,,,0,11/11/16,24,,,2.892238361,69.34980208,0,,,,,,0.9638699166,-30.52891079,0,,,0,11/11/16,24.5,,,2.56991144,65.1068331,0,,,,,,1.141801069,-34.7583411,0,,,0,11/11/16,25,,,2.269758658,60.65976479,0,,,,,,1.341846276,-39.19366178,0,,,0,11/11/16,25.5,,,1.992468407,56.06576957,0,,,,,,1.564702352,-43.77747465,0,,,0,11/11/16,26,,,1.738408565,51.40318478,0,,,,,,1.810744461,-48.43124395,0,,,0,11/11/16,26.5,,,1.507335224,46.80525693,0,,,,,,2.079735014,-53.02156566,0,,,0,11/11/16,27,,,1.298747866,42.27327433,0,,,,,,2.371179055,-57.54700803,0,,,0,11/11/16,27.5,,,1.11199796,37.86636654,0,,,,,,2.684432846,-61.94829685,0,,,0,11/11/16,28,,,0.9461736113,33.63872683,0,,,,,,3.018588592,-66.17111274,0,,,0,11/11/16,28.5,,,0.800138956,29.6366039,0,,,,,,3.372513936,-70.16909722,0,,,0,11/11/16,29,,,0.672580283,25.89689017,0,,,,,,3.74489816,-73.90526253,0,,,0,11/11/16,29.5,,,0.5620556814,22.44636741,0,,,,,,4.134301903,-77.35274421,0,,,0,11/11/16,30,,,0.4670450792,19.30160102,0,,,,,,4.539207268,-80.49490527,0,,,0,11/11/16,30.5,,,0.3859978487,16.46941723,0,,,,,,4.95806548,-83.32485762,0,,,0,11/11/16,31,,,0.317375686,13.94785453,0,,,,,,5.389339808,-85.8445094,0,,,0,11/11/16,31.5,,,0.2596891246,11.72745506,0,,,,,,5.831542125,-88.0632725,0,,,0,11/11/16,32,,,0.2115267299,9.792754073,0,,,,,,6.283262133,-89.99657211,0,,,0,11/11/16,32.5,,,0.1715766757,8.123833306,0,,,,,,6.743188973,-91.66429255,0,,,0,11/11/16,33,,,0.1386409579,6.697823917,0,,,,,,7.210125459,-93.0892735,0,,,0,11/11/16,33.5,,,0.1116429283,5.490271412,0,,,,,,7.68299564,-94.2959445,0,,,0,11/11/16,34,,,0.08962911455,4.476304331,0,,,,,,8.160846634,-95.30915564,0,,,0,11/11/16,34.5,,,0.07176643607,3.631576718,0,,,,,,8.642845862,-96.1532346,0,,,0,11/11/16,35,,,0.05733595804,2.932978476,0,,,,,,9.128274813,-96.85127586,0,,,0,11/18/16,20,,,6.203964764,90.12353336,0,,,,,,0.2835251144,-9.919580406,0,,,0,11/18/16,21,,,5.342553032,85.96128982,0,,,,,,0.4244893636,-14.00722288,0,,,0,11/18/16,22,,,4.532074899,80.80035659,0,,,,,,0.6157147778,-19.11049838,0,,,0,11/18/16,23,,,3.782209894,74.64020354,0,,,,,,0.8670450124,-25.22592869,0,,,0,11/18/16,24,,,3.101778,67.57884226,0,,,,,,1.187422236,-32.25253866,0,,,0,11/18/16,25,,,2.497734475,59.82021909,0,,,,,,1.583893713,-39.98415405,0,,,0,11/18/16,26,,,1.974252563,51.67381229,0,,,,,,2.060702571,-48.10959569,0,,,0,11/18/16,27,,,1.531294283,43.62286497,0,,,,,,2.617864394,-56.14435741,0,,,0,11/18/16,28,,,1.165350953,35.91221646,0,,,,,,3.251912067,-63.84257876,5,,,5,11/18/16,29,,,0.8705201642,28.82677901,-11,,,,,,3.956974871,-70.91849156,0,,,-11,11/18/16,30,,,0.638802133,22.57042943,0,,,,,,4.725076993,-77.16755132,0,,,0,11/18/16,31,,,0.4610139215,17.25211072,0,,,,,,5.547053602,-82.48029605,0,,,0,11/18/16,32,,,0.3276858211,12.89011075,-25,,,,,,6.413448631,-86.83803605,0,,,-25,11/18/16,33,,,0.2298034079,9.429640524,0,,,,,,7.315257926,-90.29525038,0,,,0,11/18/16,34,,,0.1593205232,6.767054141,0,,,,,,8.244443044,-92.95534678,0,,,0,11/18/16,35,,,0.1094314935,4.774316767,0,,,,,,9.194204106,-94.94617771,0,,,0,11/18/16,36,,,0.07463784354,3.319240281,0,,,,,,10.15904699,-96.39979205,0,,,0,11/18/16,37,,,0.05066858256,2.279439082,0,,,,,,11.13470397,-97.43846938,0,,,0,11/18/16,38,,,0.03431618383,1.550005542,0,,,,,,12.11796998,-98.16703673,0,,,0,11/18/16,39,,,0.02323994264,1.046141288,0,,,,,,13.10650616,-98.67023129,0,,,0,11/18/16,40,,,0.01577244984,0.702414731,-70,,,,,,14.09864649,-99.01343825,0,,,-70,11/28/16,20,,,6.285771969,88.36281693,0,,,,,,0.378308666,-11.64297011,0,,,0,11/28/16,21.5,,,5.049921834,81.66867439,0,,,,,,0.6460169621,-18.23146141,0,,,0,11/28/16,22,,,4.664414152,79.01941652,0,,,,,,0.7613665499,-20.85306852,0,,,0,11/28/16,22.5,,,4.293734501,76.16817502,0,,,,,,0.8914126181,-23.67970459,0,,,0,11/28/16,23,,,3.938762629,73.12571884,0,,,,,,1.037050787,-26.70024698,0,,,0,11/28/16,23.5,,,3.600291875,69.90738907,0,,,,,,1.199088227,-29.89904734,0,,,0,11/28/16,24,,,3.279008523,66.53300327,0,,,,,,1.378223313,-33.25602018,0,,,0,11/28/16,24.5,,,2.975472952,63.02657185,0,,,,,,1.575027011,-36.74692054,0,,,0,11/28/16,25,,,2.69010343,59.41582201,0,,,,,,1.789926889,-40.34381526,0,,,0,11/28/16,25.5,,,2.423163397,55.7315371,0,,,,,,2.023194566,-44.01573945,0,,,0,11/28/16,26,,,2.174746567,52.01932988,0,,,,,,2.274930961,-47.71691998,0,,,0,11/28/16,26.5,,,1.944578726,48.35344707,0,,,,,,2.544868255,-51.37298634,0,,,0,11/28/16,27,,,1.732299801,44.72382933,0,,,,,,2.832652105,-54.99387688,0,,,0,11/28/16,27.5,,,1.537493085,41.1608475,0,,,,,,3.13787087,-58.54910086,0,,,0,11/28/16,28,,,1.359610202,37.69285369,0,,,,,,3.459980624,-62.0101993,0,,,0,11/28/16,28.5,,,1.197986473,34.3453532,0,,,,,,3.798320611,-65.35157168,0,,,0,11/28/16,29,,,1.051858517,31.14046942,0,,,,,,4.152130897,-68.5510097,0,,,0,11/28/16,29.5,,,0.9203832866,28.09656692,0,,,,,,4.52057147,-71.59007316,0,,,0,11/28/16,30,,,0.8026577563,25.22803844,0,,,,,,4.902741977,-74.45430189,0,,,0,11/28/16,30.5,,,0.6977385129,22.54525185,0,,,,,,5.297701355,-77.133268,0,,,0,11/28/16,31,,,0.6046605684,20.05464425,0,,,,,,5.704486685,-79.62048088,0,,,0,11/28/16,31.5,,,0.52245483,17.75894383,0,,,,,,6.122130695,-81.91316476,0,,,0,11/28/16,32,,,0.4501637821,15.65749491,0,,,,,,6.549677471,-84.01193295,0,,,0,11/28/16,32.5,,,0.3868550674,13.74665947,0,,,,,,6.986196065,-85.92038578,0,,,0,11/28/16,33,,,0.3316327886,12.02026753,0,,,,,,7.430791819,-87.64465973,0,,,0,11/28/16,33.5,,,0.2836464708,10.4700904,0,,,,,,7.88261535,-89.1929537,0,,,0,11/28/16,34,,,0.2420977347,9.086313484,0,,,,,,8.340869238,-90.57505585,0,,,0,11/28/16,34.5,,,0.2062448135,7.857988926,0,,,,,,8.804812561,-91.80189053,0,,,0,11/28/16,35,,,0.1754051156,6.77345309,0,,,,,,9.273763471,-92.88510051,0,,,0,11/28/16,35.5,,,0.1489560761,5.820697874,0,,,,,,9.747100058,-93.83667541,0,,,0,11/28/16,36,,,0.1263345645,4.987689449,0,,,,,,10.22425977,-94.66863263,0,,,0,11/28/16,36.5,,,0.1070351242,4.262631637,0,,,,,,10.70473765,-95.39275381,0,,,0,11/28/16,37,,,0.0906073069,3.634174403,0,,,,,,11.1880837,-96.02037607,0,,,0,11/28/16,37.5,,,0.07665235252,3.091570377,0,,,,,,11.67389955,-96.56223535,0,,,0,11/28/16,38,,,0.06481943265,2.624784134,0,,,,,,12.16183473,-97.02835694,0,,,0,11/28/16,38.5,,,0.05480165014,2.224560047,0,,,,,,12.65158264,-97.42798749,0,,,0,11/28/16,39,,,0.04633195247,1.882455125,0,,,,,,13.1428765,-97.76956205,0,,,0,11/28/16,39.5,,,0.0391790861,1.590843273,0,,,,,,13.63548528,-98.06069967,0,,,0,11/28/16,40,,,0.03314368874,1.342897181,0,,,,,,14.12920985,-98.30822141,0,,,0,12/02/16,21,,,5.56183439,82.48172036,0,,,,,,0.6703679506,-17.40312604,0,,,0,12/02/16,21.5,,,5.174163971,80.08028115,0,,,,,,0.7837429413,-19.77333887,0,,,0,12/02/16,22,,,4.800149095,77.50763741,0,,,,,,0.9106209848,-22.31806644,0,,,0,12/02/16,22.5,,,4.44052549,74.77167001,0,,,,,,1.051755757,-25.02904716,0,,,0,12/02/16,23,,,4.095962002,71.88346852,0,,,,,,1.207831749,-27.89486091,0,,,0,12/02/16,23.5,,,3.767046299,68.85727275,0,,,,,,1.379450307,-30.90097986,0,,,0,12/02/16,24,,,3.454271759,65.71030918,0,,,,,,1.567116793,-34.02992574,0,,,0,12/02/16,24.5,,,3.15802602,62.46251904,0,,,,,,1.771229381,-37.26153637,0,,,0,12/02/16,25,,,2.878581652,59.13618083,0,,,,,,1.992069919,-40.57333878,0,,,0,12/02/16,25.5,,,2.616089345,55.75543606,0,,,,,,2.229797285,-43.94101974,0,,,0,12/02/16,26,,,2.370566367,52.35873331,0,,,,,,2.484435986,-47.32597938,0,,,0,12/02/16,26.5,,,2.141716911,49.0058197,0,,,,,,2.755696674,-50.6683552,0,,,0,12/02/16,27,,,1.929205518,45.683284,0,,,,,,3.043249693,-53.9814415,0,,,0,12/02/16,27.5,,,1.732663971,42.41426549,0,,,,,,3.346731973,-57.2419852,0,,,0,12/02/16,28,,,1.55162589,39.2204032,0,,,,,,3.665681687,-60.4282456,0,,,0,12/02/16,28.5,,,1.38553772,36.12138757,0,,,,,,3.999549312,-63.52044139,0,,,0,12/02/16,29,,,1.233771034,33.13462068,0,,,,,,4.34770999,-66.50108914,0,,,0,12/02/16,29.5,,,1.095635685,30.27496658,0,,,,,,4.709476737,-69.35525204,0,,,0,12/02/16,30,,,0.9703933629,27.55459486,0,,,,,,5.084114046,-72.07069529,0,,,0,12/02/16,30.5,,,0.8572711312,24.98291608,0,,,,,,5.470851468,-74.63795,0,,,0,12/02/16,31,,,0.7554745496,22.56660341,0,,,,,,5.868896766,-77.05029068,0,,,0,12/02/16,31.5,,,0.66420005,20.30969158,0,,,,,,6.277448328,-79.30363575,0,,,0,12/02/16,32,,,0.582646292,18.21374144,0,,,,,,6.69570655,-81.39638237,0,,,0,12/02/16,32.5,,,0.5100242925,16.27805706,0,,,,,,7.122883989,-83.32918884,0,,,0,12/02/16,33,,,0.4455661926,14.49994117,0,,,,,,7.558214154,-85.10471872,0,,,0,12/02/16,33.5,,,0.3885325892,12.87497529,0,,,,,,8.000958856,-86.72736028,0,,,0,12/02/16,34,,,0.3382184198,11.39731128,0,,,,,,8.450414111,-88.20293456,0,,,0,12/02/16,34.5,,,0.2939574391,10.05996282,0,,,,,,8.905914633,-89.53840363,0,,,0,12/02/16,35,,,0.2551253678,8.855086659,0,,,,,,9.366836994,-90.74158903,0,,,0,12/02/16,35.5,,,0.2211418279,7.7742458,0,,,,,,9.832601573,-91.82090824,0,,,0,12/02/16,36,,,0.1914711989,6.808648704,0,,,,,,10.30267342,-92.78513538,0,,,0,12/02/16,36.5,,,0.1656225414,5.949360474,0,,,,,,10.7765622,-93.64318973,0,,,0,12/02/16,37,,,0.1431487442,5.187483958,0,,,,,,11.25382133,-94.40395442,0,,,0,12/02/16,37.5,,,0.1236450415,4.514310197,0,,,,,,11.73404652,-95.07612589,0,,,0,12/02/16,38,,,0.1067470457,3.921438936,0,,,,,,12.21687381,-95.66809317,0,,,0,12/02/16,38.5,,,0.09212842618,3.400870978,0,,,,,,12.70197723,-96.18784541,0,,,0,12/02/16,39,,,0.07949835181,2.945074828,0,,,,,,13.18906629,-96.6429051,0,,,0,12/02/16,39.5,,,0.06859879764,2.547030569,0,,,,,,13.67788327,-97.04028409,0,,,0,01/20/17,20,,,6.974963818,79.89268214,-110,,,,,,1.16857924,-19.758553,14,,,-96,01/20/17,22.5,,,5.279940153,69.80728607,-2,,,,,,1.979753374,-29.6749541,50,,,48,01/20/17,24,,,4.400823572,63.10880749,-1,,,,,,2.602561113,-36.3012199,0,,,-1,01/20/17,25,,,3.873567092,58.48461321,-75,,,,,,3.076050406,-40.88598783,151,,,76,01/20/17,26,,,3.393091101,53.81604498,0,,,,,,3.595974046,-45.5207649,50,,,50,01/20/17,27,,,2.95812933,49.2067903,227,,,,,,4.161122626,-50.10103071,0,,,227,01/20/17,28,,,2.566960656,44.68357412,-25,,,,,,4.769821951,-54.59932214,50,,,25,01/20/17,29,,,2.217558141,40.30040199,-51,,,,,,5.420083699,-58.96101775,0,,,-51,01/20/17,30,,,1.907533514,36.10423994,-258,,,,,,6.109551547,-63.13863969,-11,,,-269,01/20/17,31,,,1.634225867,32.13378514,-21,,,,,,6.835591136,-67.09306288,0,,,-21,01/20/17,32,,,1.394791192,28.41878522,41,,,,,,7.595380609,-70.79418017,0,,,41,01/20/17,33,,,1.186288251,24.97988752,0,,,,,,8.385997272,-74.22104074,0,,,0,01/20/17,34,,,1.005757097,21.82896102,-2,,,,,,9.204496759,-77.36151849,0,,,-2,01/20/17,35,,,0.8502875577,18.96980521,-334,,,,,,10.04798202,-80.21159527,-1,,,-335,01/20/17,36,,,0.7170759842,16.39914394,0,,,,,,10.91366048,-82.77436079,0,,,0,01/20/17,37,,,0.6034695754,14.10779757,-2,,,,,,11.79888872,-85.0588353,0,,,-2,01/20/17,38,,,0.5069984205,12.08193231,0,,,,,,12.70120479,-87.07871612,0,,,0,01/20/17,39,,,0.4253960823,10.30429914,0,,,,,,13.61834902,-88.85113513,0,,,0,01/20/17,40,,,0.3566100306,8.755393075,11,,,,,,14.54827462,-90.39549674,5,,,16,01/20/17,41,,,0.2988035175,7.414483307,0,,,,,,15.48914976,-91.73244527,0,,,0,01/20/17,42,,,0.2503506095,6.260485023,5,,,,,,16.43935272,-92.88299111,0,,,5,01/20/17,43,,,0.2098260638,5.272660731,0,,,,,,17.39746184,-93.86780772,0,,,0,01/20/17,44,,,0.1759916106,4.431153307,0,,,,,,18.36224194,-94.70669714,0,,,0,01/20/17,45,,,0.1477800081,3.717363252,68,,,,,,19.33262843,-95.41821145,0,,,68,01/20/17,46,,,0.1242780057,3.114189309,0,,,,,,20.30771035,-96.01941116,0,,,0,01/20/17,47,,,0.1047091165,2.606155002,-5,,,,,,21.28671319,-96.52573775,0,,,-5,01/20/17,48,,,0.08841686967,2.179444458,0,,,,,,22.26898219,-96.95097706,0,,,0,01/20/17,49,,,0.07484901535,1.821869741,0,,,,,,23.2539666,-97.30729134,0,,,0,01/20/17,50,,,0.06354297926,1.522789638,-59,,,,,,24.24120513,-97.60529986,0,,,-59,01/20/17,55,,,0.02949445174,0.6252607482,24,,,,,,29.19979946,-98.49974079,0,,,24,01/20/17,60,,,0.01514808517,0.2628856638,75,,,,,,34.17802893,-98.86190861,0,,,75,01/20/17,65,,,0.008682876121,0.1133055477,1,,,,,,39.16413439,-99.01358333,0,,,1,01/20/17,70,,,0.00552616248,0.04906606338,1,,,,,,44.15358659,-99.08206482,0,,,1,01/20/17,75,,,0.003847707382,0.02047693504,0,,,,,,49.14458978,-99.11701692,0,,,0,01/20/17,80,,,0.002872061661,0.007803744941,0,,,,,,54.13639715,-99.13809504,0,,,0,01/20/17,85,,,0.002247259432,0.002896006348,0,,,,,,59.12867931,-99.15321651,0,,,0,01/20/17,90,,,0.001802058021,0.002148199916,0,,,,,,64.12128026,-99.16556129,0,,,0,01/20/17,95,,,0.001448927463,0.003712066686,0,,,,,,69.11411905,-99.17637058,0,,,0,04/21/17,22,,,6.691368584,69.04909427,0,,,,,,3.047937368,-29.87305705,0,,,0,04/21/17,23,,,6.146781633,65.82460564,0,,,,,,3.505241355,-33.03096607,0,,,0,04/21/17,24,,,5.636674757,62.5630806,0,,,,,,3.996382195,-36.23404456,0,,,0,04/21/17,25,,,5.160282895,59.28444787,0,,,,,,4.520690518,-39.46112755,0,,,0,04/21/17,26,,,4.716678253,56.01937483,0,,,,,,5.077317181,-42.68056523,0,,,0,04/21/17,27,,,4.304595116,52.79983711,0,,,,,,5.665062188,-45.85961176,0,,,0,04/21/17,28,,,3.922756079,49.63010709,0,,,,,,6.282703122,-48.9932923,0,,,0,04/21/17,29,,,3.569842272,46.52663808,0,,,,,,6.928967309,-52.06457939,0,,,0,04/21/17,30,,,3.244468688,43.50414115,-2,,,,,,7.602508835,-55.05827832,0,,,-2,04/21/17,31,,,2.945203396,40.57547106,0,,,,,,8.301929038,-57.96112447,0,,,0,04/21/17,32,,,2.670585759,37.75156241,0,,,,,,9.025795735,-60.76183392,0,,,0,04/21/17,33,,,2.419143378,35.04141293,0,,,,,,9.772660985,-63.45110966,0,,,0,04/21/17,34,,,2.189407565,32.45210944,0,,,,,,10.54107721,-66.02160728,0,,,0,04/21/17,35,,,1.979927189,29.98889155,0,,,,,,11.32961159,-68.46786446,0,,,0,04/21/17,36,,,1.789280816,27.65524734,0,,,,,,12.13685861,-70.7861998,0,,,0,04/21/17,37,,,1.616087088,25.45303514,0,,,,,,12.96145083,-72.97458655,0,,,0,04/21/17,38,,,1.459013369,23.3826251,0,,,,,,13.8020678,-75.03250737,0,,,0,04/21/17,39,,,1.31678269,21.4430547,0,,,,,,14.65744326,-76.96079573,0,,,0,04/21/17,40,,,1.188179085,19.63219243,0,,,,,,15.52637071,-78.76146976,0,,,0,04/21/17,41,,,1.072051428,17.94690442,0,,,,,,16.40770738,-80.43756344,0,,,0,04/21/17,42,,,0.9673159048,16.38321946,0,,,,,,17.30037686,-81.99295982,0,,,0,04/21/17,43,,,0.8729572536,14.93648854,0,,,,,,18.20337049,-83.43222998,0,,,0,04/21/17,44,,,0.7880289387,13.60153573,0,,,,,,19.11574763,-84.76048086,0,,,0,04/21/17,45,,,0.7116524025,12.37279795,0,,,,,,20.03663497,-85.98321442,0,,,0,01/19/18,20,,,9.970776903,72.07469323,-18,,,,,,4.597068899,-25.68156576,-38,,,-56,01/19/18,22.5,,,8.777867367,67.05606199,0,,,,,,5.903590001,-30.4959004,0,,,0,01/19/18,25,,,7.715718142,62.10719319,105,,,,,,7.336013819,-35.28668908,-110,,,-5,01/19/18,30,,,5.93429523,52.6618241,-52,,,,,,10.534197,-44.50823757,0,,,-52,01/19/18,35,,,4.538179331,43.94945308,-13,,,,,,14.10979438,-53.07673397,0,,,-13,01/19/18,37,,,4.070969503,40.70531118,0,,,,,,15.62985881,-56.27896334,0,,,0,01/19/18,40,,,3.454802203,36.11988434,17,,,,,,17.99354859,-60.81471026,0,,,17,01/19/18,42,,,3.094909532,33.257057,0,,,,,,19.61968156,-63.65207841,0,,,0,01/19/18,45,,,2.622641453,29.26073604,0,,,,,,22.12584935,-67.62025744,0,,,0,01/19/18,47,,,2.348151879,26.79618845,0,,,,,,23.83668481,-70.07211068,0,,,0,01/19/18,50,,,1.989592315,23.39611235,12,,,,,,26.45581152,-73.4614255,0,,,12,01/19/18,55,,,1.512081653,18.49423799,0,,,,,,30.94070562,-78.365504,0,,,0,01/19/18,60,,,1.154348437,14.48020092,0,,,,,,35.5453938,-82.40473059,0,,,0,01/19/18,65,,,0.8876572041,11.25137324,0,,,,,,40.24162476,-85.68000379,0,,,0,01/19/18,70,,,0.6894001339,8.692470633,0,,,,,,45.00717996,-88.30528841,6,,,6,01/19/18,75,,,0.5421350264,6.687943913,0,,,,,,49.82493568,-90.39486672,0,,,0"


class globalClass: NSObject {

}