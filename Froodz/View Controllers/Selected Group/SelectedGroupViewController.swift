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
    var allLineData = [Line]()
    var lines = [Line]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkGroupValue()
    }
    
    private func checkGroupValue() {
        if let group = group {
            groupNameLbl.text = group.groupName
            print(group)
            totalMembersLbl.text = group.users.count.isSingular()
            LineService.retrieve_CurrentLines(groupID: group.documentId) { (lines) in
                self.lines = lines
                self.allLineData = lines
                self.tableView.reloadData()
            }
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
  
    @IBAction func tappedUsersExistingLines(sender: UIButton) {
        self.lines = self.lines.filter({ $0.creator == UIDevice.current.identifierForVendor!.uuidString })
        self.tableView.reloadData()
    }
    
    @IBAction func tappedAllLines(sender: UIButton) {
        self.lines = self.allLineData
        self.tableView.reloadData()
    }
}
