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
    
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserGroups_Service.return_ActiveGroups { (groups) in
            self.groups = groups
            self.tableView.reloadData()
        }
    }
   
    @IBAction func tappedJoinGroup(sender : UIButton) {
        let alertVC = UIAlertController(title: "Join Group", message: "Please enter the 6 digit code of the group you want to join.", preferredStyle: .alert)
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "aaAa1a"
        }
        let addAction = UIAlertAction(title: "Join", style: .default) { (action) in
            guard let code = (alertVC.textFields?[0].text) else { return }
            GroupService.didJoinExistingGroup(code: code) { (didJoin) in
                if didJoin {
                    print("Joined or is not apart")
                } else {
                    print("Existing already")
                }
            }

        }
        alertVC.addAction(addAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    @IBAction func tappedCreateGroup(sender : UIButton) {
        let alertVC = UIAlertController(title: "Create Group", message: "Please enter the name of the group", preferredStyle: .alert)
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "Wombats"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let groupName = (alertVC.textFields?[0].text) else { return }
            GroupService.didCreateNewGroup(groupName: groupName) { (didRegister) in
                if didRegister {
                    print("Success")
                }
            }
        }
        alertVC.addAction(addAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

