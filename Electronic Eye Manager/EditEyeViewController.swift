//
//  CalculatorInputView.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/2/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EditEyeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBOutlet weak var maxQuantity: EditEyeParameter!
    @IBOutlet weak var maxDelta: EditEyeParameter!
    @IBOutlet weak var minEdge: EditEyeParameter!
    @IBOutlet weak var lowDelta: EditEyeParameter!
    @IBOutlet weak var highDelta: EditEyeParameter!
    @IBOutlet weak var totalDelta: EditEyeParameter!
    
    weak var delegateController:UITextFieldDelegate?
    weak var currentListing:Listing?
    weak var currentEye:Eye?
    var strikeJSON:JSON?
    
    @IBOutlet var lowDeltaCollection: [UIView]!
    @IBOutlet var highDeltaCollection: [UIView]!
    @IBOutlet var totalDeltaCollection: [UIView]!
    
    @IBOutlet weak var exchangeTable:ExchangeTableView!
    
    var isMonthEye = true
    
    var exchanges:Exchanges!
    
    func testChangeValue(sender: AnyObject) {
        let senderBtn:QuickChangeButton = (sender as! QuickChangeButton)
        let amount = senderBtn.changeAmount
        //print(senderBtn.labelToChange)
        
        switch senderBtn.labelToChange {
            case "maxQuantity":
                modifyTextField(maxQuantity, amount: amount)
            case "maxDelta":
                modifyTextField(maxDelta, amount: amount)
            case "minEdge":
                modifyTextField(minEdge, amount: amount)
            case "lowDelta":
                modifyTextField(lowDelta, amount: amount)
            case "highDelta":
                modifyTextField(highDelta, amount: amount)
            case "totalDelta":
                modifyTextField(totalDelta, amount: amount)
        default: break
            
        }
    }
    
    func printChar(chars: String.CharacterView) {
        var newString:String = ""
        for char in chars {
            newString += " \(char)"
        }
        //print(newString)
    }
    
    
    override func viewWillAppear(animated:Bool) {
        
        if currentEye == nil {
            createDemoEye()
            exchanges = Exchanges()
        } else {
            exchanges = Exchanges(fromEyeJson: currentEye!.eyeJson)
        }
        //print("quantityViewDidLoad: \(currentEye)")
        
        if let curEye = currentEye {
            setupTextFields(curEye)
        }
        // maxQuantity.note
        
        linkDelegates()
        if !isMonthEye {
            for view in lowDeltaCollection {
                view.hidden = true
            }
            for view in highDeltaCollection {
                view.hidden = true
            }
            for view in totalDeltaCollection {
                view.hidden = true
            }
        }
        self.view!.backgroundColor = Layout.monthEyeBGColor
        self.view!.viewWithTag(1337)?.backgroundColor = Layout.monthEyeBGColor
        
        exchangeTable.dataSource = self
        exchangeTable.delegate = self
        exchangeTable.exchanges = currentEye?.exchangeData ?? Exchanges()
        
        delegateController = nil
        super.viewWillAppear(animated)
    }
    
    deinit {
        
        //print("deinit: editEyepopoverVC")
        
        //lowDeltaCollection.removeAll()
        //highDeltaCollection.removeAll()
        //totalDeltaCollection.removeAll()
        currentListing = nil
        delegateController = nil
        //exchangeTable.dataSource = nil
        //exchangeTable.delegate = nil

    }
    
    func createDemoEye() {
        if let strikeJS = strikeJSON {
            //print("strikeJS did enter")
            if isMonthEye {
                //print("isMonthEye")
                let newMonthListing:MonthEye = MonthEye(strikeJSON: strikeJS, Symbol: currentListing!.listingSymbol, SecurityId: currentListing!.listingId)
                currentEye = newMonthListing as Eye
                //print(currentEye)
            } else {
                //print("isStrikeEye")
                let newStrikeListing:StrikeEye = StrikeEye(strikeJSON: strikeJS, Symbol: currentListing!.listingSymbol, SecurityId: currentListing!.listingId)
                currentEye = newStrikeListing as Eye
                //print(newStrikeListing)
                //print(currentEye)
            }
        }
    }
    
    func setupTextFields(curEye:Eye) {
        maxQuantity.setupText("\(curEye.quantity)")
        maxDelta.setupText("\(curEye.delta)")
        minEdge.setupText("\(curEye.minEdge)")
        if isMonthEye {
            if let me = (curEye as? MonthEye) {
                lowDelta.setupText("\(me.minDelta)")
                highDelta.setupText("\(me.maxDelta)")
                totalDelta.setupText("\(me.totalDelta)")
            }
        }
    }
    
    func linkDelegates() {
        maxQuantity.delegate = delegateController
        maxDelta.delegate = delegateController
        minEdge.delegate = delegateController
        if isMonthEye {
            lowDelta.delegate = delegateController
            highDelta.delegate = delegateController
            totalDelta.delegate = delegateController
        }
    }
    
    func setDelegates(deleController:UITextFieldDelegate) {
        delegateController = deleController
    }
    
    func modifyTextField(textField:EditEyeParameter, amount:Double) {
        if let textAmount:Double = Double(textField.text!) {
            textField.text = String(textAmount + amount)
        } else {
            textField.text = String(amount)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView as! ExchangeTableView).exchanges.visibleExchangeCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Market", forIndexPath: indexPath) as! ExchangesTableCell
        let exchangeTable = (tableView as! ExchangeTableView)
        (cell.viewWithTag(1) as! UILabel).text = Exchanges.exchangeNames(exchangeTable.exchanges[namedIndx: indexPath.row+1])
        cell.exchange = exchangeTable.exchanges[indexPath.row+1]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let exchangeCell = cell as! ExchangesTableCell
        let exchangeTable = (tableView as! ExchangeTableView)
        print("willDisplay")
        exchangeCell.exchange = exchangeTable.exchanges[indexPath.row+1]
        exchangeCell.setRadioState(exchangeCell.radioButton)
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let exchangeCell = cell as! ExchangesTableCell
        let exchangeTable = tableView as! ExchangeTableView
        print("didEndDisplay")
        //if exchangeTable.exchanges[indexPath.row+1] != exchangeCell.exchange {
            exchangeTable.exchanges[indexPath.row+1] = exchangeCell.exchange
        //}
        
    }
}
