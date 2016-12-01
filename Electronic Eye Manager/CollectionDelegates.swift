//
//  CollectionDelegates.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/3/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

public struct FilterListingsCollectionDelegate {
   public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
   public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eyeBook.listings.count
    }
    
   public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let listingSymbol = eyeBook.listings[index].listingsymbol
        
        let listingCell = collectionView.dequeueReusableCellWithReuseIdentifier("ListingCell", forIndexPath: indexPath)
        let listingButton = (listingCell.viewWithTag(1) as! ListingFilterButton)
        listingButton.setTitle(listingSymbol, forState: .Normal)
        listingButton.listingSymbol = listingSymbol
    
        return listingCell
        //return oldCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }
    
    
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    }
}


public struct MonthCollectionDelegate {
    var readableDateformat:NSDateFormatter = NSDateFormatter()
    
    func initalize() {
        readableDateformat.dateFormat = "MM/dd/yyyy"
    }
    
   func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if clientSuccess {
            print("Success")
        }
        return eyeBook.listings[collectionView.tag].registeredMonthContainers.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let monthCell = collectionView.dequeueReusableCellWithReuseIdentifier("MonthCell", forIndexPath: indexPath)
        if indexPath.row != 0 {
            let monthContainer = eyeBook.listings[collectionView.tag].registeredMonthContainers[indexPath.row - 1]
            (monthCell.viewWithTag(1) as! UILabel).text = monthContainer.expDateString
        }
        else {
            (monthCell.viewWithTag(1) as! UILabel).text = "Show All"
        }
        return monthCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, viewController vc:EyeBookViewController) {
        let selectedListing = eyeBook.listings[collectionView.tag]
        var jsonArray:Array = [JSON]()
        
        selectedListing.maturitiesToDisplay.removeAll()
        selectedListing.visibleStrikes.removeAll()
        
        print("DEBUG: COLLECTIONVIEW DID SELECT ITEM: ")
        print("selected Listing: \(selectedListing.listingsymbol)")
        if indexPath.row != 0 {
            print("DEBUG: Inside ListingCell: ")
            selectedListing.willDisplay = Listing.DisplayType.FilteredStrikes
            
            let monthDate:String = (collectionView.cellForItemAtIndexPath(indexPath)?.viewWithTag(1) as! UILabel).text!
            let selectedMonthContainer = selectedListing.getContainerByDate(monthDate)
            
            selectedListing.maturitiesToDisplay.append((selectedMonthContainer?.expDate)!)
            
            for monthContainer in selectedListing.registeredMonthContainers {
                monthContainer.isActive = false
            }

            selectedMonthContainer!.isActive = true
        } else {
            print("DEBUG: Inside StrikesCell: ")
            if selectedListing.willDisplay == .AllStrikes {
                print("allstrikes: \(selectedListing.willDisplay)")
                selectedListing.willDisplay = Listing.DisplayType.NoStrikes
            } else {
                print("nostrikes: \(selectedListing.willDisplay)")
                selectedListing.willDisplay = Listing.DisplayType.AllStrikes
                for maturityJSON in selectedListing.listingMaturities {
                    print(maturityJSON["edate"].stringValue)
                    selectedListing.maturitiesToDisplay.append(readableDateformat.dateFromString(maturityJSON["edate"].stringValue)!)
                }
            }
            
        }
        if clientSuccess {
            for date in selectedListing.maturitiesToDisplay {
                let jsonRaw = getStrikes(clientSuccess, errmsg: clientErrmsg, client: client, listingID: selectedListing.listingId, expDate: date)!
                let maturityRawJSON = JSON.parse(jsonRaw)
                let symID = "\(selectedListing.listingsymbol):\(selectedListing.listingId)"
                let symDate = readableDateformat.stringFromDate(date)
                let maturityJSONArray = maturityRawJSON["payload"][symID][symDate]["rows"].arrayValue
                selectedListing.visibleStrikes.appendContentsOf(maturityJSONArray)
            }
        }
        
        print("TEST")
        //print(selectedListing.visibleStrikes)
        
        vc.eyeBookTableView.reloadData()
    }
    
}


struct StrikeCollectionDelegate {
    
