//
//  CrteLinePicker-Ext.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/17/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

extension CreateLineViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 40.0, weight: .semibold)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerValue = pickerData[row]
        numberTextField.resignFirstResponder()
        
        switch pickerData[row] {
        case "Odds":
            numberTextField.addPointFive_ToolBar(view: self.view)
            numberTextField.placeholder = "3.5"
        case "Total":
            numberTextField.addPointFive_ToolBar(view: self.view)
            numberTextField.placeholder = "10"
        case "Coin Line":
            numberTextField.addPlusMinusToolBar(view: self.view)
            numberTextField.placeholder = "-1000"
        default:
            numberTextField.addPointFive_ToolBar(view: self.view)
            numberTextField.placeholder = "3.5"
        }
    }
    
}
