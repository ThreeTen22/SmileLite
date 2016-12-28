//
//  ModifyEyePopoverViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/28/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit


class EyePopoverViewController: UIViewController, UITextFieldDelegate  {
    
    private enum ShiftState {
        case notshifted
        case shiftingleft
        case hasshifted
        case shiftingright
        case forceshiftingright
    }
    private var curShiftState:ShiftState = .notshifted
    
    
    
    //IBAction
    func calcButtonPressed(sender: CalcButton) {
        
        let buttonText:String = (sender.titleLabel?.text)! ?? ""
        
        switch buttonText {
        case "c":
            selectedStrikeEyeParameter.text = ""
        case ".":
            
            if selectedStrikeEyeParameter.text! == "" {
                selectedStrikeEyeParameter.insertText("0"+buttonText)
                break
            }
            
            if (selectedStrikeEyeParameter.text?.characters.contains(Character(buttonText)))! {
                if let textRange = selectedStrikeEyeParameter.selectedTextRange {
                    if let selectedText = selectedStrikeEyeParameter.textInRange(textRange) {
                        if selectedText.containsString(buttonText) {
                            selectedStrikeEyeParameter.insertText(buttonText)
                        }
                        break
                    }
                }
            }
            selectedStrikeEyeParameter.insertText(buttonText)
            
        default:
            selectedStrikeEyeParameter.insertText(buttonText)
            
        }
        
    }
    
    //IBAction
    func orderTypeSelected(sender:UISegmentedControl) {
        
        let sindx = sender.selectedSegmentIndex
        let indxTitle = sender.titleForSegmentAtIndex(sindx)
        
        eyeParams.orderType = indxTitle ?? ""
        activateSaveIfNecessary()
    }
    
    //IBAction
    func eyeTypeSelected(sender:UISegmentedControl) {
        
        let sindx = sender.selectedSegmentIndex
        let indxTitle = sender.titleForSegmentAtIndex(sindx)!
        
        eyeParams.eyeType = indxTitle ?? ""
        
        if indxTitle.containsString("Mkt") {
            togglePriceParam(true)
        } else {
            eyeParams.price = ""
            print("Im disabled")
            togglePriceParam(false)
        }
        
        
        activateSaveIfNecessary()
    }
    
