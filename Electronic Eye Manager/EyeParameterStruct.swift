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
    var minEdge = "0.1"
    var delta = "250.0"
    var eyeType = "Theo"
    var autoHedge = "OFF"
    
    var minDelta = ""
    var maxDelta = ""
    var totalDelta = ""
    
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
        quantity = (eyeDict["quantity"].stringValue).removeAfterChar(".", indx: 1)
        minEdge = eyeDict["edge"].stringValue.removeAfterChar(".", indx: 1)
        delta = eyeDict["delta"].stringValue.removeAfterChar(".", indx: 1)
        eyeType = eyeDict["eyetype"].stringValue.removeAfterChar(".", indx: 1)
        autoHedge = eyeDict["autohedge"].stringValue.removeAfterChar(".", indx: 1)
        if eyeDict["entitytype"].intValue != 0 &&  eyeDict["strike"].double == nil {
            useMonthParams = true
            minDelta = eyeDict["mindelta"].stringValue.removeAfterChar(".", indx: 1)
            maxDelta = eyeDict["maxdelta"].stringValue.removeAfterChar(".", indx: 1)
            totalDelta = eyeDict["totaldelta"].stringValue.removeAfterChar(".", indx: 1)
        }
    }
}

func ==(left:EyeParams, right:EyeParams) -> Bool {
    if left.useMonthParams {
        if  left.quantity == right.quantity &&
            left.minEdge == right.minEdge &&
            left.delta == right.delta &&
            left.eyeType == right.eyeType &&
            left.autoHedge == right.autoHedge &&
            left.minDelta == right.minDelta &&
            left.maxDelta == right.maxDelta &&
            left.totalDelta == right.totalDelta {
            return true
        }
        return false
    } else {
        if  left.quantity == right.quantity &&
            left.minEdge == right.minEdge &&
            left.delta == right.delta &&
            left.eyeType == right.eyeType &&
            left.autoHedge == right.autoHedge {
            return true
        }
        return false
    }
}

func !=(left:EyeParams, right:EyeParams) -> Bool {
    return !(left == right)
}
