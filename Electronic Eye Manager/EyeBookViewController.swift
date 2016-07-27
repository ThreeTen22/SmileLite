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
    
    var listingSymbols = [String]()
    var filteredSymbol:Listing = Listing()
    var currentFilter = FilterType.ShowAll
    var selectedSymbol = ""
    
    
    
    @IBAction func FocusBtnPressed(sender: UIButton) {
        if let senderCellContainer = sender.superview!.superview as? EyeBookTableViewCell {
            senderCellContainer.changeActiveButton(sender.tag-1, sender)
        }
    }
    
    
    @IBAction func TestLink(sender: AnyObject) {
        //performSegueWithIdentifier("MonthEye", sender: sender)
        
        var client:TCPClient = TCPClient(addr: "jdempseylxdt05", port: 9400)
        var (success, errmsg) = client.connect(timeout: 1)
        if success {
            var (success, errmsg) = client.send(str: "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{ \"command\":\"view_table\", \"tablename\":\"Eye\"}}")
            if success {
                let data = client.read(1024*10)
                if let d=data {
                    if let str=String(bytes: d, encoding:  NSUTF8StringEncoding) {
                        print(str)
                    }
                }
            } else {
                print("no query")
                print(errmsg)
            }
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
            print(currentListing.registeredStrikeEyes.count)
            print(index)
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

