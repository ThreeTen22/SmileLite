//
//  LayoutStructs.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/2/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

public struct CellLayout {
    
    static var strikeTitleBGColor = UIColor(red255: 2.0, green: 13.0, blue: 130.0, alpha: 1.0)
    
    static var strikeMaturityBGColorDark = UIColor(red255: 25.0, green: 29.0, blue: 113.0, alpha: 1.0)
    static var strikeMaturityBGColorLight = UIColor(red255: 74.0, green: 60.0, blue: 138.0, alpha: 1.0)
    
    static var strikeDefaultBGColor = UIColor.whiteColor()
    static var strikeDefaultTextColorDark = UIColor.blackColor()
    
    static var strikeDefaultTextColorLight = UIColor.whiteColor()
    
    
    static var strikePositionBGColor = UIColor(red255: 41.0, green: 250.0, blue: 46.0, alpha: 1.0)
    static var strikePositionTextColorLong = UIColor.blueColor()
    static var strikePositionTextColorShort = UIColor.redColor()
    
    static var strikeTheoBGColorNeutral = UIColor.lightGrayColor()
    static var strikeTheoBGColorAboveValue = UIColor.blueColor()
    static var strikeTheoBGColorBelowValue = UIColor.redColor()
    
    static var monthEyeBGColor = UIColor(red255: 205.0, green: 205.0, blue: 225.0, alpha: 1.0)
    
    static var monthEyeInstallBGColor =  UIColor(rgb: 0x006600)
    static var monthEyeTheoButtonBGColor = UIColor(rgb: 0x99cccc)
    
    static var errorColor = UIColor(red255: 253.0, green: 123.0, blue: 88.0, alpha: 1.0)
    
    
    
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
