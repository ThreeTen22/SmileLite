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
    @IBOutlet weak var price: EditEyeParameter!
    
    weak var delegateController:UITextFieldDelegate?
    weak var currentListing:Listing?
    weak var currentEye:Eye?
    var strikeJSON:JSON?
    
    @IBOutlet var monthParameters:UIStackView!
    
    @IBOutlet weak var exchangeTable:ExchangeTableView!
    
    var isMonthEye = true
    
    @IBOutlet var orderTypeControl: UISegmentedControl!
    @IBOutlet var eyeTypeControl: UISegmentedControl!
    
    
    
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
        
        linkDelegates()
        if !isMonthEye {
            monthParameters.hidden = true
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
        print("editEyeVC deinit")
        currentListing = nil
        delegateController = nil
        
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
    
    func setupTextFields(eyeParams:EyeParams) {
        maxQuantity.setupText(eyeParams.quantity)
        maxDelta.setupText(eyeParams.delta)
        minEdge.setupText(eyeParams.minEdge)
        if eyeParams.useMonthParams {
            lowDelta.setupText(eyeParams.minDelta)
            highDelta.setupText(eyeParams.maxDelta)
            totalDelta.setupText(eyeParams.totalDelta)
        }
    }
    
    func linkDelegates() {
        maxQuantity.delegate = delegateController
        maxDelta.delegate = delegateController
        minEdge.delegate = delegateController
        price.delegate = delegateController
        if isMonthEye {
            lowDelta.delegate = delegateController
            highDelta.delegate = delegateController
            totalDelta.delegate = delegateController
        }
    }
    
    func setDelegates(deleController:UITextFieldDelegate) {
        delegateController = deleController
    }
    
    func modifyTextField(textField:EditEyeParameter, amount:Float) {
        if let textAmount:Float = Float(textField.text!) {
            textField.text = String(textAmount + amount)
        } else {
            textField.text = String(amount)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView as! ExchangeTableView).exchanges.visibleExchangeCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Market") as! ExchangesTableCell
        let exchangeTable = (tableView as! ExchangeTableView)
        cell.exchangeName.text = Exchanges.exchangeNames(exchangeTable.exchanges[namedIndx: indexPath.row+1])
        cell.radioButton.tag = (indexPath.row+1)
        //Layout.setRadioButtonLayout(cell.radioButton, isOn: exchangeTable.exchanges[isActiveExchange: cell.radioButton.tag])
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let exchangeCell = cell as! ExchangesTableCell
        let exchangeTable = (tableView as! ExchangeTableView)
        Layout.setRadioButtonLayout(exchangeCell.radioButton, isOn: exchangeTable.exchanges[isActiveExchange: exchangeCell.radioButton.tag])
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    */
}
