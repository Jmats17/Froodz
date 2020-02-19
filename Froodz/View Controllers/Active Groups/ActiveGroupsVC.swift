//
//  ActiveGroupsViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit
import Haptico

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
    @IBOutlet weak var joinGroupTextField : UITextField! {
        didSet {
            joinGroupTextField.attributedPlaceholder = NSAttributedString(string: "6ixCde",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    @IBOutlet weak var createGroupButton: UIButton! {
        didSet {
            createGroupButton.layer.cornerRadius = 7.0
        }
    }
    @IBOutlet weak var groupLbl : UILabel! {
        didSet {
            groupLbl.text = "\(user.fullName)'s Groups"
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
        joinGroupTextField.delegate = self
        endEditingTapRecgonizer()
        
        refreshControl.addTarget(self, action: #selector(refreshGroupData(_:)), for: .valueChanged)
        startAnimatingIndicator()
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
    
    @objc private func refreshGroupData(_ sender: Any) {
        startAnimatingIndicator()
        retrieveActiveGroups()
    }
    
    func retrieveActiveGroups() {
        UserGroups_Service.return_ActiveGroups(userID: user.documentId) { (groups) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                self.groups = groups
                self.tableView.reloadData()
            }
        }
    }
   
    private func endEditingTapRecgonizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @IBAction func tappedCreateGroup(sender : UIButton) {
        Haptico.shared().generate(.medium)
        let alertVC = UIAlertController(title: "Create Group", message: "Please enter the name of the group", preferredStyle: .alert)
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "Wombats"
            textfield.autocapitalizationType = .words
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            Haptico.shared().generate(.medium)
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

