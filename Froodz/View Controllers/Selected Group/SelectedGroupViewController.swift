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
    @IBOutlet weak var createLineButton: UIButton! {
        didSet {
            createLineButton.layer.cornerRadius = 7.0
        }
    }
    @IBOutlet weak var firstPlaceLbl : UILabel!
    @IBOutlet weak var secondPlaceLbl : UILabel!
    @IBOutlet weak var thirdPlaceLbl : UILabel!
    
    var group : Group?
    var allLineData = [Line]()
    var lines = [Line]()
    let user = User.current
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkGroupValue()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkGroupValue()
    }
    
    private func checkGroupValue() {
        if let group = group {
            groupNameLbl.text = group.groupName
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
    
    @IBAction func segmentDidChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.lines = self.allLineData
            self.tableView.reloadData()
        case 1:
            self.lines = self.lines.filter({ $0.creator == user.username })
            self.tableView.reloadData()
        default:
            self.lines = self.allLineData
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func didTapBack(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
