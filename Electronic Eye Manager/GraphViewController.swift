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
    
    override func viewDidLoad() {
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
