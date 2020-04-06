//
//  ActiveGroupsViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit
import Haptica

class ActiveGroupsViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView! {
        didSet {
            if #available(iOS 10.0, *) {
                tableView.refreshControl = refreshControl
            } else {
                tableView.addSubview(refreshControl)
            }
        }
    }
    @IBOutlet weak var createGroupButton: UIButton! {
        didSet {
            createGroupButton.layer.borderColor = Constants.Color.primaryBlue.cgColor
        }
    }
    @IBOutlet weak var joinGroupButton: UIButton!
    @IBOutlet weak var groupLbl : UILabel! {
        didSet {
            groupLbl.text = "My Groups"
        }
    }
    
    var groups = [Group]()
    let user = User.current
    let refreshControl = UIRefreshControl()
    var activityIndicator = UIActivityIndicatorView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshGroupData(_:)), for: .valueChanged)
        startAnimatingIndicator()
        retrieveActiveGroups()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        retrieveActiveGroups()
    }
    
    private func startAnimatingIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    @objc func refreshGroupData(_ sender: Any) {
        startAnimatingIndicator()
        retrieveActiveGroups()
    }
    
    func retrieveActiveGroups() {
        UserGroups_Service.retrieveGroups_FromGroupsArr(userID: user.documentId) { (groups) in
             DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                self.groups = groups
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func tappedJoinGroup(sender: UIButton) {
        AlertViewService.JoinGroup.join_ExistingGroup(user: user, viewController: self) { (didJoin) in
            if (didJoin) {
                self.refreshGroupData(self)
            } else {
                AlertViewService.JoinGroup.showCodeError(viewController: self)
            }
        }
    }

}

