//
//  GraphViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/21/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    @IBOutlet var graph: GraphContainerView!
    
    @IBOutlet var xAxisLabels: UIStackView!
    @IBOutlet var yAxisLabels: UIStackView!
    
    override func viewDidLoad() {
        let xAxisSubViews = xAxisLabels.arrangedSubviews
        var text = ""
        for i in 0..<9 {
            if let x = (xAxisSubViews[i] as? UILabel) {
                
                text = "\(5.0/Double(10)*Double(i+1))"
                x.text = removeAfterIndex(Source: text, CutOffIndex: 4)
            }
        }
        
        let yAxisSubViews = yAxisLabels.arrangedSubviews
        for i in 1..<5 {
            if let y = (yAxisSubViews[i].viewWithTag(1) as? UILabel) {
                
                text = "\(Int(25000.0-(25000.0/Double(yAxisSubViews.count)*Double(i))))"
                y.text = removeAfterIndex(Source: text, CutOffIndex: 5)
            }
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func redrawGraph() {
        graph.setNeedsDisplay()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
