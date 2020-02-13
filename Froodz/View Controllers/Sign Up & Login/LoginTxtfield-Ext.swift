//
//  LoginTxtfield-Ext.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/13/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case fullnameTextfield:
            fullnameTextfield.resignFirstResponder()
        case usernameTextfield:
            usernameTextfield.resignFirstResponder()
        default:
            phoneTextfield.resignFirstResponder()
        }
        
        return true
    }
   
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        phoneTextfield.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        phoneTextfield.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !fullnameTextfield.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if !fullnameTextfield.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0 {
                    if usernameTextfield.isFirstResponder {
                        self.view.frame.origin.y += keyboardSize.height
                    } else {
                        self.view.frame.origin.y += (keyboardSize.height)
                    }
                }
            }
        }
    }
}
