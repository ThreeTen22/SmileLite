//
//  CalculatorInputView.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/2/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EditEyeViewController: UIViewController, UITableViewDelegate {
    
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
    
    @IBOutlet weak var MarketTable: UITableView!
    @IBOutlet var lowDeltaCollection: [UIView]!
    @IBOutlet var highDeltaCollection: [UIView]!
    @IBOutlet var totalDeltaCollection: [UIView]!
    
    var isMonthEye = true
    
    func testChangeValue(sender: AnyObject) {
        let senderBtn:QuickChangeButton = (sender as! QuickChangeButton)
        let amount = senderBtn.changeAmount
        print(senderBtn.labelToChange)
        
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
    
    func setupValues() {
        
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        if currentEye == nil {
            if let strikeJS = strikeJSON {
                print("strikeJS did enter")
                if isMonthEye {
                    print("isMonthEye")
                    let newMonthListing:MonthEye = MonthEye(strikeJSON: strikeJS, Symbol: currentListing!.listingSymbol, SecurityId: currentListing!.listingId)
                    currentEye = newMonthListing as Eye
                    print(currentEye)
                } else {
                    print("isStrikeEye")
                    let newStrikeListing:StrikeEye = StrikeEye(strikeJSON: strikeJS, Symbol: currentListing!.listingSymbol, SecurityId: currentListing!.listingId)
                    currentEye = newStrikeListing as Eye
                    print(newStrikeListing)
                    print(currentEye)
                }
            }
        }
        print("quantityViewDidLoad: \(currentEye)")
        
        if let curEye = currentEye {
            
            maxQuantity.setupText("\(curEye.quantity)")
            maxDelta.setupText("\(curEye.delta)")
            minEdge.setupText("\(curEye.minEdge)")
            if isMonthEye {
                weak var me:MonthEye! = (curEye as? MonthEye)
                lowDelta.setupText("\(me.minDelta)")
                highDelta.setupText("\(me.maxDelta)")
                totalDelta.setupText("\(me.totalDelta)")
                me = nil
            }
        }
        // maxQuantity.note
        maxQuantity.delegate = delegateController
        maxDelta.delegate = delegateController
        minEdge.delegate = delegateController
        
        if isMonthEye {
            lowDelta.delegate = delegateController
            highDelta.delegate = delegateController
            totalDelta.delegate = delegateController
        } else {
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
        //self.view.insertSubview(newView as! UIView, atIndex: 0)
        //self.view.insertSubview(testView, atIndex: 0)
        
    }
    
    deinit {
        
        //print("deinit: editEyepopoverVC")
        
        //lowDeltaCollection.removeAll()
        //highDeltaCollection.removeAll()
        //totalDeltaCollection.removeAll()
        currentListing = nil
        delegateController = nil

    }
    
    
    func setDelegates(deleController:UITextFieldDelegate) {
        delegateController = deleController
    }
    
    func modifyTextField(textField:EditEyeParameter, amount:Double) {
        //if textField.textRangeFromPosition(, toPosition: <#T##UITextPosition#>)
        if let textAmount:Double = Double(textField.text!) {
            textField.text = String(textAmount + amount)
            //textField.replaceRange(textField., withText: <#T##String#>)
        } else {
            textField.text = String(amount)
        }
        
    }
    
    
    
}
