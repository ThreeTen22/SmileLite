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
    
    @IBOutlet weak var maxQuantity: UITextField!
    @IBOutlet weak var maxDelta: UITextField!
    @IBOutlet weak var minEdge: UITextField!
    @IBOutlet weak var lowDelta: UITextField!
    @IBOutlet weak var highDelta: UITextField!
    @IBOutlet weak var totalDelta: UITextField!
    
    
    
    weak var delegateController:UITextFieldDelegate?
    weak var currentListing:Listing?
    var currentEye:Eye?
    var strikeJSON:JSON?
    
    @IBOutlet var lowDeltaCollection: [UIView]!
    @IBOutlet var highDeltaCollection: [UIView]!
    @IBOutlet var totalDeltaCollection: [UIView]!
    
    var isMonthEye = true
    
    override func viewDidLoad() {
        
        if currentEye == nil {
            if let strikeJS = strikeJSON {
                print("strikeJS did enter")
                if isMonthEye {
                    print("isMonthEye")
                    let newMonthListing:MonthEye = MonthEye(strikeJSON: strikeJS, Symbol: currentListing!.listingSymbol, SecurityId: currentListing!.listingId)
                    currentEye = newMonthListing
                    print(newMonthListing)
                } else {
                     print("isStrikeEye")
                    let newStrikeListing:StrikeEye = StrikeEye(strikeJSON: strikeJS, Symbol: currentListing!.listingSymbol, SecurityId: currentListing!.listingId)
                    currentEye = newStrikeListing
                    print(newStrikeListing)
                }
            }
        }
        print("quantityViewDidLoad: \(currentEye)")
        
        if let curEye = currentEye {
            maxQuantity.text = "\(curEye.quantity)"
            maxDelta.text = "\(curEye.delta)"
            minEdge.text = "\(curEye.minEdge)"
            if isMonthEye {
                weak var me:MonthEye! = (curEye as? MonthEye)
                lowDelta.text = "\(me.minDelta)"
                highDelta.text = "\(me.maxDelta)"
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
        currentEye = nil
        //maxQuantity.delegate = nil
        //maxDelta.delegate = nil
        //minEdge.delegate = nil
        //delegateController = nil
        //lowDelta.delegate = nil
        //highDelta.delegate = nil
        //totalDelta.delegate = nil
    }
    
    
    func setDelegates(deleController:UITextFieldDelegate) {
        delegateController = deleController
    }

}
