//
//  CreateLineViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CodableFirebase

class CreateLineViewController: UIViewController {

    @IBOutlet weak var lineNameTextField : UITextView! {
        didSet {
            lineNameTextField.text = "Santa Clause not making to to my house before 7AM"
            lineNameTextField.font = UIFont.systemFont(ofSize: 22.0, weight: .regular)
            lineNameTextField.textColor = Constants.Color.placeholderColor
        }
    }
    @IBOutlet weak var betTypePickerView : UIPickerView!
    @IBOutlet weak var numberTextField : UITextField! {
        didSet {
            numberTextField.attributedPlaceholder = NSAttributedString(string: "3.5",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: Constants.Color.placeholderColor])
        }
    }
    @IBOutlet weak var createButton : UIButton! {
        didSet {
            createButton.layer.cornerRadius = 7.0
        }
    }
    
    var groupID : String?
    var pickerData = ["Odds", "Total", "Coin Line"]
    var pickerValue = "Odds"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endEditingTapRecgonizer()
        numberTextField.addPointFive_ToolBar(view: self.view)
    }
    
    func return_LineValues() -> (lineName : String, amount : Double, groupID : String, betType: String)? {
        if let lineName = lineNameTextField.text, lineName != "" {
            if let amountStr = numberTextField.text, amountStr != "" {
                if let amount = Double(amountStr) {
                    if let groupID = groupID {
                        return (lineName, amount, groupID, pickerValue)
                    }
                }
            }
        }
        return nil
    }
    
    private func endEditingTapRecgonizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func tappedCreate(sender : UIButton) {
        guard let lineValues = return_LineValues() else { return }
        LineService.pushNewLine_ToGroup(lineName: lineValues.lineName, amount: lineValues.amount, secondAmt: nil, groupID: lineValues.groupID, type: lineValues.betType) { (didComplete) in
            if didComplete {
                print("Success. Create alert for user here")
            }
        }
    }
}

