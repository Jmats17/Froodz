//
//  SelectedGroupViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit

class SelectedGroupViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var groupNameLbl : UILabel!
    @IBOutlet weak var totalMembersLbl : UILabel!

    var group : Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkGroupValue()
    }
    
    private func checkGroupValue() {
        if let group = group {
            groupNameLbl.text = group.groupName
            totalMembersLbl.text = group.users.count.isSingular()
        } else {
            groupNameLbl.text = "No Group Found"
            totalMembersLbl.text = "0 Active Members"
        }
    }
    
    @IBAction func tappedCreateLine(sender : UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "CreateLineVC") as? CreateLineViewController {
            vc.groupID = group?.documentId
            self.present(vc, animated: true, completion: nil)
        }
    }
  

}