    var dateColor:UIColor = UIColor.blueColor()
    
    
   func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let listing = eyeBook.listings[collectionView.tag]
        let listingStrikesCount = (listing.visibleStrikes.count * 18)+18
        print("LISTING STRIKES COUNT:  \(listingStrikesCount)")
        
        return listingStrikesCount
    }
    
    func collectionView(collectionView:UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let modIndx = indexPath.row%18
        let floorIndx =  Int(floor(Double(indexPath.row/18)))
        let strikeCell = collectionView.dequeueReusableCellWithReuseIdentifier("StrikeCell", forIndexPath: indexPath)
        let strikeLabel = (strikeCell.viewWithTag(1) as! UILabel)
        
        var useDefaultColoring = false
        var labelText = ""
        
        if indexPath.row < 18 {
            strikeLabel.text = xonListingArray[indexPath.row]
            CellLayout.setLayout(strikeCell, label: strikeLabel, type: CellType.Title)
        } else {
            let listing = eyeBook.listings[collectionView.tag]
            let strikeJSON = listing.visibleStrikes[floorIndx-1]
            
            strikeLabel.text = ""
            
            switch modIndx {
            case 0:
                let currentMonth = smileDateFormat.dateFromString(strikeJSON["odate"].stringValue)!
                let currentMaturityIndex = listing.getMaturityIndex(currentMonth)
                labelText = formatMonth(currentMonth)
                //labelText = currentDateString
                CellLayout.setLayout(strikeCell, label: strikeLabel, type: CellType.Maturity, altMaturity: isEven(currentMaturityIndex))
            case 1:
                let currentMonth = smileDateFormat.dateFromString(strikeJSON["odate"].stringValue)!
                let currentMaturityIndex = listing.getMaturityIndex(currentMonth)
                labelText = strikeJSON["strike"].stringValue
                CellLayout.setLayout(strikeCell, label: strikeLabel, type: CellType.Strike, altMaturity: isEven(currentMaturityIndex))
            case 4, 12:
                switch modIndx {
                case 4:
                    //strikeLabel.text = strikeJSON[""]
                    labelText = "CTheo"
                case 12:
                    labelText = "PTheo"
                default:
                    labelText = "ERROR"
                }
                strikeCell.backgroundColor = UIColor.lightGrayColor()
                strikeLabel.textColor = UIColor.blackColor()
                
            case 5, 13:
                switch modIndx {
                    case 5:
                       labelText = strikeJSON["CallDelta"].stringValue
                    case 13:
                        labelText = strikeJSON["PutDelta"].stringValue
                    default:
                        labelText = "ERROR"
                }
                strikeCell.backgroundColor = UIColor(red:1.00, green:0.93, blue:0.78, alpha:1.0)
                strikeLabel.textColor = UIColor.blackColor()
                
            case 9:
                useDefaultColoring = true
            case 6, 14, 17:
                switch modIndx {
                case 6:
                    labelText = strikeJSON["CallInventory"].stringValue
                case 14:
                    labelText = strikeJSON["PutInventory"].stringValue
                case 17:
                    labelText = strikeJSON["Inventory"].stringValue
                default:
                    labelText = "ERROR"
                }
                strikeCell.backgroundColor = UIColor.greenColor()
                strikeLabel.textColor = UIColor.blackColor()
            
            case 2:
                let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buyCall, lookupDelta: "CallDelta")
                if success {
                    labelText = "\(mq)|\(e)"
                }
                useDefaultColoring = true
            case 3:
                let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buyCall, lookupDelta: nil)
                if success {
                    labelText = "\(mq)|\(e)"
                }
                useDefaultColoring = true
            case 7:
                let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellCall, lookupDelta: nil)
                if success {
                    labelText = "\(mq)|\(e)"
                }
                useDefaultColoring = true
            case 8:
                let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellCall, lookupDelta: "CallDelta")
                if success {
                    labelText = "\(mq)|\(e)"
                }
                useDefaultColoring = true
            case 9:
                let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buyPut, lookupDelta: "PutDelta")
                if success {
                    labelText = "\(mq)|\(e)"
                }
                useDefaultColoring = true
            case 10:
                let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buyPut, lookupDelta: nil)
                if success {
                    labelText = "\(mq)|\(e)"
                }
                useDefaultColoring = true
            case 11:
                let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellPut, lookupDelta: nil)
                if success {
                    labelText = "\(mq)|\(e)"
                }
                useDefaultColoring = true
            case 12:
                let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellPut, lookupDelta: "PutDelta")
                if success {
                    labelText = "\(mq)|\(e)"
                }
                useDefaultColoring = true
            default:
                //strikeLabel.text = "ERROR"
                useDefaultColoring = true
            }
            
            
            switch modIndx {
            case 1:
                strikeLabel.text = removeAfterCharacter(Source: labelText, Character: ".", CutOffIndex: 1)
            case 5,13:
                strikeLabel.text = removeAfterCharacter(Source: labelText, Character: ".", CutOffIndex: 2)
            default:
                strikeLabel.text = labelText
            }
            
            if useDefaultColoring {
                CellLayout.setLayout(strikeCell, label: strikeLabel, type: .Default)
            }
        }
        return strikeCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! StrikeCollectionViewCell
        let strikesCollectionView:StrikeCollectionView = (collectionView as! StrikeCollectionView)
        strikesCollectionView.currentIndexPath = indexPath
        (collectionView.delegate as! UIViewController).shouldPerformSegueWithIdentifier("selectEye", sender: strikesCollectionView)
    }
    
    func formatMonth(currentDate:NSDate) -> String {
        //currentStrikeMonth = currentDate
        return smileDateFormat.stringFromDate(currentDate)
    }
    
    func getEyeInfo(listing:Listing, json strikeJSON:JSON, orderType:Order, lookupDelta:String?) -> (Bool, String, String) {
        var q = ""
        var e = ""
        var success = false
        if let curMonthContainer = listing.getContainerByDate(strikeJSON["odate"].stringValue) {
            if lookupDelta != nil {
                if let curMonthEye = curMonthContainer.GetMonthByOrder(orderType) {
                    if let curDelta =  Double(strikeJSON[lookupDelta!].stringValue) {
                        let curDeltaAbs = abs(curDelta)
                        if curDeltaAbs >= (curMonthEye.lowDelta/100) && ((curDeltaAbs <= (curMonthEye.highDelta/100)) || curDeltaAbs > 1.0)  {
                            print("DEBUG: STRIKE DELEGATE:  Currently GETTING \(orderType) MQ/E ")
                            success = true
                            q = "\(curMonthEye.quantity)"
                            e = "\(curMonthEye.minEdge)"
                            
                        }
                    }
                }
            } else {
                if let curStrikeEyes = curMonthContainer.GetStrikesByOrder(orderType) {
                    if let curStrikeDbl = Double(strikeJSON["strike"].stringValue) {
                        for strike in curStrikeEyes {
                            if strike.strike == curStrikeDbl {
                                print("DEBUG: STRIKE DELEGATE:  Currently GETTING \(orderType) Q/E ")
                                success = true
                                q = "\(strike.quantity)"
                                e = "\(strike.minEdge)"
                            }
                        }
                    }
                }
            }
            
        }
        return (success, q, e)
    }
    

}


