//
//  ActiveGroupsViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit

class ActiveGroupsViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var joinGroupTextField : UITextField!
    @IBOutlet weak var createGroupButton: UIButton! {
        didSet {
            createGroupButton.layer.cornerRadius = 7.0
        }
    }
    
    var groups = [Group]()
    let user = User.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinGroupTextField.delegate = self
        endEditingTapRecgonizer()
        
        retrieveActiveGroups()
        
    }
    
    func retrieveActiveGroups() {
        UserGroups_Service.return_ActiveGroups(userID: user.documentId) { (groups) in
            self.groups = groups
            self.tableView.reloadData()
        }
    }
   
    private func endEditingTapRecgonizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @IBAction func tappedCreateGroup(sender : UIButton) {
        let alertVC = UIAlertController(title: "Create Group", message: "Please enter the name of the group", preferredStyle: .alert)
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "Wombats"
            textfield.autocapitalizationType = .words
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let groupName = (alertVC.textFields?[0].text) else { return }
            GroupService.didCreateNewGroup(userID: self.user.documentId, groupName: groupName) { (didRegister) in
                if didRegister {
                    print("Success")
                    self.retrieveActiveGroups()
                }
            }
        }
        alertVC.addAction(addAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

