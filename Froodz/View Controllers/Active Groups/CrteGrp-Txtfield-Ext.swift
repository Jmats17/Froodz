//
//  CreateGroup-Txtfield-Ext.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/26/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Haptica

extension CreateGroupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Haptic.impact(.light).generate()
        if groupNameTextfield.isFirstResponder {
            amountTextfield.becomeFirstResponder()
        } else {
            amountTextfield.resignFirstResponder()
        }
        return true
    }

}
