//
//  EyeParameterStruct.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/18/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import Foundation


struct EyeParams:Equatable {
    enum params {
     case quantity
     case minEdge
     case delta
     case eyeType
     case orderType
     case autoHedge
     case price
     case minDelta
     case maxDelta
     case totalDelta
    }
    
    
    var useMonthParams = false
    var quantity = "1"
    var minEdge = "0.1"
    var delta = "250.0"
    var eyeType = "Theo"
    var orderType = "LMT"
    var autoHedge = "OFF"
    var price = ""
    
    var minDelta = ""
    var maxDelta = ""
    var totalDelta = ""
    
    var minEdgeF = "0.1"
    
    subscript(param:params) -> String {
        get {
            switch param{
            case .quantity:
                return quantity
            case .minEdge:
                return minEdge
            case .delta:
                return delta
            case .eyeType:
                return eyeType
            case .orderType:
                return orderType
            case .autoHedge:
                return autoHedge
            case .price:
                return price
            case .minDelta:
                return minDelta
            case .maxDelta:
                return maxDelta
            case .totalDelta:
                return totalDelta
            }
        }
        
        set {
            switch param {
            case .quantity:
                quantity = newValue
            case .minEdge:
                minEdge = newValue
                minEdgeF = newValue.removeZeros(true)
            case .delta:
                delta = newValue
            case .eyeType:
                eyeType = newValue
            case .orderType:
                orderType = newValue
            case .autoHedge:
                autoHedge = newValue
            case .price:
                price = newValue
            case .minDelta:
                minDelta = newValue
            case .maxDelta:
                maxDelta = newValue
            case .totalDelta:
                totalDelta = newValue
            }
        }
    }
    
    
    
    
    
    
    init() {
    }
    
    init(_ isMonthEye:Bool) {
        useMonthParams = isMonthEye
        if useMonthParams {
            minDelta = "1.0"
            maxDelta = "100.0"
            totalDelta = "1000.0"
        }
    }
    
    init(_ eyeDict:JSON) {
        quantity = eyeDict["quantity"].stringValue
        minEdge = eyeDict["edge"].stringValue.removeZeros()
        delta = eyeDict["delta"].stringValue.removeZeros()
        eyeType = eyeDict["eyetype"].stringValue
        orderType = eyeDict["ordertype"].stringValue
        autoHedge = eyeDict["autohedge"].stringValue
        price = eyeDict["price"].stringValue.removeZeros()
        if eyeDict["entitytype"].intValue != 0 && eyeDict["strike"].double == nil {
            useMonthParams = true
            minDelta = eyeDict["mindelta"].stringValue.removeZeros()
            maxDelta = eyeDict["maxdelta"].stringValue.removeZeros()
            totalDelta = eyeDict["totaldelta"].stringValue.removeZeros()
        }
        minEdgeF = minEdge.removeZeros(true)
        
    }
    mutating func setMinEdgeF(str:String) {
        minEdgeF = str.removeZeros(true)
        
    }
}

func ==(left:EyeParams, right:EyeParams) -> Bool {
    if (left.useMonthParams == true) && (left.useMonthParams == right.useMonthParams)  {
        if  left.quantity == right.quantity &&
            left.minEdge == right.minEdge &&
            left.delta == right.delta &&
            left.eyeType == right.eyeType &&
            left.autoHedge == right.autoHedge &&
            left.minDelta == right.minDelta &&
            left.maxDelta == right.maxDelta &&
            left.totalDelta == right.totalDelta &&
            left.price == right.price {
            return true
        }
        return false
    } else if (left.useMonthParams == right.useMonthParams) {
        if  left.quantity == right.quantity &&
            left.minEdge == right.minEdge &&
            left.delta == right.delta &&
            left.eyeType == right.eyeType &&
            left.autoHedge == right.autoHedge &&
            left.price == right.price {
            return true
        }
        return false
    }
    return false
}

func !=(left:EyeParams, right:EyeParams) -> Bool {
    return !(left == right)
}
