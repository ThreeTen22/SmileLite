//
//  ListingFilterButton.swift
//  Electronic Eye Manager
//
//  Created by Grant on 11/8/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class ListingFilterButton: UIButton {
    var listingSymbol = ""
    
    deinit {
       //print("deinit: listingFilterButton \(listingSymbol)")
    }
}




//button for the calculator
class CalcButton: UIButton {
    
    override func awakeFromNib() {
        setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.blackColor().CGColor
        backgroundColor = UIColor.lightGrayColor()
        
        //Debug: add target has stopped working now.  I dunno if it is because it is fully hidden when this is called, must be a bug.  Workaround is manually sending actions.
        //self.addTarget(nil, action: #selector(EyePopoverViewController.calcButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        backgroundColor = UIColor.grayColor()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        backgroundColor = UIColor.lightGrayColor()
        sendAction(#selector(EyePopoverViewController.calcButtonPressed(_:)), to: nil, forEvent: nil)

    }
    
    
    deinit {
        //print("deinit: calcButton")
    }
}

//button to control quick changes to the :labelToChange textfields by :changeAmount
class QuickChangeButton: UIButton {
    @IBInspectable var labelToChange: String = ""
    @IBInspectable var changeAmount: Double = 0.0
    
    override func awakeFromNib() {
        self.addTarget(nil, action: #selector(EyePopoverViewController.testChangeValue(_:)), forControlEvents: .TouchUpInside)
    }
    
    deinit {
        //self.removeTarget(nil, action: #selector(EyePopoverViewController.testChangeValue(_:)), forControlEvents: .TouchUpInside)
     //print("deinit: QuickchangeButton")
    }
}


class ExchangeOrderType: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.borderWidth = 0.5
        backgroundColor = Layout.strikeTheoBGColorNeutral
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
    }
    
}

class RadioButton:UIButton {
    // var exchange:ExInfo!
    
    static let NotifyOnlyString = "NotifyOnly"
    static let ToggleString = "Toggle"
    
    @IBInspectable var buttonTag:String = ""
    
    override func awakeFromNib() {
        //Layout.setRadioButtonLayout(self)
        //self.addTarget(nil, action: #selector(ExchangesTableCell.radioPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
}

class SaveCancelButton:UIButton {
    //set in inspecter
    @IBInspectable var isSaveButton:Bool = false
    @IBInspectable var isPlaceholder:Bool = false
    
    override func awakeFromNib() {
        Layout.setSaveCancelButton(self, isSaveButton: isSaveButton)
        if isPlaceholder == false {
            addTarget(nil, action: #selector(EyePopoverViewController.saveCancelButtonPressed(_:)), forControlEvents: .TouchUpInside)
        } else {
         setFATitleColor(Layout.eyeInstallTextColorDisabled)
        }
    }
}
