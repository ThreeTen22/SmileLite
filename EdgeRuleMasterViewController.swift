//
//  EdgeRuleMasterViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/13/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

var BCSPEdgeRule:NSArray = NSArray()

class EdgeRuleMasterViewController: UIViewController {
    
    @IBOutlet var BuyCallSellPut: [UILabel]!
    @IBOutlet var navBar: UINavigationItem!
    
    @IBAction func EditBCSP(sender: AnyObject) {
        print("button Pressed")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(String(xonData[0][0]))
        print(String(xonData[0][1]))
        print(String(xonData[0][2]))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(sender!)
        print("Hello")
    }
    
}

