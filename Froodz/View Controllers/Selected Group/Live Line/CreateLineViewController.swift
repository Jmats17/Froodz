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

    @IBOutlet weak var lineNameTextField : UITextField!
    @IBOutlet weak var betTypeSegmentControl : UISegmentedControl!
    @IBOutlet weak var first_SideTextField : UITextField!
    @IBOutlet weak var second_SideTextField : UITextField!
    
    var groupID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endEditingTapRecgonizer()
    }
    
    private func return_LineValues() -> (lineName : String, amount : Int, groupID : String, type: String)? {
        let index = betTypeSegmentControl.selectedSegmentIndex
        
        if let lineName = lineNameTextField.text, lineName != "" {
            if let amountStr = first_SideTextField.text, amountStr != "" {
                if let type = betTypeSegmentControl.titleForSegment(at: index) {
                    if let amount = Int(amountStr) {
                        if let groupID = groupID {
                            return (lineName, amount, groupID, type)
                        }
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

        LineService.pushNewLine_ToGroup(lineName: lineValues.lineName, amount: lineValues.amount, groupID: lineValues.groupID, type: lineValues.type) { (didComplete) in
            if didComplete {
                print("Success. Create alert for user here")
            }
        }
    }

}
