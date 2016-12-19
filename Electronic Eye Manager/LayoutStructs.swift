//
//  LayoutStructs.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/2/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

struct Layout {
    
    static let eyeBookBGColor:UIColor = UIColor(red255: 254, green: 230, blue: 184)
    
    static let eyeBookListingCollectionBGColor:UIColor = UIColor(red255: 213, green: 181, blue: 142)
    
    static let eyeBookListingTableCellBGColor:UIColor = UIColor(red255: 189, green: 189, blue: 189)
    
    static let strikeTitleBGColor:UIColor = UIColor(red255: 2, green: 13, blue: 130)
    
    static let strikeMaturityBGColorDark:UIColor = UIColor(red255: 25, green: 29, blue: 113)
    static let strikeMaturityBGColorLight:UIColor = UIColor(red255: 74, green: 60, blue: 138)
    
    static let strikeDefaultBGColor:UIColor = UIColor.whiteColor()
    static let strikeDefaultTextColorDark:UIColor = UIColor.blackColor()
    
    static let strikeDefaultTextColorLight:UIColor = UIColor.whiteColor()
    
    
    static let strikePositionBGColor:UIColor = UIColor(red255: 41, green: 250, blue: 46)
    static let strikePositionTextColorLong:UIColor = UIColor.blueColor()
    static let strikePositionTextColorShort:UIColor = UIColor.redColor()
    
    static let strikeTheoBGColorNeutral:UIColor = UIColor.lightGrayColor()
    static let strikeTheoBGColorAboveValue:UIColor = UIColor.blueColor()
    static let strikeTheoBGColorBelowValue:UIColor = UIColor.redColor()
    
    static let monthEyeBGColor:UIColor = UIColor(red255: 205, green: 205, blue: 225)
    
    static let monthEyeInstallBGColor:UIColor =  UIColor(rgb: 0x006600)
    static let monthEyeTheoButtonBGColor:UIColor = UIColor(rgb: 0x99cccc)
    
    static let eyeDeleteButtonColor:UIColor = UIColor.redColor()
    static let eyeCancelButtonColor:UIColor = UIColor.redColor()
    
    static let errorColor:UIColor = UIColor(red255: 253, green: 123, blue: 88)
    
    static let radioButtonColorOn = UIColor.blueColor()
    static let radioButtonColorOff = UIColor.lightGrayColor()
   
    static func setRadioButtonLayout(sender:UIButton, isOn:Bool = false) {
        if isOn {
            sender.setFAIcon(FAType.FADotCircleO, iconSize: 20, forState: .Normal)
            sender.setFATitleColor(radioButtonColorOn)
        } else {
            sender.setFAIcon(FAType.FACircleO, iconSize: 20, forState: .Normal)
            sender.setFATitleColor(radioButtonColorOff)

        }
    }
    
    
    static func setLayout(cell:UIView, label:UILabel, type:StrikeType, altMaturity:Bool = false) {
        switch type {
        case .maturity, .strike:
            if altMaturity {
                cell.backgroundColor = strikeMaturityBGColorLight
            } else {
                cell.backgroundColor = strikeMaturityBGColorDark
            }
            label.textColor = strikeDefaultTextColorLight
        case .calldelta:
            cell.backgroundColor = strikeDefaultBGColor
            label.textColor = strikeDefaultTextColorDark
        case .title:
            label.font = label.font.fontWithSize(12.0)
            cell.backgroundColor = strikeTitleBGColor
            label.textColor = strikeDefaultTextColorLight
            
        case .position, .callposition, .putposition:
            cell.backgroundColor = strikePositionBGColor
            switch getPosition(label) {
            case .neutral:
                label.textColor = strikeDefaultTextColorDark
            case .long:
                label.textColor = strikePositionTextColorLong
            case .short:
                label.textColor = strikePositionTextColorShort
            default:
                label.textColor = errorColor
                label.text = "ERROR"
            }
        case .calltheo, .puttheo:
            cell.backgroundColor = strikeTheoBGColorNeutral
            label.textColor = strikeDefaultTextColorDark
        default:
            cell.backgroundColor = strikeDefaultBGColor
            label.textColor = strikeDefaultTextColorDark
        }
    }
    
    static func setDefaultLayout(cell:UIView, label:UILabel) {
        cell.backgroundColor = strikeDefaultBGColor
        label.textColor = strikeDefaultTextColorDark
    }
    
    static func getPosition(label:UILabel) -> Position {
        if let labelText = label.text {
            if let curPos = Int(labelText) {
                if curPos > 0 {
                    return Position.long
                }
                if curPos < 0 {
                    return Position.short
                }
                return Position.neutral
            }
            //print("ERROR: setLayout.getPosition - error unwrapping curPos")
            return Position.null
        }
        //print("ERROR: setLayout.getPosition - error unwrapping labeltext")
        return Position.null
    }
    
    
}

