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
    
    @IBAction func calcButtonPressed(sender: CalcButton) {
        
        var buttonText:String {
                if (sender.titleLabel?.text! != nil){
                    return (sender.titleLabel?.text)!
                } else {
                    return ""
                }
        }
        switch buttonText {
            case "c":
                selectedStrikeEyeParameter.placeholder = "prev: \(selectedStrikeEyeParameter.text)"
                selectedStrikeEyeParameter.text = ""
            case ".":
                if !(selectedStrikeEyeParameter.text?.characters.contains("."))! {
                    selectedStrikeEyeParameter.insertText(buttonText)
                }
            default:
                selectedStrikeEyeParameter.insertText(buttonText)
            
        }
        
    }
    
    @IBAction func shiftLeft(sender: UITextField) {
    
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
            }, completion: {
                [weak self]finished in
                print("I AM COMPLETING")
                if (self != nil) {
                    if self!.hasShifted {
                        sender.selectAll(nil)
                    } else {
                        self?.selectedStrikeEyeParameter?.unmarkText()

                    }
                }
                print("I AM COMPLETED")
            })
        
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
    
    weak var selectedStrikeEyeParameter:UITextField!
    weak var editEyeViewController:EditEyeViewController?
    
    weak var currentTextField:UITextField?
    
    var isMonthEye:Bool = false
    var isBuy:Bool = false
    
    var strikeJSON:JSON?
    
    weak var currentContainer:MonthContainer?
    weak var currentEye:Eye?
    weak var currentDate:NSDate!
    
    
    //weak var newView = ((UINib.init(nibName: "InputView", bundle: nil)).instantiateWithOwner(nil, options: nil)[0] as! UIView)
    //weak var closure:EyePopoverViewController? = (self as? EyePopoverViewController)
    
    deinit {
        //print("deinit: eyepopoverVC")
        /*
         strikeJSON = nil
         selectedStrikeEyeParameter = nil
         editEyeViewController = nil
         currentListing = nil
         currentEye = nil
         */
    }
    
    override func viewDidLoad() {
        
        if let strikeJS = strikeJSON {
            currentDate = smileDateFormat.dateFromString((strikeJS["odate"].stringValue))
            currentContainer = currentListing.getContainerByDate(currentDate)
            if currentContainer == nil {
                print("had to create Container ")
                currentListing.AddContainer(MonthContainer(listingSymbol: currentListing.listingSymbol, exp: currentDate, expString: smileDateFormat.stringFromDate(currentDate)))
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
            
            symbol.text = currentListing.listingSymbol
            maturity.text = smileDateFormat.stringFromDate(currentDate)
            if isMonthEye {
                strike.text = ""
            } else {
                strike.text = removeAfterCharacter(Source: strikeJS["strike"].stringValue, Character: ".", CutOffIndex: 1)
            }
        } else {
            
            let demoMonth =  currentListing.registeredMonthContainers[0]
            
            symbol.text = currentListing.listingSymbol
            maturity.text = smileDateFormat.stringFromDate(demoMonth.expDate)
            if isMonthEye == true {
                strike.text = ""
            } else {
                strike.text = "15.05d"
            }
            
        }
        print("currentEye: viewDidLoad:  \(currentEye)")
        
        print("DEBUG: POPOVER - VIEWDIDLOAD - EyeInfo: \(currentEye)")
        super.viewDidLoad()
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.inputView = UIView()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        
        selectedStrikeEyeParameter = textField
        
        if hasShifted == false {
            shiftLeft(textField)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        shiftLeft(textField)
        textField.resignFirstResponder()
        //textField.inputView = nil
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editeye" {
            print("segue")
            let editEye = (segue.destinationViewController as! EditEyeViewController)
            print(currentEye)
            editEye.isMonthEye = isMonthEye
            editEye.currentListing = currentListing
            editEye.strikeJSON = strikeJSON
            
            editEye.currentEye = currentEye
            
            editEye.setDelegates(self)
            editEyeViewController = editEye
        }
    }
}
