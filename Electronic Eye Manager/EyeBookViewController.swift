//
//  EyeListViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/12/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EyeBookViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate {
    enum FilterType {
        case ShowAll
        case ShowListing
    }
    
    @IBOutlet var listingCollection: StockFilterView!
    @IBOutlet var eyesTable: UITableView!
    
    
    var listingSymbols = [String]()
    var filteredSymbol:Listing = Listing()
    var currentFilter = FilterType.ShowAll
    var selectedSymbol = ""
    
    @IBAction func FilterSymbol(sender:UIButton) {
        let myListing = getListingBySymbol(eyeBook, symbol: (sender.currentTitle!))
        if (myListing.listingsymbol != selectedSymbol) {
            let oldListing:Listing = getListingBySymbol(eyeBook, symbol: selectedSymbol)
            oldListing.isSelected = false
        }
        if (myListing.isSelected) {
            currentFilter = FilterType.ShowAll
            selectedSymbol = ""
            myListing.isSelected = false
        }
        else {
            currentFilter = FilterType.ShowListing
            selectedSymbol = myListing.listingsymbol
            myListing.isSelected = true
        }
        eyesTable.reloadData()
        listingCollection.reloadData()
        
    }
    
    @IBAction func FocusBtnPressed(sender: UIButton) {
        if let senderCellContainer = sender.superview!.superview as? EyeBookTableViewCell {
            senderCellContainer.changeActiveButton(sender.tag-1, sender)
        }
    }
    
    
    @IBAction func TestLink(sender: AnyObject) {
        //performSegueWithIdentifier("MonthEye", sender: sender)
        
        var client:TCPClient = TCPClient(addr: "smilelxdt07", port: 9400)
        var (success, errmsg) = client.connect(timeout: 1)
        let sendStr:String = "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{ \"command\":\"view_table\", \"tablename\":\"Eye\"}}                                            "
        var strLength:UInt = strlen(sendStr)
        var networkLen:UInt = strLength.bigEndian
        let data:NSMutableData = NSMutableData(bytes: &networkLen, length: sizeof(Int))
        data.appendBytes(sendStr, length: Int(strLength))
        
        let finalData = NSData(data: data)
        
        if success {
            var (success1, errmsg1) = client.send(data: data)
            if success1 {
                print("I sent something (1)")
                print("strLength: " + "\(strLength)")
                print("NSDATA:")
                print(data)
                print(data.bytes)
                print(Int32(data.length))
                
            } else {
                print("failure when sending (1)")
                print(errmsg1)
                
            }
//            var (success2, errmsg2) = client.send(str: sendStr)
//            if success2 {
//               print("I sent something (2)")
//            } else {
//                print("failure when sending (2)")
//                print(errmsg2)
//            }
        }
        else {
            print("no connection")
            print(errmsg)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if listingSymbols.count == 0 {
            for i in eyeBook {
                listingSymbols.append(i.listingsymbol)
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eyeBook.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let listingAtIndexPath = eyeBook[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Listing", forIndexPath: indexPath)
        (cell.contentView.viewWithTag(1) as! UIButton).setTitle(listingAtIndexPath.listingsymbol, forState: .Normal)
        if listingAtIndexPath.isSelected {
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.blackColor().CGColor
        }
        else {
            cell.layer.borderWidth = 0.0
            cell.layer.borderColor = UIColor.clearColor().CGColor
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView)-> Int {
        if currentFilter == FilterType.ShowAll {
            return eyeBook.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if currentFilter == FilterType.ShowAll {
            return eyeBook[section].listingsymbol
        }
        return selectedSymbol
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentListing = eyeBook[section]
        return currentListing.registeredMonthEyes.count + currentListing.registeredStrikeEyes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Test", forIndexPath: indexPath)
        
        var currentListing:Listing {
            if self.selectedSymbol == "" {
                return eyeBook[indexPath.section]
            }
            else {
                return getListingBySymbol(eyeBook, symbol: self.selectedSymbol)
            }
        }
        if indexPath.row < currentListing.registeredMonthEyes.count {
            let curMonth:MonthEye = currentListing.registeredMonthEyes[indexPath.row]
            (cell as! EyeBookTableViewCell).curMonthEye = curMonth
            (cell.contentView.viewWithTag(5) as! UILabel).text = "\(curMonth.expDate)"
            
            (cell.contentView.viewWithTag(7) as! UILabel).text = "N"
            for i in 8...11 {
                (cell.contentView.viewWithTag(i) as! UILabel).text = ""
            }
        }
        else {
            let index = (indexPath.row)-(currentListing.registeredMonthEyes.count)
            let curStrike = currentListing.registeredStrikeEyes[index]
            (cell as! EyeBookTableViewCell).curStrikeEye = curStrike
            (cell.contentView.viewWithTag(5) as! UILabel).text = "\(curStrike.expDate) - \(curStrike.strikePrice)"
        
            (cell.contentView.viewWithTag(7) as! UILabel).text = ""
            (cell.contentView.viewWithTag(8) as! UILabel).text = "20"
            (cell.contentView.viewWithTag(9) as! UILabel).text = "1000"
            (cell.contentView.viewWithTag(10) as! UILabel).text = "OT"
            (cell.contentView.viewWithTag(11) as! UILabel).text = "True"
        }
        
        return cell
    }
    
}

