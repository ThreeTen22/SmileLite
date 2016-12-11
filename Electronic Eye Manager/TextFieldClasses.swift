//
//  StrikeCellTextField.swift
//  Electronic Eye Manager
//
//  Created by Grant on 12/2/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

class StrikeCellTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        let item:UITextInputAssistantItem = inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
        clearsOnInsertion = true
    }
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        return CGRectZero
    }
    
    deinit {
     //print("deinit: StrikeCellTextField")
     delegate = nil
    }
    
}

class EditEyeParameter:UITextField {
    
    override func awakeFromNib() {
        let item:UITextInputAssistantItem = inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
        text = ""
    }
    func setupText(str:String) {
        self.text = str
        self.placeholder = str
    }
    
    deinit {
        //print("deinit: EditEyeParameters")
    }
    
}
