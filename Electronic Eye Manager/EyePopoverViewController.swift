//
//  ModifyEyePopoverViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/28/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit


class EyePopoverViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    private enum ShiftState {
        case notshifted
        case shiftingleft
        case hasshifted
        case shiftingright
        case forceshiftingright
    }
    private var curShiftState:ShiftState = .notshifted
    
    
    
    //IBAction
    @IBAction func calcButtonPressed(sender: UIButton) {
        //print("pressed")
        let buttonText:String = (sender.titleLabel?.text)! ?? ""
        if curShiftState != .hasshifted { return }
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
        updateParam(selectedStrikeEyeParameter!, value: selectedStrikeEyeParameter!.text!)
        // activateSaveIfNecessary()
        
    }
    
    
    @IBAction func radioPressed(sender: UIButton) {
        print("radioPressed")
        setButtonLayout(sender)
        //checkForChanges()
        //exchanges[isActive: sender.tag] = !exchanges[isActive: sender.tag]
        sender.sendAction(#selector(EyePopoverViewController.activateSaveIfNecessary), to: nil, forEvent: nil)
    }
    
    func setButtonLayout(senderOp:UIButton) {
        if let sender = senderOp as? RadioButton {
            print("setButtonLayout \(sender.buttonTag)")
            if sender.buttonTag == RadioButton.ToggleString {
                if exchangeData[isActiveExchange: sender.tag] == true {
                    exchangeData[isActiveExchange: sender.tag] = false
                } else {
                    exchangeData[isActiveExchange: sender.tag] = true
                }
                
                Layout.setRadioButtonLayout(sender, isOn: exchangeData[isActiveExchange: sender.tag])
                return
            }
            if sender.buttonTag == RadioButton.NotifyOnlyString {
                print("entered NotifyONly  \(exchangeData[notifyOnly: sender.tag])")
                if exchangeData[notifyOnly: sender.tag] == true {
                    exchangeData[notifyOnly: sender.tag] = false
                } else {
                    exchangeData[notifyOnly: sender.tag] = true
                }
                print("after  \(exchangeData[notifyOnly: sender.tag])")
                Layout.setRadioButtonLayout(sender, isOn: exchangeData[notifyOnly: sender.tag])
            }
        }
    }
    
    //IBAction
    @IBAction func orderTypeSelected(sender:UISegmentedControl) {
        
        let sindx = sender.selectedSegmentIndex
        let indxTitle = sender.titleForSegmentAtIndex(sindx)
        
        eyeParams.orderType = indxTitle ?? ""
        activateSaveIfNecessary()
    }
    
    //IBAction
    @IBAction func eyeTypeSelected(sender:UISegmentedControl) {
        
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
        
    }
    
    //IBAction
    @IBAction func shift(sender: UITextField) {
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
                        if sender?.isFirstResponder() == false {
                            sender?.becomeFirstResponder()
                        }
                    //sender?.selectAll(nil)
                    case .shiftingright?:
                        self?.curShiftState = .notshifted
                    case .forceshiftingright?:
                        self?.curShiftState = .notshifted
                    default: break
                    }
                    print("I AM COMPLETED")
                }
            })
    }
    
    
    //IBAction
    func saveCancelButtonPressed(sender:SaveCancelButton) {
        if sender.isSaveButton {
            if saveButtonEnabled == false {return}
            print("Saved")
        } else {
            print("Cancelled")
        }
        saveCreateEye = sender.isSaveButton
        //dismissViewControllerAnimated(true, completion: nil)
        sender.sendAction(#selector(EyeBookViewController.dismissPopoverProgramatically), to: nil, forEvent: nil)
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
    
    var saveButtonEnabled:Bool = false
    
    var orderType:Order = Order.NA
    var isMonthEye:Bool = false
    var isBuy:Bool = false
    var eyeJSON:JSON?
    var finishedSetup:Bool = false
    
    var eyeParams:EyeParams = EyeParams() {
        didSet {
            if finishedSetup {
                activateSaveIfNecessary()
            }
        }
    }
    //var eyeParams:EyeParams = EyeParams()
    
    var exchangeData:Exchanges = Exchanges()
    
    var tempStrikeEye:StrikeEye?
    var tempMonthEye:MonthEye?
    
    weak var currentContainer:MonthContainer?
    weak var currentEye:Eye?
    weak var currentDate:NSDate!
    
    var saveCreateEye:Bool = false
    
    var sourceEyeParams:EyeParams {
        return currentEye!.eyeParams
    }
    
    var sourceExchangeData:Exchanges {
        return currentEye!.exchangeData
    }
    
    
    deinit {
        print("deinit: eyepopoverVC")
        currentDate = nil
    }
    
    
    override func viewDidLoad() {
        closeButton.setFAIcon(FAType.FAClose, iconSize: 30.0, forState: .Normal)
        closeButton.setFATitleColor(Layout.eyeCancelTextColor)
        
        saveButton.setFAIcon(FAType.FACheck, iconSize: 30.0, forState: .Normal)
        saveButton.setFATitleColor(Layout.eyeInstallTextColor)
        
        if let eyeJS = eyeJSON {
            currentDate = smileDateFormat.dateFromString((eyeJS["odate"].stringValue))
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
                
                if currentEye == nil {
                    tempMonthEye = MonthEye(monthJSON: eyeJS, Symbol: currentListing.listingSymbol, SecurityId: currentListing.listingId)
                    tempMonthEye?.order = orderType
                    tempMonthEye?.isTempEye = true
                    currentEye = tempMonthEye
                }
                
                
            } else {
                if let currentEyes:[StrikeEye] = currentContainer?.GetStrikesByOrder(orderType) {
                    for eye in currentEyes {
                        //print("Debug: popover:viewdidLoad: strikeEyeArrayCheck: eye - \(eye)")
                        if eye.strike == Double(eyeJS["strike"].stringValue)! {
                            currentEye = eye
                            break
                        }
                    }
                    if currentEye == nil {
                        tempStrikeEye = StrikeEye(strikeJSON: eyeJS, Symbol: currentListing.listingSymbol, SecurityId: currentListing.listingId)
                        tempStrikeEye?.order = orderType
                        tempStrikeEye?.isTempEye = true
                        currentEye = tempStrikeEye
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
                strike.text = removeAfterCharacter(Source: eyeJS["strike"].stringValue, Character: ".", CutOffIndex: 1)
            }
            
            //print(currentEye)
            editEyeViewController!.isMonthEye = isMonthEye
            editEyeViewController!.currentListing = currentListing
            editEyeViewController!.eyeJSON = eyeJSON
            
            editEyeViewController!.currentEye = currentEye
            
            if currentEye != nil {
                eyeParams = sourceEyeParams
                exchangeData = sourceExchangeData
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
        activateSaveIfNecessary()
        finishedSetup = true
        
        super.viewDidLoad()
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
    
    
    
 
    
    func toggleSaveButton(isEnabled:Bool) {
        saveButtonEnabled = isEnabled
        if isEnabled {
            saveButton.hidden = false
            //saveButton.setFATitleColor(Layout.eyeInstallTextColor)
            return
        }
        saveButton.hidden = true
        //saveButton.setFATitleColor(Layout.eyeInstallTextColorDisabled)
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
        
       toggleSaveButton((currentEye!.isTempEye) || (sourceExchangeData != exchangeData) || (sourceEyeParams != eyeParams) )
        
        /*
        if editEyeViewController!.anyParamsChanged() || editEyeViewController!.exchangeTable.valueChanged {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
         */
        
    }
    /*
    func updateForChanges(tf:EditEyeParameter) {
        
        if labelTextsMatch(tf.text, tf.placeholder) {
            tf.valueChanged = false
        } else {
            tf.valueChanged = true
        }
        
        
        
    }
     */
    
    func labelTextsMatch(rlbl:String?,_ llbl:String?) -> Bool {
        //let rl = rlbl ?? ""
        //let ll = llbl ?? ""
        if rlbl == llbl {
            return true
        } else {
            return false
        }
    }
    
    func addEyeToContainer() {
        if isMonthEye {
            currentContainer?.AddEye(MonthEye: currentEye as! MonthEye)
        } else {
            currentContainer?.AddEye(StrikeEye: currentEye as! StrikeEye)
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
        case "totalDelta":
            modifyTextField(editEyeViewController!.totalDelta, amount: amount)
            eyeParams[.totalDelta] = editEyeViewController!.totalDelta.text!.removeZeros()
        case "price":
            modifyTextField(editEyeViewController!.price, amount: amount, keepPositive: true)
            eyeParams[.price] = editEyeViewController!.price.text!.removeZeros()
        default: break
            
        }
    }
    
    func updateParam(textField:EditEyeParameter, value:String) {
        
        switch textField.paramName {
        case "maxQuantity":
            eyeParams[.quantity] = value
        //updateForChanges(editEyeViewController!.maxQuantity)
        case "maxDelta":
            eyeParams[.delta] = value
        //updateForChanges(editEyeViewController!.maxDelta)
        case "minEdge":
            eyeParams[.minEdge] = value
        //updateForChanges(editEyeViewController!.minEdge)
        case "lowDelta":
            eyeParams[.minDelta] = value
        //updateForChanges(editEyeViewController!.lowDelta)
        case "highDelta":
            eyeParams[.maxDelta] = value
        case "totalDelta":
            eyeParams[.totalDelta] = value
        case "price":
            eyeParams[.price] = value
        default: break
            
        }
        
    }
    
    func modifyTextField(textField:EditEyeParameter, amount:Double, keepPositive:Bool = true) {
        print("\(Double(textField.text!))  + \(amount)")
        var newText:String = ""
        if let textAmount:Double = Double(textField.text!) {
            let newAmount = textAmount + amount
             if remainder(newAmount, 1.0) != 0.0 {
                newText = String(newAmount).removeZeros(true)
            } else {
                newText = String(newAmount).removeZeros(false)
            }
            if keepPositive {
                if newAmount < 0.0 {
                    newText = "0.0"
                }
            }
        } else {
                newText = String(amount)
        }
        textField.text = newText
        
    }
    
    func modifyTextField(textField:EditEyeParameter, Int amount:Int, keepPositive:Bool = true) {
        var newText:String = ""
        if let textAmount:Int = Int(textField.text!) {
            let newAmount = textAmount + amount
            newText = String(newAmount)
            if keepPositive {
                if textAmount < 0 {
                    newText = "0"
                }
            }
        } else {
            newText = String(amount)
        }
        
        if keepPositive {
            if let textAmount:Int = Int(newText) {
                if textAmount < 0 {
                newText = "0"
                }
            }
        }
        
        textField.text = newText
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
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        selectedStrikeEyeParameter = textField as! EditEyeParameter
        selectedStrikeEyeParameter.selectAll(nil)
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeData.visibleExchangeCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Market") as! ExchangesTableCell
        cell.exchangeName.text = Exchanges.exchangeNames(exchangeData[namedIndx: (indexPath.row+1)])
        cell.toggleRadioButton.tag = (indexPath.row+1)
        cell.notifyOnlyradioButton.tag = (indexPath.row+1)
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        weak var cellRB:ExchangesTableCell? = (cell as? ExchangesTableCell)
        Layout.setRadioButtonLayout(cellRB?.toggleRadioButton, isOn: exchangeData[isActiveExchange: (indexPath.row+1)])
        Layout.setRadioButtonLayout(cellRB?.notifyOnlyradioButton, isOn: exchangeData[notifyOnly: (indexPath.row+1)])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editeye" {
            editEyeViewController = (segue.destinationViewController as! EditEyeViewController)
        }
    }
}