public struct XONStrikeCollectionDelegate {
    
    var currentMonth = ""
    var isEvenMonth = false
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return xonListingArray.count - 18
    }
    
    mutating func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let modIndx = indexPath.row%18
        //let floorIndx =  Int(floor(Double(indexPath.row/18)))
        let strikeCell = collectionView.dequeueReusableCellWithReuseIdentifier("StrikeCell", forIndexPath: indexPath)
        let strikeLabel = (strikeCell.viewWithTag(1) as! UILabel)
        //let listing = eyeBook.listings[collectionView.tag]
        strikeLabel.text = xonListingArray[indexPath.row+18]
        
        switch modIndx {
        case 0:
           CellLayout.setLayout(strikeCell, label: strikeLabel, type: CellType.Maturity, altMaturity: isEven(modIndx))
        case 1:
           CellLayout.setLayout(strikeCell, label: strikeLabel, type: CellType.Strike, altMaturity: isOdd(modIndx))
        case 4, 12:
           CellLayout.setLayout(strikeCell, label: strikeLabel, type: CellType.CallTheo)
        case 6, 14, 17:
           CellLayout.setLayout(strikeCell, label: strikeLabel, type: CellType.Position)
        default:
           CellLayout.setLayout(strikeCell, label: strikeLabel, type: CellType.Default)
        }
        
        return strikeCell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let strikesCollectionView:StrikeCollectionView = (collectionView as! StrikeCollectionView)
        strikesCollectionView.currentIndexPath = indexPath
        //(collectionView.delegate as! UIViewController).shouldPerformSegueWithIdentifier("selectEye", sender: strikesCollectionView)
        cell?.becomeFirstResponder()
    }
}

