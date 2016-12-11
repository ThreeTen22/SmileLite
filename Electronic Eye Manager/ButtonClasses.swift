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


class CalcButton: UIButton {
    
    override func awakeFromNib() {
        setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.blackColor().CGColor
        backgroundColor = UIColor.lightGrayColor()
        
        self.addTarget(nil, action: #selector(EyePopoverViewController.calcButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        backgroundColor = UIColor.grayColor()
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        backgroundColor = UIColor.lightGrayColor()
        super.touchesEnded(touches, withEvent: event)
    }
    
    deinit {
        //print("deinit: calcButton")
    }
}


class QuickChangeButton: UIButton {
    var labelToChange: String = ""
    var changeAmount: Double = 0.0
    
    override func awakeFromNib() {
        self.addTarget(nil, action: #selector(EditEyeViewController.testChangeValue(_:)), forControlEvents: .TouchUpInside)
    }
    
    deinit {
        self.removeTarget(nil, action: #selector(EditEyeViewController.testChangeValue(_:)), forControlEvents: .TouchUpInside)
     //print("deinit: QuickchangeButton")
    }
}
