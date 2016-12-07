//
//  CalculatorInputView.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/2/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class EditEyeViewController: UIViewController {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var isMonthEye = true
    
    @IBOutlet weak var maxQuantity: UITextField!
    @IBOutlet weak var maxDelta: UITextField!
    @IBOutlet weak var minEdge: UITextField!
    @IBOutlet weak var lowDelta: UITextField!
    @IBOutlet weak var highDelta: UITextField!
    @IBOutlet weak var totalDelta: UITextField!
    
    weak var delegateController:UITextFieldDelegate?
    weak var currentEye:Eye?
    
    override func viewDidLoad() {
        self.view!.backgroundColor = CellLayout.monthEyeBGColor
        
        maxQuantity.delegate = delegateController
        maxDelta.delegate = delegateController
        minEdge.delegate = delegateController
        
        if isMonthEye {
            lowDelta.delegate = delegateController
            highDelta.delegate = delegateController
            totalDelta.delegate = delegateController
        } else {
            lowDelta.hidden = true
            highDelta.hidden = true
            totalDelta.hidden = true
        }
        
    }
    
    func setDelegates(deleController:UITextFieldDelegate) {
        delegateController = deleController
    }

}
