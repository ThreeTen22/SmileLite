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
        //var jsonArray:Array = [JSON]()
        var tempUsingDemo = usingDemo
        tempUsingDemo = selectedListing.listingMaturities.isEmpty
        
        selectedListing.maturitiesToDisplay.removeAll()
        selectedListing.visibleStrikes.removeAll()
        
        //print("DEBUG: COLLECTIONVIEW DID SELECT ITEM: ")
        //print("selected Listing: \(selectedListing.listingSymbol)    \(usingDemo)")
        if indexPath.row != 0 {
            //print("DEBUG: Inside ListingCell: ")
            selectedListing.willDisplay = Listing.DisplayType.FilteredStrikes
            
            let monthDate:String = (collectionView.cellForItemAtIndexPath(indexPath)?.viewWithTag(1) as! UILabel).text!
            weak var selectedMonthContainer = selectedListing.getContainerByDate(monthDate)
            //print(selectedMonthContainer)
            selectedListing.maturitiesToDisplay.append((selectedMonthContainer?.expDate)!)
            //print(selectedListing.maturitiesToDisplay)
            for monthContainer in selectedListing.registeredMonthContainers {
                monthContainer.isActive = false
            }

            selectedMonthContainer!.isActive = true
        } else {
            //print("DEBUG: Inside MonthCollection: ")
            if selectedListing.willDisplay == .AllStrikes {
                //print("allstrikes: \(selectedListing.willDisplay)")
                selectedListing.willDisplay = Listing.DisplayType.NoStrikes
            } else {
                //print("nostrikes: \(selectedListing.willDisplay)")
                selectedListing.willDisplay = Listing.DisplayType.AllStrikes
                for maturityJSON in selectedListing.listingMaturities {
                    let edate = maturityJSON["edate"].stringValue
                    //print("edate: \(edate)")
                    let newDate:NSDate = readableDateformat.dateFromString(edate)!
                    //print("newdate:  \(newDate)")
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
        
        //print("selectedListingmaturities: \(selectedListing.listingMaturities) \n\n\n selectedlstingStrikes: \(selectedListing.visibleStrikes)")
        
        //collectionView.reloadData()
        /*
        let nsCount: NSMutableIndexSet = NSMutableIndexSet()
        for i in 0..<(collectionView.delegate as! EyeBookViewController).numberOfSectionsInTableView((collectionView.delegate as! EyeBookViewController).eyeBookTableView) {
            nsCount.addIndex(i)
        }
        (collectionView.delegate as! EyeBookViewController).eyeBookTableView.beginUpdates()
        (collectionView.delegate as! EyeBookViewController).eyeBookTableView.reloadSections(nsCount, withRowAnimation: .Automatic)
        //(collectionView.delegate as! EyeBookViewController).eyeBookTableView.reloadData()
        (collectionView.delegate as! EyeBookViewController).eyeBookTableView.endUpdates()
         */
        (collectionView.delegate as! EyeBookViewController).eyeBookTableView.reloadData()
    }
    
}


struct StrikeCollectionDelegate {
    
   static let dateColor:UIColor = UIColor.blueColor()
    
    
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
        let floorIndx =  Int(floor(Double(indexPath.row/18)))
        let strikeCell = (collectionView.dequeueReusableCellWithReuseIdentifier("StrikeCell", forIndexPath: indexPath) as! StrikeCollectionViewCell)
        let strikeLabel = (strikeCell.viewWithTag(1) as! UILabel)
        
        var useDefaultColoring = false
        var labelText = ""
        
        let listing = eyeBook.listings[collectionView.tag]
        //print("cellforrow:collectionviewTag \(collectionView.tag)")
        if floorIndx >= listing.visibleStrikes.count {
            return strikeCell
        }
        let strikeJSON = listing.visibleStrikes[floorIndx]
        
        strikeCell.listingIndex = collectionView.tag
        strikeCell.floorIndex = floorIndx
        
        strikeLabel.text = ""
        
        //strikeCell.viewWithTag(1)
        
        switch modIndx {
        case 0:
            let currentMonth = smileDateFormat.dateFromString(strikeJSON["odate"].stringValue)!
            let currentMaturityIndex = listing.getMaturityIndex(currentMonth)
            labelText = formatMonth(currentMonth)
            //labelText = currentDateString
            strikeCell.cellType = StrikeType.date
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.maturity, altMaturity: isEven(currentMaturityIndex))
        case 1:
            let currentMonth = smileDateFormat.dateFromString(strikeJSON["odate"].stringValue)!
            let currentMaturityIndex = listing.getMaturityIndex(currentMonth)
            labelText = strikeJSON["strike"].stringValue
            strikeCell.cellType = StrikeType.strike
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.strike, altMaturity: isEven(currentMaturityIndex))
        case 4, 12:
            switch modIndx {
            case 4:
                //strikeLabel.text = strikeJSON[""]
                labelText = "CTheo"
                strikeCell.cellType = StrikeType.calltheo
            case 12:
                labelText = "PTheo"
                strikeCell.cellType = StrikeType.puttheo
            default:
                labelText = "ERROR"
                strikeCell.cellType = StrikeType.null
            }
            strikeCell.backgroundColor = UIColor.lightGrayColor()
            strikeLabel.textColor = UIColor.blackColor()
            
        case 5, 13:
            var number:Double = 0.0
            switch modIndx {
                case 5:
                   number = numberOrZero(Double(strikeJSON["CallDelta"].stringValue)!) * 100.0
                   labelText = "\(number)"
                   strikeCell.cellType = StrikeType.calldelta
                case 13:
                    number = Double(strikeJSON["PutDelta"].stringValue)! * 100.0
                    if number > 0.0 {
                        number = 0.0
                    }
                    labelText = "\(number)"
                    strikeCell.cellType = StrikeType.putdelta
                default:
                    labelText = "ERROR"
                    strikeCell.cellType = StrikeType.null
            }
            strikeCell.backgroundColor = UIColor(red:1.00, green:0.93, blue:0.78, alpha:1.0)
            strikeLabel.textColor = UIColor.blackColor()
            
        case 9:
            let currentMonth = smileDateFormat.dateFromString(strikeJSON["odate"].stringValue)!
            let currentMaturityIndex = listing.getMaturityIndex(currentMonth)
            labelText = strikeJSON["strike"].stringValue
            //useDefaultColoring = true
            strikeCell.cellType = StrikeType.defaultcell
            Layout.setLayout(strikeCell, label: strikeLabel, type: StrikeType.strike, altMaturity: isEven(currentMaturityIndex))
        case 6, 14, 17:
            switch modIndx {
            case 6:
                labelText = strikeJSON["CallInventory"].stringValue
                strikeCell.cellType = .callinventory
            case 14:
                labelText = strikeJSON["PutInventory"].stringValue
                strikeCell.cellType = .putinventory
            case 17:
                labelText = strikeJSON["Inventory"].stringValue
                strikeCell.cellType = .inventory
            default:
                labelText = "ERROR"
                strikeCell.cellType = .null
            }
            strikeCell.backgroundColor = UIColor.greenColor()
            strikeLabel.textColor = UIColor.blackColor()
        
        case 2:
            let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buycall, lookupDelta: "CallDelta")
            if success {
                labelText = "\(mq)|\(e)"
            }
            useDefaultColoring = true
            strikeCell.cellType = StrikeType.buycallmonthqe
        case 3:
            let (success, q, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buycall, lookupDelta: nil)
            if success {
                labelText = "\(q)|\(e)"
            }
            useDefaultColoring = true
            strikeCell.cellType = StrikeType.buycallstrikeqe
        case 7:
            let (success, q, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellcall, lookupDelta: nil)
            if success {
                labelText = "\(q)|\(e)"
            }
            useDefaultColoring = true
            strikeCell.cellType = StrikeType.sellcallstrikeqe
        case 8:
            let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellcall, lookupDelta: "CallDelta")
            if success {
                labelText = "\(mq)|\(e)"
            }
            useDefaultColoring = true
            strikeCell.cellType = StrikeType.sellcallmonthqe
        case 10:
            let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buyput, lookupDelta: "PutDelta")
            if success {
                labelText = "\(mq)|\(e)"
            }
            useDefaultColoring = true
            strikeCell.cellType = StrikeType.buyputmonthqe
        case 11:
            let (success, q, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.buyput, lookupDelta: nil)
            if success {
                labelText = "\(q)|\(e)"
            }
            useDefaultColoring = true
            strikeCell.cellType = StrikeType.buyputstrikeqe
        case 15:
            let (success, q, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellput, lookupDelta: nil)
            if success {
                labelText = "\(q)|\(e)"
            }
            useDefaultColoring = true
            strikeCell.cellType = StrikeType.sellputstrikeqe
        case 16:
            let (success, mq, e) = getEyeInfo(listing, json:  strikeJSON, orderType:  Order.sellput, lookupDelta: "PutDelta")
            if success {
                labelText = "\(mq)|\(e)"
            }
            useDefaultColoring = true
            strikeCell.cellType = StrikeType.sellputmonthqe
        default:
            //strikeLabel.text = "ERROR"
            useDefaultColoring = true
            strikeCell.cellType = StrikeType.defaultcell
        }
        
        
        switch modIndx {
        case 1:
            strikeLabel.text = removeAfterCharacter(Source: labelText, Character: ".", CutOffIndex: 1)
        case 5,9,13:
            strikeLabel.text = removeAfterCharacter(Source: labelText, Character: ".", CutOffIndex: 2)
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
        
        if let curMonthContainer = listing.getContainerByDate(strikeJSON["odate"].stringValue) {
            if lookupDelta != nil {
                if let curMonthEye = curMonthContainer.GetMonthByOrder(orderType) {
                    if let curDeltaRaw =  Double(strikeJSON[lookupDelta!].stringValue) {
                        
                        var curLowDelta = curMonthEye.minDelta/100
                        var curHighDelta = curMonthEye.maxDelta/100
                        var curDelta = curDeltaRaw
                        if lookupDelta!.containsString("Put") {
                            curDelta = abs(curDelta)
                            curLowDelta = abs(curLowDelta)
                            curHighDelta = abs(curHighDelta)
                        }
                        //print("curDelta: \(curDelta)  \(curLowDelta)  \(curHighDelta)")
                        if curDelta >= curLowDelta && curDelta <= curHighDelta  {
                        //print("DEBUG: Month DELEGATE:  Currently GETTING \(curMonthEye.cmdType) MQ/E  - lowdelta: \(curMonthEye.minDelta) - highdelta: \(curMonthEye.maxDelta) ")
                            success = true
                            q = "\(curMonthEye.quantity)"
                            e = "\(curMonthEye.minEdge)"
                            
                        }
                    }
                }
            } else {
                //print("trying STRIKE DELEGATE  - \(strikeJSON["strike"].stringValue)")
                if let curStrikeEyes = curMonthContainer.GetStrikesByOrder(orderType) {
                    if let curStrikeDbl = Double(strikeJSON["strike"].stringValue) {
                        for strike in curStrikeEyes {
                            if strike.strike == curStrikeDbl {
                                //print("DEBUG: STRIKE DELEGATE:  Currently GETTING \(orderType) Q/E ")
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
