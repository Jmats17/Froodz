//
//  Extensions.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import FirebaseFirestore

//Self sizing tableviews for scrolling and content
class SelfSizedTableView: UITableView {
     override var intrinsicContentSize: CGSize {
       self.layoutIfNeeded()
       return self.contentSize
   }

   override var contentSize: CGSize {
       didSet{
           self.invalidateIntrinsicContentSize()
       }
   }

   override func reloadData() {
       super.reloadData()
       self.invalidateIntrinsicContentSize()
   }
}

extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
}

extension UITextField {
    
    //For the login textfield, set a style
    func loginTextfieldStyle() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 13.0
        self.layer.borderColor = UIColor.init(red: 82/255, green: 214/255, blue: 255/255, alpha: 1.0).cgColor
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
            target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}

//Returns singular or plural for number of users
extension Int {
    func isSingular() -> String {
        if self == 1 {
            return "\(self) Member"
        } else {
            return "\(self) Members"
        }
    }

}

extension Double {
    func isEndingPointZero() -> String {
        let isInteger = self.truncatingRemainder(dividingBy: 1) == 0

        if isInteger {
            return "\(Int(self))"
        } else {
            return "\(self)"
        }
    }
}

//Add Document ID to the data before turning into object
extension DocumentSnapshot {

    func prepareForDecoding() -> [String: Any] {
        guard var data = self.data() else {return [:]}
        data["documentId"] = self.documentID

        return data
    }

}