    //IBAction
    func shift(sender: UITextField) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {[unowned self] in
            //var newFrame = self.view.frame
            var contFrame = self.containerView.frame
            
            switch self.curShiftState {
            case .shiftingright, .forceshiftingright:
                contFrame.origin.x += self.calcView.bounds.width
            case .shiftingleft:
                contFrame.origin.x -= self.calcView.bounds.width
            default: break
            }
            //self.view.frame = newFrame
            //self.preferredContentSize = newFrame.size
            self.containerView.frame = contFrame
            }, completion: {
                [weak self, weak sender]finished in
                //print("I AM COMPLETING")
                if (self != nil) {
                    switch self?.curShiftState {
                    case .shiftingleft?:
                        self?.curShiftState = .hasshifted
                        sender?.becomeFirstResponder()
                    //sender?.selectAll(nil)
                    case .shiftingright?:
                        self?.curShiftState = .notshifted
                    case .forceshiftingright?:
                        self?.curShiftState = .notshifted
                    default: break
                    }
                    //print("I AM COMPLETED")
                }
            })
    }
    
    
    //IBAction
    func saveCancelButtonPressed(sender:SaveCancelButton) {
        if sender.isSaveButton {
            print("Saved")
        } else {
            print("Cancelled")
        }
    }
    
    @IBOutlet weak var buySellLabel: UILabel!
    
    @IBOutlet weak var govAccumulatedDelta: UITextField!
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var maturity: UILabel!
    @IBOutlet weak var strike: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var calcView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton:UIButton!
    
    weak var currentListing:Listing!
    
    var currentStrikePrice:Double?
    
    weak var selectedStrikeEyeParameter:EditEyeParameter!
    var editEyeViewController:EditEyeViewController?
    
    var orderType:Order = Order.NA
    var isMonthEye:Bool = false
    var isBuy:Bool = false
    var strikeJSON:JSON?
    
    var eyeParams:EyeParams = EyeParams()
    var tempEye:StrikeEye?
    
    weak var currentContainer:MonthContainer?
    weak var currentEye:Eye?
    weak var currentDate:NSDate!
    
    var exchangeInfo:Exchanges {
        return (self.editEyeViewController?.exchangeTable.exchanges)!
    }
    
    var sourceEyeParams:EyeParams {
        return currentEye!.eyeParams
    }
    
    
    
    deinit {
        print("deinit: eyepopoverVC")
        currentDate = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setFAIcon(FAType.FAClose, iconSize: 30.0, forState: .Normal)
        closeButton.setFATitleColor(Layout.eyeCancelTextColor)
        
        saveButton.setFAIcon(FAType.FACheck, iconSize: 30.0, forState: .Normal)
        saveButton.setFATitleColor(Layout.eyeInstallTextColor)
        
        if let strikeJS = strikeJSON {
            currentDate = smileDateFormat.dateFromString((strikeJS["odate"].stringValue))
            currentContainer = currentListing.getContainerByDate(currentDate)
            if currentContainer == nil {
                //print("had to create Container ")
                currentListing.AddContainer(MonthContainer(listingSymbol: currentListing.listingSymbol, exp: currentDate, expString: smileDateFormat.stringFromDate(currentDate)))
                currentContainer = currentListing.getContainerByDate(currentDate)
            }
            
            
            if isMonthEye {
                currentEye = currentContainer?.GetMonthByOrder(orderType)
                //print("current EYE  \(currentEye)")
                //currentContainer.GetMonthByOrder()
            } else {
                if let currentEyes:[StrikeEye] = currentContainer?.GetStrikesByOrder(orderType) {
                    for eye in currentEyes {
                        //print("Debug: popover:viewdidLoad: strikeEyeArrayCheck: eye - \(eye)")
                        if eye.strike == Double(strikeJS["strike"].stringValue)! {
                            currentEye = eye
                            break
                        }
                    }
                    if currentEye == nil {
                        tempEye = StrikeEye(strikeJSON: strikeJS, Symbol: currentListing.listingSymbol, SecurityId: currentListing.listingId)
                        tempEye?.order = orderType
                        tempEye?.isTempEye = true
                        currentEye = tempEye
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
            
            //print(currentEye)
            editEyeViewController!.isMonthEye = isMonthEye
            editEyeViewController!.currentListing = currentListing
            editEyeViewController!.strikeJSON = strikeJSON
            
            editEyeViewController!.currentEye = currentEye
            if currentEye != nil {
                eyeParams = currentEye!.eyeParams
            } else {
                eyeParams = EyeParams(isMonthEye)
            }
            editEyeViewController!.delegateController = self
            
            editEyeViewController!.setupParams(eyeParams)
            
            eyeTypeSelected(editEyeViewController!.eyeTypeControl)
            
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
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch curShiftState {
        case .hasshifted, .shiftingright:
            curShiftState = .forceshiftingright
            view.endEditing(true)
        default:
            break
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.inputView = UIView()
        switch curShiftState {
        case .notshifted:
            curShiftState = .shiftingleft
            shift(textField)
            return false
        case .hasshifted:
            return true
        default:
            return false
        }
        
    }
    
    func toggleSaveButton(isEnabled:Bool) {
        saveButton.enabled = isEnabled
        if isEnabled {
            saveButton.setFATitleColor(Layout.eyeInstallTextColor)
            return
        }
        saveButton.setFATitleColor(Layout.eyeInstallTextColorDisabled)
    }
    
    func togglePriceParam(isEnabled:Bool) {
        var alpha:CGFloat = 0.5
        if isEnabled {
            alpha = 1.0
        }
        for element in (editEyeViewController?.priceParamCollection)! {
            if let lbl = element as? UILabel {
                lbl.enabled = isEnabled
                lbl.alpha = alpha
                continue
            }
            if let btn = element as? UIButton {
                btn.enabled = isEnabled
                btn.alpha = alpha
                //print("btn enabled \(btn.enabled)")
                continue
            }
            
            if let tf = element as? UITextField {
                tf.enabled = isEnabled
                tf.alpha = alpha
                //print("tf enabled \(tf.enabled)")
                continue
            }
        }
    }
    
    func activateSaveIfNecessary() {
        
       toggleSaveButton( (sourceEyeParams != eyeParams) || (currentEye!.exchangeData != exchangeInfo) )
        
        /*
        if editEyeViewController!.anyParamsChanged() || editEyeViewController!.exchangeTable.valueChanged {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
         */
        
    }
    
    func calcValueChanged(sender:UIButton) {
        //unowned let tf = (selectedStrikeEyeParameter as! EditEyeParameter)
        //updateForChanges(selectedStrikeEyeParameter)
        activateSaveIfNecessary()
    }
    
    func updateForChanges(tf:EditEyeParameter) {
        
        if labelTextsMatch(tf.text, tf.placeholder) {
            tf.valueChanged = false
        } else {
            tf.valueChanged = true
        }
        
        
        
    }
    
    func labelTextsMatch(rlbl:String?,_ llbl:String?) -> Bool {
        //let rl = rlbl ?? ""
        //let ll = llbl ?? ""
        if rlbl == llbl {
            return true
        } else {
            return false
        }
    }
    
    
    func testChangeValue(sender: QuickChangeButton) {
        //let senderBtn:QuickChangeButton = (sender as! QuickChangeButton)
        let amount = sender.changeAmount
        //print(senderBtn.labelToChange)
        
        switch sender.labelToChange {
        case "maxQuantity":
            modifyTextField(editEyeViewController!.maxQuantity, Int: Int(amount))
            eyeParams[.quantity] = editEyeViewController!.maxQuantity.text!
            //updateForChanges(editEyeViewController!.maxQuantity)
        case "maxDelta":
            modifyTextField(editEyeViewController!.maxDelta, amount: amount)
            eyeParams[.delta] = editEyeViewController!.maxDelta.text!.removeZeros()
            //updateForChanges(editEyeViewController!.maxDelta)
        case "minEdge":
            modifyTextField(editEyeViewController!.minEdge, amount: amount)
            eyeParams[.minEdge] = editEyeViewController!.minEdge.text!.removeZeros()
            //updateForChanges(editEyeViewController!.minEdge)
        case "lowDelta":
            modifyTextField(editEyeViewController!.lowDelta, amount: amount)
            eyeParams[.minDelta] = editEyeViewController!.lowDelta.text!.removeZeros()
            //updateForChanges(editEyeViewController!.lowDelta)
        case "highDelta":
            modifyTextField(editEyeViewController!.highDelta, amount: amount)
            eyeParams[.maxDelta] = editEyeViewController!.highDelta.text!.removeZeros()
            //updateForChanges(editEyeViewController!.highDelta)
        case "totalDelta":
            modifyTextField(editEyeViewController!.totalDelta, amount: amount)
            eyeParams[.totalDelta] = editEyeViewController!.totalDelta.text!.removeZeros()
            //updateForChanges(editEyeViewController!.totalDelta)
        case "price":
            modifyTextField(editEyeViewController!.price, amount: amount)
            eyeParams[.price] = editEyeViewController!.price.text!.removeZeros()
            //updateForChanges(editEyeViewController!.price)
        default: break
            
        }
        activateSaveIfNecessary()
    }
    
    func modifyTextField(textField:EditEyeParameter, amount:Double) {
        print("\(Double(textField.text!))  + \(amount)")
        if let textAmount:Double = Double(textField.text!) {
            let newAmount = textAmount + amount
            if newAmount < 0 {
                textField.text = String(0.0)
            } else if remainder(newAmount, 1.0) != 0.0 {
                textField.text = String(newAmount).removeZeros(true)
            } else {
                textField.text = String(newAmount).removeZeros(false)
            }
        } else {
            textField.text = String(amount)
        }
    }
    
    func modifyTextField(textField:EditEyeParameter, Int amount:Int) {
        if let textAmount:Int = Int(textField.text!) {
            let newAmount = textAmount + amount
            textField.text = String(newAmount)
        } else {
            textField.text = String(amount)
        }
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectAll(nil)
        selectedStrikeEyeParameter = textField as! EditEyeParameter
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch curShiftState {
        case .forceshiftingright:
            curShiftState = .shiftingright
            shift(textField)
        default:
            textField.resignFirstResponder()
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editeye" {
            editEyeViewController = (segue.destinationViewController as! EditEyeViewController)
        }
    }
}
