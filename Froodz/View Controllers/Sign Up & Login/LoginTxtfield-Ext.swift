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
            checkTextValue(textfield: textField, lbl: fullNameLbl)
            fullnameTextfield.resignFirstResponder()
            usernameTextfield.becomeFirstResponder()
        case usernameTextfield:
            checkTextValue(textfield: textField, lbl: usernameLbl)
            usernameTextfield.resignFirstResponder()
            phoneTextfield.becomeFirstResponder()
        default:
            checkTextValue(textfield: textField, lbl: phoneLbl)
            phoneTextfield.resignFirstResponder()
        }
        return true
    }
    
    func checkTextValue(textfield: UITextField, lbl: UILabel) {
        if textfield.text != "", textfield.text != nil {
            lbl.textColor = Constants.Color.lightGray
        } else {
            lbl.textColor = Constants.Color.primaryBlackText
        }
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
        checkTextValue(textfield: phoneTextfield, lbl: phoneLbl)
        phoneTextfield.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if phoneTextfield.isFirstResponder {
            UIView.animate(withDuration: 1.0) {
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= keyboardSize.height / 2
                    }
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if phoneTextfield.isFirstResponder {
            UIView.animate(withDuration: 1.0) {
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    if self.view.frame.origin.y != 0 {
                        if self.phoneTextfield.isFirstResponder {
                            self.view.frame.origin.y += keyboardSize.height / 2
                        } else {
                            self.view.frame.origin.y += (keyboardSize.height) / 2
                        }
                    }
                }
            }
        }
    }
}
