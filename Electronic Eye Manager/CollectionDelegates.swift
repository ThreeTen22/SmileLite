//
//  CollectionDelegates.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/3/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

struct FilterListingsCollectionDelegate {
   static func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
   static func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eyeBook.listings.count
    }
    
   static func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let listingSymbol = eyeBook.listings[index].listingSymbol
        
        let listingCell = collectionView.dequeueReusableCellWithReuseIdentifier("ListingCell", forIndexPath: indexPath)
        let listingButton = (listingCell.viewWithTag(1) as! ListingFilterButton)
        listingButton.setTitle(listingSymbol, forState: .Normal)
        listingButton.listingSymbol = listingSymbol
    
        return listingCell
    
    }
    
    
   static func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    }
}

struct MonthCollectionDelegate {
    static var readableDateformat:NSDateFormatter = {
        let newDateFormatter = NSDateFormatter()
        newDateFormatter.dateFormat = "MM/dd/yyyy"
        return newDateFormatter
    }()
    
    
   static func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    static func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if clientSuccess {
            //print("Success")
        }
        return eyeBook.listings[collectionView.tag].registeredMonthContainers.count + 1
    }
    
    static func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        unowned let monthCell = collectionView.dequeueReusableCellWithReuseIdentifier("MonthCell", forIndexPath: indexPath)
        if indexPath.row != 0 {
            let monthContainer = eyeBook.listings[collectionView.tag].registeredMonthContainers[indexPath.row - 1]
            (monthCell.viewWithTag(1) as! UILabel).text = monthContainer.expDateString
        }
        else {
            (monthCell.viewWithTag(1) as! UILabel).text = "Show All"
        }
        return monthCell
    }
    
    static func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedListing:Listing = eyeBook.listings[collectionView.tag]
        var tempUsingDemo = usingDemo
        tempUsingDemo = selectedListing.listingMaturities.isEmpty
        
        selectedListing.maturitiesToDisplay.removeAll()
        selectedListing.visibleStrikes.removeAll()
        

        if indexPath.row != 0 {
            //print("DEBUG: Inside ListingCell: ")
            selectedListing.willDisplay = Listing.DisplayType.FilteredStrikes
            
            let monthDate:String = (collectionView.cellForItemAtIndexPath(indexPath)?.viewWithTag(1) as! UILabel).text!
            
            weak var selectedMonthContainer = selectedListing.getContainerByDate(monthDate)
            
            selectedListing.maturitiesToDisplay.append((selectedMonthContainer?.expDate)!)
           
            for monthContainer in selectedListing.registeredMonthContainers {
                monthContainer.isActive = false
            }

            selectedMonthContainer!.isActive = true
        } else {
           
            if selectedListing.willDisplay == .AllStrikes {
                
                selectedListing.willDisplay = Listing.DisplayType.NoStrikes
            } else {
                
                selectedListing.willDisplay = Listing.DisplayType.AllStrikes
                
                for maturityJSON in selectedListing.listingMaturities {
                    
                    let edate = maturityJSON["edate"].stringValue
                    let newDate:NSDate = readableDateformat.dateFromString(edate)!
                    
                    selectedListing.maturitiesToDisplay.append(newDate)
                }
            }
            
        }
        
        if tempUsingDemo {
            let demoStrikeJSON = JSON.parse(adtnMonthDemoData)
            let secondDemoStrikeJSON = JSON.parse(anotheradtnMonthData)
            selectedListing.sortedAppend(demoStrikeJSON.arrayValue)
            selectedListing.sortedAppend(secondDemoStrikeJSON.arrayValue)
        } else {
            for date in selectedListing.maturitiesToDisplay {
                let jsonRaw = getStrikes(clientSuccess, errmsg: clientErrmsg, client: client, listingID: selectedListing.listingId, expDate: date)!
                //print(jsonRaw)
                let maturityRawJSON = JSON.parse(jsonRaw)
                let symID = "\(selectedListing.listingSymbol):\(selectedListing.listingId)"
                let symDate = readableDateformat.stringFromDate(date)
                let maturityJSONArray = maturityRawJSON["payload"][symID][symDate]["rows"].arrayValue
                selectedListing.sortedAppend(maturityJSONArray)
            }
        }
        
        (collectionView.delegate as! EyeBookViewController).eyeBookTableView.reloadData()
    }
    
}


