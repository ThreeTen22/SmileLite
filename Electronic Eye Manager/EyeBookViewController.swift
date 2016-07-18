//
//  EyeListViewController.swift
//  Electronic Eye Manager
//
//  Created by Grant on 7/12/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EyeBookViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate {
    
    @IBAction func FocusBtnPressed(sender: UIButton) {
        if let senderCellContainer = sender.superview!.superview as? EyeBookTableViewCell {
            senderCellContainer.changeActiveButton(sender.tag-1, sender)
        }
    }
    
    
    @IBAction func TestLink(sender: AnyObject) {
        performSegueWithIdentifier("MonthEye", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Test", forIndexPath: indexPath)
        // cell.layer.borderWidth = 1.0
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Test", forIndexPath: indexPath)
        return cell
    }
    
}

