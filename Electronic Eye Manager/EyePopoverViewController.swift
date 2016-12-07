//
//  ModifyEyePopoverViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/28/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EyePopoverViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func BackNavigation(sender: AnyObject) {
        
    }
    @IBAction func testChangeValue(sender: AnyObject) {
        //print("I am inside bro")
        
    }
    
    
    @IBAction func shiftLeft(sender: AnyObject) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {[unowned self] in
                var newFrame = self.view.frame
                if self.hasShifted {
                    newFrame = CGRect(x: newFrame.minX, y: newFrame.minY, width: newFrame.width-(self.calcView.frame.width), height: newFrame.height)
                } else {
                    newFrame = CGRect(x: newFrame.minX, y: newFrame.minY, width: newFrame.width+(self.calcView.frame.width), height: newFrame.height)
                }
            
                var contFrame = self.containerView.frame
            if self.hasShifted {
                contFrame.origin.x -= self.calcView.frame.width
            } else {
                contFrame.origin.x += self.calcView.frame.width
            }
                self.view.frame = newFrame
                self.preferredContentSize = newFrame.size
                self.containerView.frame = contFrame
                }, completion: {finished in print("CompletedAnimation")})
        hasShifted = !hasShifted
    }
    
    @IBOutlet weak var buySellLabel: UILabel!
    
    @IBOutlet weak var govAccumulatedDelta: UITextField!
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var maturity: UILabel!
    @IBOutlet weak var strike: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var calcView: UIView!
    
    
    var orderType:Order = Order.NA
    
    var hasShifted = false
    
    weak var currentListing:Listing!
    
    var currentStrikePrice:Double?
    
    weak var strikeTextField:UITextField!
    weak var editEyeViewController:UIViewController?
    
    weak var currentTextField:UITextField?
    
    var isMonthEye:Bool = false
    var isBuy:Bool = false
    
    var strikeJSON:JSON?
    
    var currentContainer:MonthContainer?
    var currentEye:Eye?
    var currentDate:NSDate!
    
    //weak var newView = ((UINib.init(nibName: "InputView", bundle: nil)).instantiateWithOwner(nil, options: nil)[0] as! UIView)
    //weak var closure:EyePopoverViewController? = (self as? EyePopoverViewController)
    
    
    override func viewDidLoad() {
        
        if let strikeJS = strikeJSON {
            
            currentDate = smileDateFormat.dateFromString((strikeJS["odate"].stringValue))
            currentContainer = currentListing.getContainerByDate(currentDate)
            if currentContainer == nil {
                print("had to create Container ")
                currentListing.AddContainer(MonthContainer(listingSymbol: currentListing.listingsymbol, exp: currentDate, expString: smileDateFormat.stringFromDate(currentDate)))
                currentContainer = currentListing.getContainerByDate(currentDate)
            }
            
            if isMonthEye {
                currentEye = currentContainer?.GetMonthByOrder(orderType)
                //currentContainer.GetMonthByOrder()
            } else {
                if let currentEyes:[StrikeEye] = currentContainer?.GetStrikesByOrder(orderType) {
                    for eye in currentEyes {
                        print("Debug: popover:viewdidLoad: strikeEyeArrayCheck: eye - \(eye)")
                        if eye.strike == Double(strikeJS["strike"].stringValue)! {
                            currentEye = eye
                            break
                        }
                    }
                }
            }
            
            if isBuy == false {
             buySellLabel.text = "Sell"
             buySellLabel.backgroundColor = UIColor.redColor()
            }
            
            symbol.text = currentListing.listingsymbol
            maturity.text = smileDateFormat.stringFromDate(currentDate)
            if isMonthEye {
                strike.text = ""
            } else {
                strike.text = strikeJS["strike"].stringValue
            }
        } else {
           let demoMonth =  currentListing.registeredMonthContainers[0]
            symbol.text = currentListing.listingsymbol
            maturity.text = smileDateFormat.stringFromDate(demoMonth.expDate)
            if isMonthEye == true {
                strike.text = ""
            } else {
                strike.text = "15.05d"
            }
            
        }
        
        
        print("DEBUG: POPOVER - VIEWDIDLOAD - EyeInfo: \(currentEye)")
        let view = self.view
        view.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: 600.0, height: 300.0)
        super.viewDidLoad()
        
    }
    
    deinit {
        //print("I am being unloaded")
        strikeJSON = nil
        strikeTextField = nil
        editEyeViewController = nil
        currentListing = nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //print("Test my Way out")
        //let calcView = storyboard?.instantiateViewControllerWithIdentifier("CalculatorInputViewController")
        //textField.inputView = calcView?.view
        textField.inputView = UIView()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if hasShifted == false {
            shiftLeft(textField)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        shiftLeft(textField)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editeye" {
            let editEye = (segue.destinationViewController as! EditEyeViewController)
            editEye.isMonthEye = isMonthEye
            editEye.currentEye = currentEye
            editEye.setDelegates(self)
        }
    }
    
    
}
