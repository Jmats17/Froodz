//
//  LineTblView-Ext.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/19/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

extension LineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let line = line else {return 0}
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return line.single.count
        } else {
            return line.doubleDown.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BetSideCell", for: indexPath) as! BetSideTableViewCell
        guard let line = line else { return cell }
        var username = String()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            username = line.single[indexPath.row]
            cell.setCellData(username: username)
            return cell
        } else {
            username = line.single[indexPath.row]
            cell.setCellData(username: username)
            return cell
        }
    }
    
}
