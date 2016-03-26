//
//  TopTextFieldDelegate.swift
//  Meme1
//
//  Created by Youngsun Paik on 3/23/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import Foundation
import UIKit

class TopTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString = textField.text!
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        
        
        textField.text = newText as String
        
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.placeholder == "TOP" {
            textField.placeholder = ""
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}