//
//  Extensions.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import FirebaseFirestore

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

extension JSONDecoder {
    func decode<T>(_ type: T.Type, fromJSONObject object: Any) throws -> T where T: Decodable {
        return try decode(T.self, from: try JSONSerialization.data(withJSONObject: object, options: []))
    }
}

extension UITextField {
    
    func loginTextfieldStyle() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 13.0
        self.layer.borderColor = UIColor.init(red: 82/255, green: 214/255, blue: 255/255, alpha: 1.0).cgColor
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addMinusToolBar(view : UIView) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        let minusButton = UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(toggleMinus))
        toolbar.items = [minusButton]
        self.inputAccessoryView = toolbar
    }
    
    @objc func toggleMinus(){
        if var text = self.text , text.isEmpty == false{
            if text.hasPrefix("-") {
                text = text.replacingOccurrences(of: "-", with: "")
            }
            else
            {
                text = "-\(text)"
            }
            self.text = text
        }
    }
    
    func addPlusToolBar(view : UIView) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        let plusButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(togglePlus))
        toolbar.items = [plusButton]
        self.inputAccessoryView = toolbar
    }
    
    @objc func togglePlus(){
        if var text = self.text , text.isEmpty == false{
            if text.hasPrefix("+") {
                text = text.replacingOccurrences(of: "+", with: "")
            }
            else
            {
                text = "+\(text)"
            }
            self.text = text
        }
    }
    
}

extension Int {
    func isSingular() -> String {
        if self == 1 {
            return "\(self) Active Member"
        } else {
            return "\(self) Active Members"
        }
    }
}

extension DocumentSnapshot {

    func prepareForDecoding() -> [String: Any] {
        guard var data = self.data() else {return [:]}
        data["documentId"] = self.documentID

        return data
    }

}