public struct CellLayout {
    
    static var strikeTitleBGColor = UIColor(red255: 2.0, green: 13.0, blue: 130.0, alpha: 1.0)
    
    static var strikeMaturityBGColorDark = UIColor(red255: 25.0, green: 29.0, blue: 113.0, alpha: 1.0)
    static var strikeMaturityBGColorLight = UIColor(red255: 74.0, green: 60.0, blue: 138.0, alpha: 1.0)
    
    static var strikeDefaultBGColor = UIColor.whiteColor()
    static var strikeDefaultTextColorDark = UIColor.blackColor()
    
    static var strikeDefaultTextColorLight = UIColor.whiteColor()
    
    
    static var strikePositionBGColor = UIColor(red255: 41.0, green: 250.0, blue: 46.0, alpha: 1.0)
    static var strikePositionTextColorLong = UIColor.blueColor()
    static var strikePositionTextColorShort = UIColor.redColor()
    
    static var strikeTheoBGColorNeutral = UIColor.lightGrayColor()
    static var strikeTheoBGColorAboveValue = UIColor.blueColor()
    static var strikeTheoBGColorBelowValue = UIColor.redColor()
    
    static var monthEyeBGColor = UIColor(red255: 205.0, green: 205.0, blue: 225.0, alpha: 1.0)
    
    static var monthEyeInstallBGColor =  UIColor(rgb: 0x006600)
    static var monthEyeTheoButtonBGColor = UIColor(rgb: 0x99cccc)
    
    static var errorColor = UIColor(red255: 253.0, green: 123.0, blue: 88.0, alpha: 1.0)
    
    
    
    static func setLayout(cell:UIView, label:UILabel, type:CellType, altMaturity:Bool = false) {
        switch type {
        case .Maturity, .Strike:
            if altMaturity {
                cell.backgroundColor = strikeMaturityBGColorLight
            } else {
                cell.backgroundColor = strikeMaturityBGColorDark
            }
            label.textColor = strikeDefaultTextColorLight
        case .CallDelta:
            cell.backgroundColor = strikeDefaultBGColor
            label.textColor = strikeDefaultTextColorDark
        case .Title:
            label.font = label.font.fontWithSize(12.0)
            cell.backgroundColor = strikeTitleBGColor
            label.textColor = strikeDefaultTextColorLight
            
        case .Position, .CallPosition, .PutPosition:
            cell.backgroundColor = strikePositionBGColor
            switch getPosition(label) {
            case .Neutral:
                label.textColor = strikeDefaultTextColorDark
            case .Long:
                label.textColor = strikePositionTextColorLong
            case .Short:
                label.textColor = strikePositionTextColorShort
            default:
                label.textColor = errorColor
                label.text = "ERROR"
            }
        case .CallTheo, .PutTheo:
            cell.backgroundColor = strikeTheoBGColorNeutral
            label.textColor = strikeDefaultTextColorDark
        default:
            cell.backgroundColor = strikeDefaultBGColor
            label.textColor = strikeDefaultTextColorDark
        }
        
    }
    
    static func getPosition(label:UILabel) -> Position {
        if let labelText = label.text {
            if let curPos = Int(labelText) {
                if curPos > 0 {
                    return Position.Long
                }
                if curPos < 0 {
                    return Position.Short
                }
                return Position.Neutral
            }
            print("ERROR: setLayout.getPosition - error unwrapping curPos")
            return Position.NULL
        }
        print("ERROR: setLayout.getPosition - error unwrapping labeltext")
        return Position.NULL
    }
    
}