struct StrikeCollectionDelegate {
    
    static let dateColor:UIColor = UIColor.blueColor()
    static let putDelta:String = "PutDelta"
    static let callDelta:String = "CallDelta"
    static let error:String = "ERROR"
    static let cTheo:String = "cTheo"
    static let pTheo:String = "PTheo"
    static let oDate:String = "odate"
    static let strike:String = "strike"
    static let callInventory:String = "CallInventory"
    static let putInventory:String = "PutInventory"
    static let inventory:String = "Inventory"
    static let put:String = "Put"
    static let nonSelectableStrikeCellReuse:String = "OtherStrikeCell"
    static let strikeCellReuse:String = "StrikeCell"
    
    static func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    static func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let listing = eyeBook.listings[collectionView.tag]
        let listingStrikesCount = (listing.visibleStrikes.count * 18)
        //print("LISTING STRIKES COUNT:  \(listingStrikesCount)")
        
        return listingStrikesCount
    }
    
    static func collectionView(collectionView:UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let modIndx = indexPath.row%18
        let strikeType:StrikeType = StrikeCellOrder.strikeCellTypeAt(modIndx)
        let floorIndx =  Int(floor(Double(indexPath.row/18)))
        

        let strikeCell:StrikeCollectionViewCell = {
            switch strikeType {
            case .buycallmonthqe, .buycallstrikeqe, .sellcallstrikeqe, .sellcallmonthqe, .buyputmonthqe, .buyputstrikeqe, .sellputstrikeqe, .sellputmonthqe:
                return (collectionView.dequeueReusableCellWithReuseIdentifier(strikeCellReuse, forIndexPath: indexPath) as! StrikeCollectionViewCell)
            default:
                return (collectionView.dequeueReusableCellWithReuseIdentifier(nonSelectableStrikeCellReuse, forIndexPath: indexPath) as! StrikeCollectionViewCell)
                
            }
        }()
        
        //let strikeCell:StrikeCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier(strikeCellReuse, forIndexPath: indexPath) as! StrikeCollectionViewCell)
        let strikeLabel = (strikeCell.viewWithTag(1) as! UILabel)
        let strikeTF = (strikeCell.viewWithTag(2) as? UITextField)
        
        var useDefaultColoring = false
        var labelText = ""
        
        let listing = eyeBook.listings[collectionView.tag]
        //print("cellforrow:collectionviewTag \(collectionView.tag)")
        
        strikeTF?.backgroundColor = UIColor.clearColor()
        
        
        if floorIndx >= listing.visibleStrikes.count {
            return strikeCell
        }
        let strikeJSON = listing.visibleStrikes[floorIndx]
        
        strikeCell.listingIndex = collectionView.tag
        strikeCell.floorIndex = floorIndx
        
        strikeCell.cellType = strikeType
        
        switch strikeType {
        case .maturity:
            let currentMonth = smileDateFormat.dateFromString(strikeJSON[oDate].stringValue)!
            let currentMaturityIndex = listing.getMaturityIndex(currentMonth)
            labelText = formatMonth(currentMonth)
            //labelText = currentDateString
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.maturity, altMaturity: isEven(currentMaturityIndex))
        case .strike:
            let currentMonth = smileDateFormat.dateFromString(strikeJSON[oDate].stringValue)!
            let currentMaturityIndex = listing.getMaturityIndex(currentMonth)
            labelText = strikeJSON[strike].stringValue
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.strike, altMaturity: isEven(currentMaturityIndex))
        case .calltheo, .puttheo:
            switch modIndx {
            case 4:
                //strikeLabel.text = strikeJSON[""]
                labelText = cTheo
            case 12:
                labelText = pTheo
            default:
                labelText = error
            }
            strikeCell.backgroundColor = UIColor.lightGrayColor()
            strikeLabel.textColor = UIColor.blackColor()
            
        case .calldelta, .putdelta:
            var number:Double = 0.0
            switch modIndx {
            case 5:
                number = numberOrZero(Double(strikeJSON[callDelta].stringValue)!) * 100.0
                labelText = String(number)
            case 13:
                number = Double(strikeJSON[putDelta].stringValue)! * 100.0
                if number > 0.0 {
                    number = 0.0
                }
                labelText = String(number)
            default:
                labelText = error
            }
            strikeCell.backgroundColor = UIColor(red:1.00, green:0.93, blue:0.78, alpha:1.0)
            strikeLabel.textColor = UIColor.blackColor()
            
        case .defaultcell:
            let currentMonth = smileDateFormat.dateFromString(strikeJSON[oDate].stringValue)!
            let currentMaturityIndex = listing.getMaturityIndex(currentMonth)
            labelText = strikeJSON[strike].stringValue
            //useDefaultColoring = true
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.strike, altMaturity: isEven(currentMaturityIndex))
        case .callinventory, .putinventory, .inventory:
            switch modIndx {
            case 6:
                labelText = strikeJSON[callInventory].stringValue
            case 14:
                labelText = strikeJSON[putInventory].stringValue
            case 17:
                labelText = strikeJSON[inventory].stringValue
            default:
                labelText = error
            }
            strikeCell.backgroundColor = UIColor.greenColor()
            strikeLabel.textColor = UIColor.blackColor()
            
        case .buycallmonthqe:
            let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buycall, lookupDelta: callDelta)
            if success {
                labelText = "\(mq)|\(e)"
            }
            useDefaultColoring = true
        case .buycallstrikeqe:
            let (success, q, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buycall, lookupDelta: nil)
            if success {
                labelText = "\(q)|\(e)"
            }
            useDefaultColoring = true
        case .sellcallstrikeqe:
            let (success, q, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellcall, lookupDelta: nil)
            if success {
                labelText = "\(q)|\(e)"
            }
            useDefaultColoring = true
        case .sellcallmonthqe:
            let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellcall, lookupDelta: callDelta)
            if success {
                labelText = "\(mq)|\(e)"
            }
            useDefaultColoring = true
        case .buyputmonthqe:
            let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buyput, lookupDelta: putDelta)
            if success {
                labelText = "\(mq)|\(e)"
            }
            useDefaultColoring = true
        case .buyputstrikeqe:
            let (success, q, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buyput, lookupDelta: nil)
            if success {
                labelText = "\(q)|\(e)"
            }
            useDefaultColoring = true
        case .sellputstrikeqe:
            let (success, q, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellput, lookupDelta: nil)
            if success {
                labelText = "\(q)|\(e)"
            }
            useDefaultColoring = true
        case .sellputmonthqe:
            let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellput, lookupDelta: putDelta)
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
            strikeLabel.text = removeAfterCharacter(Source: labelText, Character: dotChar, CutOffIndex: 1)
        case 5,9,13:
            strikeLabel.text = removeAfterCharacter(Source: labelText, Character: dotChar, CutOffIndex: 2)
        default:
            strikeLabel.text = labelText
        }
        
        if useDefaultColoring {
            Layout.setLayout(strikeCell, label: strikeLabel, type: .defaultcell)
        }
        
        //strikeLabel.text = "\(modIndx)"
        return strikeCell
    }
    
    static func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //let cell = collectionView.cellForItemAtIndexPath(indexPath) as! StrikeCollectionViewCell
        //unowned let strikesCollectionView:StrikeCollectionView = (collectionView as! StrikeCollectionView)
        
        //strikesCollectionView.currentIndexPath = indexPath
        //(collectionView.delegate as! UIViewController).shouldPerformSegueWithIdentifier("selectEye", sender: strikesCollectionView)
    }
    
    static func formatMonth(currentDate:NSDate) -> String {
        //currentStrikeMonth = currentDate
        return smileDateFormat.stringFromDate(currentDate)
    }
    
    static func getEyeInfo(listing:Listing, json strikeJSON:JSON, orderType:Order, lookupDelta:String? = nil) -> (Bool, String, String) {
        var q = ""
        var e = ""
        var success = false
        
        if let curMonthContainer = listing.getContainerByDate(strikeJSON[oDate].stringValue) {
            if lookupDelta != nil {
                if let curMonthEye = curMonthContainer.GetMonthByOrder(orderType) {
                    if let curDeltaRaw =  Double(strikeJSON[lookupDelta!].stringValue) {
                        let eyeParams = curMonthEye.eyeParams
                        var curLowDelta = eyeParams.minDelta.asDouble()!/100.0
                        var curHighDelta = eyeParams.maxDelta.asDouble()!/100.0
                        var curDelta = curDeltaRaw
                        if lookupDelta!.containsString(put) {
                            curDelta = abs(curDelta)
                            curLowDelta = abs(curLowDelta)
                            curHighDelta = abs(curHighDelta)
                        }
                        //print("curDelta: \(curDelta)  \(curLowDelta)  \(curHighDelta)")
                        if curDelta >= curLowDelta && curDelta <= curHighDelta  {
                        //print("DEBUG: Month DELEGATE:  Currently GETTING \(curMonthEye.cmdType) MQ/E  - lowdelta: \(curMonthEye.minDelta) - highdelta: \(curMonthEye.maxDelta) ")
                            success = true
                            q = eyeParams.quantity
                            //e = eyeParams.minEdge
                            e = eyeParams.minEdgeF
                            //e = removeBeforeCharacter(Source: e, Character: dotChar)
                            
                        }
                    }
                }
            } else {
                //print("trying STRIKE DELEGATE  - \(strikeJSON["strike"].stringValue)")
                if let curStrikeEyes = curMonthContainer.GetStrikesByOrder(orderType) {
                    if let curStrikeDbl = strikeJSON[strike].double {
                        for strike in curStrikeEyes {
                            let eyeParams = strike.eyeParams
                            if strike.strike == curStrikeDbl {
                                //print("DEBUG: STRIKE DELEGATE:  Currently GETTING \(orderType) Q/E ")
                                success = true
                                q = eyeParams.quantity
                                //e = eyeParams.minEdge
                                e = eyeParams.minEdgeF
                                //e = removeBeforeCharacter(Source: e, Character: dotChar)
                                
                            }
                        }
                    }
                }
            }
            
        }
        return (success, q, e)
    }
}


