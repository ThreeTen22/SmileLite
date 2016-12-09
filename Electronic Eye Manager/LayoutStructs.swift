//
//  LayoutStructs.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/2/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

struct Layout {
    
    static var eyeBookBGColor = UIColor(red255: 254, green: 230, blue: 184)
    
    static var eyeBookListingCollectionBGColor = UIColor(red255: 213, green: 181, blue: 142)
    
    static var eyeBookListingTableCellBGColor = UIColor(red255: 189, green: 189, blue: 189)
    
    static var strikeTitleBGColor = UIColor(red255: 2, green: 13, blue: 130)
    
    static var strikeMaturityBGColorDark = UIColor(red255: 25, green: 29, blue: 113)
    static var strikeMaturityBGColorLight = UIColor(red255: 74, green: 60, blue: 138)
    
    static var strikeDefaultBGColor = UIColor.whiteColor()
    static var strikeDefaultTextColorDark = UIColor.blackColor()
    
    static var strikeDefaultTextColorLight = UIColor.whiteColor()
    
    
    static var strikePositionBGColor = UIColor(red255: 41, green: 250, blue: 46)
    static var strikePositionTextColorLong = UIColor.blueColor()
    static var strikePositionTextColorShort = UIColor.redColor()
    
    static var strikeTheoBGColorNeutral = UIColor.lightGrayColor()
    static var strikeTheoBGColorAboveValue = UIColor.blueColor()
    static var strikeTheoBGColorBelowValue = UIColor.redColor()
    
    static var monthEyeBGColor = UIColor(red255: 205, green: 205, blue: 225)
    
    static var monthEyeInstallBGColor =  UIColor(rgb: 0x006600)
    static var monthEyeTheoButtonBGColor = UIColor(rgb: 0x99cccc)
    
    static var errorColor = UIColor(red255: 253, green: 123, blue: 88)
   
    
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

