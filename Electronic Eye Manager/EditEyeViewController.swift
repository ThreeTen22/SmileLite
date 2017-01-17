//
//  CalculatorInputView.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/2/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EditEyeViewController: UIViewController {
    
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
    
    @IBOutlet weak var autoHedge: RadioButton!
    
    weak var delegateController:EyePopoverViewController?
    weak var currentListing:Listing?
    weak var currentEye:Eye?
    var eyeJSON:JSON?
    
    
    @IBOutlet var monthParameters:UIStackView!
    
    @IBOutlet weak var exchangeTable:ExchangeTableView!
    
    var isMonthEye = true
    
    @IBOutlet var orderTypeControl: UISegmentedControl!
    @IBOutlet var eyeTypeControl: UISegmentedControl!
    
    @IBOutlet var priceParamCollection: [UIView]!
    
    
    

    
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
        

        
        // exchangeTable.eyeExchanges = currentEye?.exchangeData ?? Exchanges()
        
        exchangeTable.reloadData()
        Layout.setRadioButtonLayout(autoHedge, isOn: delegateController!.eyeParams.autoHedge.asBool()!)
        super.viewWillAppear(animated)
    }
    
    deinit {
        print("editEyeVC deinit")
        currentListing = nil
        delegateController = nil
        
    }
    
    func createDemoEye() {
        if let eyeJS = eyeJSON {
            //print("strikeJS did enter")
            if isMonthEye {
                //print("isMonthEye")
                let newMonthListing:MonthEye = MonthEye(monthJSON: eyeJS, Symbol: currentListing!.listingSymbol, SecurityId: currentListing!.listingId)
                currentEye = newMonthListing as Eye
                //print(currentEye)
            } else {
                //print("isStrikeEye")
                let newStrikeListing:StrikeEye = StrikeEye(strikeJSON: eyeJS, Symbol: currentListing!.listingSymbol, SecurityId: currentListing!.listingId)
                currentEye = newStrikeListing as Eye
                //print(newStrikeListing)
                //print(currentEye)
            }
        }
    }
    
    func setupParams(eyeParams:EyeParams) {
        
        maxQuantity.setupText(eyeParams.quantity)
        maxDelta.setupText(eyeParams.delta.removeZeros())
        minEdge.setupText(eyeParams.minEdge.removeZeros(true))
        price.setupText(eyeParams.price)
        
        if eyeParams.useMonthParams {
            lowDelta.setupText(eyeParams.minDelta.removeZeros())
            highDelta.setupText(eyeParams.maxDelta.removeZeros())
            totalDelta.setupText(eyeParams.totalDelta.removeZeros())
        }
        for indx in 0..<orderTypeControl.numberOfSegments {
            if orderTypeControl.titleForSegmentAtIndex(indx) == eyeParams.orderType {
                orderTypeControl.selectedSegmentIndex = indx
            }
        }
        
        for indx in 0..<eyeTypeControl.numberOfSegments {
            if eyeTypeControl.titleForSegmentAtIndex(indx) == eyeParams.eyeType {
                eyeTypeControl.selectedSegmentIndex = indx
            }
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
        exchangeTable.dataSource = delegateController
        exchangeTable.delegate = delegateController
    }
    
    func anyParamsChanged() -> Bool {
    if  maxQuantity.valueChanged ||
        maxDelta.valueChanged ||
        minEdge.valueChanged ||
        lowDelta.valueChanged ||
        highDelta.valueChanged ||
        totalDelta.valueChanged ||
        price.valueChanged {
            return true
        }
        return false
    }




    
}


/*
 func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 
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
 */
