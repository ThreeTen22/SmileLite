//
//  EyeParameterStruct.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/18/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import Foundation


struct EyeParams:Equatable {
    var useMonthParams = false
    var quantity = "1"
    var minEdge = "0.1" {
        didSet(setValue) {
            setMinEdgeF(setValue)
        }
    }
    var delta = "250.0"
    var eyeType = "Theo"
    var orderType = "LMT"
    var autoHedge = "OFF"
    var price = ""
    
    var minDelta = ""
    var maxDelta = ""
    var totalDelta = ""
    
    var minEdgeF = "0.1"
    
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
        minEdge = eyeDict["edge"].stringValue.removeZeros(false)
        delta = eyeDict["delta"].stringValue.removeZeros(false)
        eyeType = eyeDict["eyetype"].stringValue
        orderType = eyeDict["ordertype"].stringValue
        autoHedge = eyeDict["autohedge"].stringValue
        price = eyeDict["price"].stringValue.removeZeros(false)
        if eyeDict["entitytype"].intValue != 0 && eyeDict["strike"].double == nil {
            useMonthParams = true
            minDelta = eyeDict["mindelta"].stringValue
            maxDelta = eyeDict["maxdelta"].stringValue
            totalDelta = eyeDict["totaldelta"].stringValue
        }
        setMinEdgeF(minEdge)
        
    }
    mutating func setMinEdgeF(str:String) {
        minEdgeF = str.removeZeros()
        
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
