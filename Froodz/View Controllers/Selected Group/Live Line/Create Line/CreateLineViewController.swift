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
import Haptica

class CreateLineViewController: UIViewController {

    @IBOutlet weak var lineNameTextField : UITextView! {
        didSet {
            lineNameTextField.text = "Santa Clause not making to to my house before 7AM"
            lineNameTextField.font = UIFont.systemFont(ofSize: 22.0, weight: .regular)
            lineNameTextField.textColor = Constants.Color.placeholderColor
        }
    }
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
    
    var group : Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endEditingTapRecgonizer()
    }
    
    func return_LineValues() -> (lineName : String, amount : Double, group : Group)? {
        if let lineName = lineNameTextField.text, lineName != "" {
            if let amountStr = numberTextField.text, amountStr != "" {
                if let amount = Double(amountStr) {
                    if let group = group {
                        return (lineName, amount, group)
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
        Haptic.impact(.light).generate()
        guard let lineValues = return_LineValues() else { return }
        LineService.pushNewLine_ToGroup(lineName: lineValues.lineName, amount: lineValues.amount, groupID: lineValues.group.documentId) { (didComplete) in
            if didComplete {
                PushNotificationService.sendPushNotification(to: lineValues.group.documentId, title: "New line in \(lineValues.group.groupName)👀" , body: "\(User.current.fullName) wants to shake on " + lineValues.lineName + " for " + "\(lineValues.amount.isEndingPointZero()) coins")
                self.dismiss(animated: true, completion: nil)
            } else {
                //present error view
            }
        }
    }
}

