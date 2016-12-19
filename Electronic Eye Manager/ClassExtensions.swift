//
//  ClassExtensions.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/19/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import Foundation



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
    
    func toBool() -> Bool? {
        switch self {
        case "On":
            return true
        case "Off":
            return false
        default:
            return nil
        }
    }
    
    func removeAfterChar(char:Character, indx:Int) -> String {
        return removeAfterCharacter(Source: self, Character: char, CutOffIndex: indx)
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
