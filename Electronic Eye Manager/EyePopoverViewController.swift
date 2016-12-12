//
//  ModifyEyePopoverViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/28/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EyePopoverViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    private enum ShiftState:Int {
        case notshifted = 0
        case shiftingright = 1
        case hasshifted = 2
        case shiftingleft = 3
        case forceshiftingleft = 4
    }
    private var curShiftState:ShiftState = .notshifted
    
    
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
    
    @IBAction func shift(sender: UITextField) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {[unowned self] in
            //var newFrame = self.view.frame
            var contFrame = self.containerView.frame
            
            switch self.curShiftState {
            case .shiftingleft, .forceshiftingleft:
                //newFrame = CGRect(x: newFrame.minX, y: newFrame.minY, width: newFrame.width-(self.calcView.frame.width), height: newFrame.height)
                    contFrame.origin.x -= self.calcView.bounds.width
            case .shiftingright:
                //newFrame = CGRect(x: newFrame.minX, y: newFrame.minY, width: newFrame.width+(self.calcView.frame.width), height: newFrame.height)
                contFrame.origin.x += self.calcView.bounds.width
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
                    case .shiftingright?:
                       self?.curShiftState = .hasshifted
                       sender?.becomeFirstResponder()
                    //sender?.selectAll(nil)
                    case .shiftingleft?:
                       self?.curShiftState = .notshifted
                    case .forceshiftingleft?:
                        self?.curShiftState = .notshifted
                    default: break
                    }
                //print("I AM COMPLETED")
                }
            })
    }
    
    @IBOutlet weak var buySellLabel: UILabel!
    
    @IBOutlet weak var govAccumulatedDelta: UITextField!
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var maturity: UILabel!
    @IBOutlet weak var strike: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var calcView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var exchangeTable:ExchangeTableView!
    
    
    
    var hasShifted = false
    
    weak var currentListing:Listing!
    
    var currentStrikePrice:Double?
    
    weak var selectedStrikeEyeParameter:UITextField!
    weak var editEyeViewController:EditEyeViewController?
    
    weak var currentTextField:UITextField?
    
    var orderType:Order = Order.NA
    var isMonthEye:Bool = false
    var isBuy:Bool = false
    var strikeJSON:JSON?
    
    
    weak var currentContainer:MonthContainer?
    weak var currentEye:Eye?
    weak var currentDate:NSDate!
    
    deinit {
        //print("deinit: eyepopoverVC")
    }
    
    override func viewDidLoad() {
        
        closeButton.setFAIcon(FAType.FAClose, iconSize: 30.0, forState: .Normal)
        closeButton.setFATitleColor(Layout.eyeCancelButtonColor)
        
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
            editEyeViewController!.setDelegates(self)
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
        
        //marketTable.backgroundColor = Layout.monthEyeBGColor
        //marketTable.dataSource = self
        //marketTable.delegate = self
        //marketTable.reloadData()
        super.viewDidLoad()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch curShiftState {
        case .hasshifted, .shiftingleft:
            curShiftState = .forceshiftingleft
            view.endEditing(true)
        default:
            break
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.inputView = UIView()
        switch curShiftState {
        case .notshifted:
            curShiftState = .shiftingright
            shift(textField)
            return false
        case .hasshifted:
            return true
        default:
            return false
        }
        
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectAll(nil)
        selectedStrikeEyeParameter = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        switch curShiftState {
        case .forceshiftingleft:
            curShiftState = .shiftingleft
            shift(textField)
        default:
            textField.resignFirstResponder()
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Market", forIndexPath: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = Exchanges.exchangeNames(indexPath.row)
        //cell.selected = true
        //cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editeye" {
            //print("segue")
            let editEye = (segue.destinationViewController as! EditEyeViewController)
            editEyeViewController = editEye
        }
    }
}
