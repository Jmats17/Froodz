//
//  LeaderboardViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/18/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var users : [String: Double]?
    var sortedUsers = [(key: String, value: Double)]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        if let users = self.users {
            DispatchQueue.main.async {
                self.sortedUsers = users.sorted { $0.1 > $1.1 }
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardTableViewCell
        let user = sortedUsers[indexPath.row]
        
        cell.setCellData(name: user.key, num: indexPath.row, points: user.value)
     
        return cell
    }
}


