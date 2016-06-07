//
//  TableViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/7/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
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
    
    
}
