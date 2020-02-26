//
//  CreateGroupViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/26/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit
import Haptica

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var createGroupButton: UIButton! {
        didSet {
            createGroupButton.layer.cornerRadius = 7.0
        }
    }
    @IBOutlet weak var groupNameTextfield: UITextField!
    @IBOutlet weak var amountTextfield: UITextField!
    let user = User.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextfield.addDoneButtonOnKeyboard()
    }
    
    private func codeNotFoundAlert() {
        let alert = UIAlertController(title: "Couldn't Create Group", message: "Make sure you created a group name and added initial starting amount.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedCreateGroup(sender: UIButton) {
        Haptic.impact(.light).generate()
        guard let groupName = (groupNameTextfield.text), groupName != "" else { codeNotFoundAlert() ; return }
        guard let amountStr = (amountTextfield.text), let amount = Double(amountStr) else { codeNotFoundAlert() ; return }
        GroupService.didCreateNewGroup(userID: self.user.documentId, groupName: groupName, amount: amount) { (didRegister) in
            if didRegister {
                print("Success")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tappedCancel(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
