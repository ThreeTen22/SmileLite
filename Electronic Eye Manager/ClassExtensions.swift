//
//  ClassExtensions.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/19/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import Foundation


extension Array {
    subscript(tryWith indx:Int) -> Element? {
        get {
            if indx < self.count {
                return self[indx]
            }
            return nil
        }
    }
}
extension String {
    func asInt() -> Int? {
        return Int(self)
    }
    
    func asFloat() -> Float? {
        return Float(self)
    }
    
    func asDouble() -> Double? {
        return Double(self)
    }
    
    func asBool() -> Bool? {
        switch self {
        case "On","true","1":
            return true
        case "Off","false","0":
            return false
        default:
            return nil
        }
    }
    
    func removeAfterChar(char:Character, indx:Int) -> String {
        return removeAfterCharacter(Source: self, Character: char, CutOffIndex: indx)
    }
    
    func formatNumberForTextField(removeDot:Bool = true) -> String {
        if let dblSelf = Double(self) {
            if remainder(dblSelf, 1) == 0 && dblSelf > 0.0 {
                if removeDot {
                    return String(Int(self))
                }
                return String(Int(self)) + dotString
            }
            if dblSelf < 1.0 {
               return removeBeforeCharacter(Source: String(dblSelf), Character: dotChar)
            }
        }
        return self
    }
    
    func removeZeros(beforeDot:Bool = false) -> String {
      return removeExtraZeros(self, alsoBeforeDot: beforeDot)
    }
}

extension Int {
    mutating func OneOrZero() -> Void {
        if self == 0 {
            self = 1
        } else {
            self = 0
        }
    }
    
    func toBool() -> Bool? {
        switch self {
        case 0:
            return false
        case 1:
            return true
        default:
            return nil
        }
    }
    
    func isNotZero() -> Bool {
        if self != 0 {
            return true
        }
        return false
    }
    
    func isZero() -> Bool {
        if self != 0 {
            return false
        }
        return true
    }
    func isZeroHash() -> Int {
        if self != 0 {
            return 1
        }
        return 0
    }
}

extension Bool {
    func toParamString() -> String {
        if self {
            return "On"
        }
        return "Off"
    }
}
