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
    
    @IBOutlet weak var second_SideLbl : UILabel!
    @IBOutlet weak var first_SideLbl : UILabel!

    var groupID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endEditingTapRecgonizer()
        betTypeSegmentControl.addTarget(self, action: #selector(CreateLineViewController.selectedSegmentControl(_:)), for:.valueChanged)
    }
    
    @objc
    func selectedSegmentControl(_ sender: UISegmentedControl) {
        switch betTypeSegmentControl.selectedSegmentIndex {
        case 0:
            hideSecondChangeFirstText()
        case 1:
            hideSecondChangeFirstText()
        case 2:
            showSecondChangeFirstText()
        default:
            break
        }
    }
    
    func showSecondChangeFirstText() {
        first_SideLbl.text = "Moneyline (-)"
        second_SideLbl.isHidden = false
        second_SideTextField.isHidden = false
        first_SideTextField.text = ""
    }
    
    func hideSecondChangeFirstText() {
        first_SideTextField.text = ""
        first_SideLbl.text = "Number on Line (+ / -)"
        second_SideLbl.isHidden = true
        second_SideTextField.isHidden = true
    }
    
    func return_LineValues() -> (lineName : String, amount : Double, groupID : String, type: String)? {
        let index = betTypeSegmentControl.selectedSegmentIndex
        
        if let lineName = lineNameTextField.text, lineName != "" {
            if let amountStr = first_SideTextField.text, amountStr != "" {
                if let type = betTypeSegmentControl.titleForSegment(at: index) {
                    if let amount = Double(amountStr) {
                        if let groupID = groupID {
                            return (lineName, amount + 0.5, groupID, type)
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
        
        if betTypeSegmentControl.selectedSegmentIndex == 2 {
            guard let secondAmtStr = second_SideTextField.text, secondAmtStr != "" else {return }
            guard let secondAmt = Double(secondAmtStr) else {return}
            LineService.pushNewLine_ToGroup(lineName: lineValues.lineName, amount: lineValues.amount, secondAmt: secondAmt, groupID: lineValues.groupID, type: lineValues.type) { (didComplete) in
                if didComplete {
                    print("Success. Create alert for user here")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            LineService.pushNewLine_ToGroup(lineName: lineValues.lineName, amount: lineValues.amount, secondAmt: nil, groupID: lineValues.groupID, type: lineValues.type) { (didComplete) in
                if didComplete {
                    print("Success. Create alert for user here")
                }
            }
        }
        
    }

}