struct XONStrikeCollectionDelegate {
    
    static func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    static func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return xonListingArray.count - 18
    }
    
    static func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let modIndx = indexPath.row%18
        //let floorIndx =  Int(floor(Double(indexPath.row/18)))
        unowned let strikeCell = (collectionView.dequeueReusableCellWithReuseIdentifier("StrikeCell", forIndexPath: indexPath) as! StrikeCollectionViewCell)
        unowned let strikeLabel = (strikeCell.viewWithTag(1) as! UILabel)
        //let listing = eyeBook.listings[collectionView.tag]
        strikeLabel.text = xonListingArray[indexPath.row+18]
        switch modIndx {
        case 0:
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.maturity, altMaturity: isEven(modIndx))
        case 1:
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.strike, altMaturity: isEven(modIndx))
        case 4, 12:
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.calltheo)
        case 6, 14, 17:
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.position)
        case 2:
            strikeCell.cellType = StrikeType.buycallmonthqe
            Layout.setDefaultLayout(strikeCell, label: strikeLabel)
        case 3:
            strikeCell.cellType = StrikeType.buycallstrikeqe
            Layout.setDefaultLayout(strikeCell, label: strikeLabel)
        case 7:
            strikeCell.cellType = StrikeType.sellcallstrikeqe
            Layout.setDefaultLayout(strikeCell, label: strikeLabel)
        case 8:
            strikeCell.cellType = StrikeType.sellcallmonthqe
            Layout.setDefaultLayout(strikeCell, label: strikeLabel)
        case 10:
            strikeCell.cellType = StrikeType.buyputmonthqe
            Layout.setDefaultLayout(strikeCell, label: strikeLabel)
        case 11:
            strikeCell.cellType = StrikeType.buyputstrikeqe
            Layout.setDefaultLayout(strikeCell, label: strikeLabel)
        case 15:
            strikeCell.cellType = StrikeType.sellputstrikeqe
            Layout.setDefaultLayout(strikeCell, label: strikeLabel)
        case 16:
            strikeCell.cellType = StrikeType.sellputmonthqe
            Layout.setDefaultLayout(strikeCell, label: strikeLabel)
        default:
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.defaultcell)
        }
        
        strikeCell.floorIndex = 0
        strikeCell.listingIndex = 0
        
        return strikeCell
        
    }
    
    static func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        unowned let strikesCollectionView:StrikeCollectionView = (collectionView as! StrikeCollectionView)
        strikesCollectionView.currentIndexPath = indexPath
    }
}
