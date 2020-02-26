//
//  SelectedGroupViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit
import Haptica

class SelectedGroupViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var groupNameLbl : UILabel!
    @IBOutlet weak var totalMembersLbl : UILabel!
    @IBOutlet weak var numOfUsersCoinsLbl: UILabel!
    @IBOutlet weak var segmentedView: UISegmentedControl!
    @IBOutlet weak var createLineButton: UIButton! {
        didSet {
            createLineButton.layer.cornerRadius = 7.0
        }
    }
    @IBOutlet weak var rankingView: UIView! {
        didSet {
            rankingView.layer.cornerRadius = 7.0
        }
    }
    @IBOutlet weak var settingsButton: UIButton!
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
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 99
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapLeaderboard(_:)))
        rankingView.addGestureRecognizer(tap)
        
        checkGroupValue()
        didUpdate_TopLeaderboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkGroupValue()
        didUpdate_TopLeaderboard()
    }
    
    func didUpdate_TopLeaderboard() {
        guard let users = group?.leaderboard else {return}
        DispatchQueue.main.async {
            let topUsers = users.sorted(by: { $0.value > $1.value })
            
            switch topUsers.count {
            case 1:
                self.firstPlaceLbl.text =
                    self.returnTopUserText(user: topUsers[0].key, num: topUsers[0].value)
                self.secondPlaceLbl.text = "(Insert your name here 🙂)"
                self.thirdPlaceLbl.text = "(Or maybe here 🧐)"
            case 2:
                self.firstPlaceLbl.text =
                    self.returnTopUserText(user: topUsers[0].key, num: topUsers[0].value)
                self.secondPlaceLbl.text =
                    self.returnTopUserText(user: topUsers[1].key, num: topUsers[1].value)
                self.thirdPlaceLbl.text = "(Insert your name here 🙂)"
            default:
                self.firstPlaceLbl.text =
                    self.returnTopUserText(user: topUsers[0].key, num: topUsers[0].value)
                self.secondPlaceLbl.text =
                    self.returnTopUserText(user: topUsers[1].key, num: topUsers[1].value)
                self.thirdPlaceLbl.text =
                    self.returnTopUserText(user: topUsers[2].key, num: topUsers[2].value)
            }
        }
    }
    
    private func returnTopUserText(user: String, num: Double) -> String {
        "\(user.uppercased()) — \(num.isEndingPointZero())"
    }
    
    func reloadGroup(groupID: String) {
        GroupService.didReturn_RequestedGroup(groupID: groupID) { (group) in
            self.group = group
            DispatchQueue.main.async {
                self.checkGroupValue()
                self.didUpdate_TopLeaderboard()
                self.tableView.reloadData()
            }
        }
    }
    
    func filtered_NewLines(lines: [Line]) -> [Line] {
        return lines.filter({ !$0.agreedUsers.contains(User.current.username)
        && !$0.disagreedUsers.contains(User.current.username)})
    }
    
    func filtered_CreatedLines(lines: [Line]) -> [Line] {
        return lines.filter({ $0.creator == user.username })
    }
    
    private func filtered_PlacedLines(lines: [Line]) -> [Line] {
        return lines.filter({ $0.agreedUsers.contains(User.current.username)
        || $0.disagreedUsers.contains(User.current.username)})
    }
    
    private func next_FilledLines(lines: [Line]) -> ([Line], Int) {
        if !filtered_NewLines(lines: lines).isEmpty {
            return (filtered_NewLines(lines: lines), 0)
        }
        if !filtered_CreatedLines(lines: lines).isEmpty {
            return (filtered_CreatedLines(lines: lines), 1)
        }
        if !filtered_PlacedLines(lines: lines).isEmpty {
            return (filtered_PlacedLines(lines: lines), 2)
        }
        
        return (filtered_NewLines(lines: lines), 0)
    }
    
    private func checkGroupValue() {
        if let group = group {
            groupNameLbl.text = group.groupName
            totalMembersLbl.text = group.users.count.isSingular()
            numOfUsersCoinsLbl.text = "\(UserService.returnUsersBalance_FromGroup(group: group).isEndingPointZero())"
            if group.creator != user.username { settingsButton.isHidden = true }
            
            LineService.get_CurrentLines(groupID: group.documentId) { (lines) in
                DispatchQueue.main.async {
                    self.lines = self.next_FilledLines(lines: lines).0
                    self.segmentedView.selectedSegmentIndex =
                        self.next_FilledLines(lines: lines).1
                    self.allLineData = lines
                    self.tableView.reloadData()
                }
            }
        } else {
            groupNameLbl.text = "No Group Found"
            totalMembersLbl.text = "0 Active Members"
        }
    }

    
    @objc func didTapLeaderboard(_ sender: UITapGestureRecognizer? = nil) {
        Haptic.impact(.medium).generate()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "LeaderboardVC") as? LeaderboardViewController {
            vc.users = group?.leaderboard
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedCreateLine(sender : UIButton) {
        Haptic.impact(.light).generate()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "CreateLineVC") as? CreateLineViewController {
            vc.group = group
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func tappedSettings(sender: UIButton) {
        Haptic.impact(.light).generate()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "SettingsVC") as? SettingsViewController {
            vc.group = group
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func segmentDidChange(sender: UISegmentedControl) {
        Haptic.impact(.light).generate()
        self.lines = self.allLineData
        switch sender.selectedSegmentIndex {
        case 0:
            self.lines = filtered_NewLines(lines: lines)
            self.tableView.reloadData()
        case 1:
            self.lines = filtered_CreatedLines(lines: lines)
            self.tableView.reloadData()
        case 2:
            self.lines = filtered_PlacedLines(lines: lines)
            self.tableView.reloadData()
        default:
            self.lines = self.allLineData
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func didTapBack(sender: UIButton) {
        Haptic.impact(.light).generate()
        self.dismiss(animated: true, completion: nil)
    }
}
