//
//  GraphContainerView.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/21/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class GraphContainerView: UIView {
    var xIntercept = 0.0
    var yCeiling = 0.0
    var slope = 0.0
    
    var maxX = 5.0
    var maxY = 25000.0
    let xAxis:UIBezierPath = UIBezierPath()
    let yAxis:UIBezierPath = UIBezierPath()
    
    override func awakeFromNib() {
        xAxis.lineWidth = 1.0
        yAxis.lineWidth = 1.0
    }
    override func drawRect(rect: CGRect) {
        var scbpPath:UIBezierPath = UIBezierPath()
        var bcspPath:UIBezierPath = UIBezierPath()
        let lineWidth:CGFloat = 1.0
        
        //create x/y axis
        xAxis.moveToPoint(CGPoint(x: rect.minX, y: rect.maxY))
        xAxis.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY))
        yAxis.moveToPoint(CGPoint(x: rect.minX, y: rect.minY))
        yAxis.addLineToPoint(CGPoint(x: rect.minX, y: rect.maxY))
        xAxis.stroke()
        yAxis.stroke()
        
        //create lines
        scbpPath = createPathUsing(PathContainer: rect, Type: 0)
        bcspPath = createPathUsing(PathContainer: rect, Type: 1)
        bcspPath.lineWidth = 1.0
        scbpPath.lineWidth = lineWidth
        scbpPath.stroke()
        bcspPath.stroke()
        
        //setNeedsDisplay()
    }
    
    func createPathUsing(PathContainer rect:CGRect, Type type:Int) -> UIBezierPath {
        
        if type == 0 {
            xIntercept = Double(scbpEdgeRule[0][2])!
            yCeiling = Double(Int(scbpEdgeRule[0][3])!)
            slope = Double(scbpEdgeRule[0][4])!
        } else {
            xIntercept = Double(bcspEdgeRule[0][2])!
            yCeiling = Double(Int(bcspEdgeRule[0][3])!)
            slope = Double(bcspEdgeRule[0][4])!
        }
        
        let width:Double = Double(rect.width)
        let height:Double = Double(rect.height)
        
        let newPath = UIBezierPath()
        
        let nextY = convertPoint(yCeiling, maxY, height)
        let newX = convertPoint(xIntercept, maxX, width)
        
        //If there is no slope, there is no xIntercept, which would ruin everything
        if slope != 0.0 {
            let nextX = (nextY - getYIntercept(xIntercept: newX, Slope: slope))/slope
            newPath.moveToPoint(CGPoint(x: newX, y: height - Double(rect.minY)))
            newPath.addLineToPoint(CGPoint(x: nextX, y: height - nextY))
            
        } else {
            newPath.moveToPoint(CGPoint(x: newX, y: height - nextY))
        }
        newPath.addLineToPoint(CGPoint(x: width, y: height - nextY))
        
        return newPath
    }
    // y - y1 = m(x - x1)
    // 0 = mx - m(var)
    func getYIntercept(xIntercept x:Double, Slope m:Double) -> Double {
        return (-1.0)*(m*x)
    }
    
    func convertPoint(point:Double,_ pointMax:Double, _ cgMax:Double) -> Double {
        return (point/pointMax)*(cgMax)
    }

}
