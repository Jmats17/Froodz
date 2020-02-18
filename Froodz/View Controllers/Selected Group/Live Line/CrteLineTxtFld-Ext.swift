//
//  CreateLineTxtFld-Ext.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

extension CreateLineViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

extension CreateLineViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Constants.Color.placeholderColor {
            textView.text = nil
            textView.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
            textView.textColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Santa Clause not making to to my house before 7AM"
            textView.font = UIFont.systemFont(ofSize: 22.0, weight: .regular)
            textView.textColor = Constants.Color.placeholderColor
        }
    }
}
