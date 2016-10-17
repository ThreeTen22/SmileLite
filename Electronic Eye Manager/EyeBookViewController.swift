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
    var eyeArray:Array = [AnyObject]()
    
    var focusedListing:Listing?
    var focusedMonthContainer:MonthContainer?
    
    var newRowIndex:Int = 0
    var indxToUse:Int = 0
    
    
    @IBAction func FilterSymbol(sender:UIButton) {
        if let myListing = eyeBook.getListingBySymbol((sender.currentTitle!)) {
            if (myListing.listingsymbol != selectedSymbol) {
                if let oldListing:Listing = eyeBook.getListingBySymbol(selectedSymbol) {
                    oldListing.isSelected = false
                }
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
        //
        //        //print(eyebookJSON.array![1])
        //        //Override point for customization after application launch.
        //        var client:TCPClient = TCPClient(addr: "jdempseylxdt05", port: 9400)
        //        var (success, errmsg) = client.connect(timeout: 1)
        //        let sendStr:String = "{\"id\":1,\"target\":\"eye\",\"type\":\"request\",\"clientname\":\"perl\",\"payload\":{ \"command\":\"view_table\", \"tablename\":\"Eye\"}}"
        //        var strLength:UInt = strlen(sendStr)
        //        var networkLen:UInt = strLength.bigEndian
        //        let data:NSMutableData = NSMutableData(bytes: &networkLen, length: sizeof(Int))
        //        data.appendBytes(sendStr, length: Int(strLength))
        //        var tempEyebookJSON:JSON?
        //
        //        let finalData = NSData(data: data)
        //
        //        if success {
        //            var (success1, errmsg1) = client.send(data: data)
        //            if success1 {
        //                print("I sent something (1)")
        //                print("strLength: " + "\(strLength)")
        //                print("NSDATA:")
        //
        //                var lengthSize:Int = sizeof(Int)
        //                let recData = client.read(lengthSize)
        //                var lengthDifference:Int = 0
        //                if let d = recData {
        //                    let recDataNS = NSData(bytes: d, length: lengthSize )
        //                    var lengthValue:Int = 0
        //                    recDataNS.getBytes(&lengthValue, length: lengthSize )
        //                    lengthValue = Int(bigEndian: lengthValue)
        //
        //                    print("First Read: Querying lenghtValue: \(lengthValue)")
        //                    lengthDifference = lengthValue
        //
        //                    //let recData2 = client.read(lengthValue)
        //                    //print("First Read: Getting RecData2 count: \(recData2!.count)")
        //
        //                    let finalData:[UInt8] = readMoreData(client, readData: client.read(lengthValue), lengthValue: lengthValue, totalData: [UInt8](), isFirst: true)
        //                    if let str = String(bytes: finalData, encoding: NSUTF8StringEncoding) {
        //                        //print(str)
        //                        tempEyebookJSON = JSON.parse(str)
        //                    }
        //
        //                }
        //            } else {
        //
        //                print("failure when sending (1)")
        //                print(errmsg1)
        //            }
        //        }
        //        else {
        //            print("no connection")
        //            print(errmsg)
        //            print("Using demo data")
        //            tempEyebookJSON = JSON.parse(eyebookRaw)
        //        }
        //        //print(eyebookRaw)
        //
        //        print((tempEyebookJSON!["payload"]["rows"].array)![1])
    }
    
    func returnArrayString(keyword:String, source:String) -> [String] {
        return [String]()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if listingSymbols.count == 0 {
            for i in eyeBook.listings {
                listingSymbols.append(i.listingsymbol)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //TEMP MAKING LISTING SELECTABLE HERE FOR TESTING
        
        let eyeContainer = sender as! EyeBookTableViewCell
        focusedMonthContainer = eyeContainer.curMonthContainer
        focusedListing = eyeBook.getListingBySymbol(focusedMonthContainer!.listingSymbol)
        
        if let monthEyeView = (segue.destinationViewController as? MonthEyeMainViewController) {
            monthEyeView.currentListing = focusedListing
            monthEyeView.currentMonthContainer = focusedMonthContainer
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eyeBook.listings.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let listingAtIndexPath = eyeBook.listings[indexPath.row]
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
        newRowIndex = 0
        indxToUse = 0
        if eyeArray.count != 0 {
            eyeArray.removeAll(keepCapacity: true)
        }
        if currentFilter == FilterType.ShowAll {
            return eyeBook.listings.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if currentFilter == FilterType.ShowAll {
            return eyeBook.listings[section].listingsymbol
        }
        return selectedSymbol
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var emptyEyes = true
        var currentListing:Listing {
            if currentFilter == .ShowAll {
                return eyeBook.listings[section]
            } else {
                return eyeBook.getListingBySymbol(selectedSymbol)!
            }
        }
        print("listing: \(currentListing.listingsymbol)")
        for container in currentListing.registeredMonthContainers {
            emptyEyes = true
            eyeArray.append(container)
            for eye in container.monthEyes {
                if eye != nil {
                    emptyEyes = false
                    eyeArray.append(eye!)
                }
            }
            if emptyEyes {
                eyeArray.removeLast()
            }
        }
        print("number of rows in section has returned")
        print(eyeArray)
        return eyeArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell     {
        var cell:UITableViewCell?
        if let curEye = (eyeArray[indexPath.row] as? MonthEye) {
            cell = tableView.dequeueReusableCellWithIdentifier("MonthDetail", forIndexPath: indexPath)
            (cell as! EyeBookTableViewCell).curMonthContainer = eyeBook.getListingBySymbol(curEye.symbol)!.getContainerByDate(curEye.expDateString)!
            
            switch curEye.order {
            case .buyCall:
                ((cell?.contentView.viewWithTag(1)) as! UIButton).setTitle("Buy Call", forState: .Normal)
            case .sellPut:
                ((cell?.contentView.viewWithTag(1)) as! UIButton).setTitle("Sell Put", forState: .Normal)
            case .buyPut:
                ((cell?.contentView.viewWithTag(1)) as! UIButton).setTitle("Buy Put", forState: .Normal)
            case .sellCall:
                ((cell?.contentView.viewWithTag(1)) as! UIButton).setTitle("Sell Call", forState: .Normal)
            default:
                print("We Got a Problem")
            }
            
            ((cell?.contentView.viewWithTag(2)) as! UILabel).text = "\(curEye.currentDelta)"
            ((cell?.contentView.viewWithTag(3)) as! UILabel).text = "\(curEye.maxDelta)"
            ((cell?.contentView.viewWithTag(4)) as! UILabel).text = "\(curEye.minEdge)"
            ((cell?.contentView.viewWithTag(5)) as! UILabel).text = "\(curEye.quantity)"
            ((cell?.contentView.viewWithTag(6)) as! UILabel).text = "\(curEye.id)"
            //FILL OUT curCONTAINER INFO
        } else if let curContainer = (eyeArray[indexPath.row] as? MonthContainer ) {
            
            cell = tableView.dequeueReusableCellWithIdentifier("Test", forIndexPath: indexPath)
            ((cell?.contentView.viewWithTag(5)) as! UILabel).text = curContainer.expDateString
            (cell as! EyeBookTableViewCell).curMonthContainer = curContainer
            //FILL OUTcurEYE WITH INFO
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("MonthEye", sender: (tableView.cellForRowAtIndexPath(indexPath)))
    }
    
    
    
}

