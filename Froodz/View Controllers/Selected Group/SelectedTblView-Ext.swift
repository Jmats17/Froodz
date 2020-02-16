//
//  SelectedTableView-Ext.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

extension SelectedGroupViewController: UITableViewDelegate, UITableViewDataSource, BetButtonDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveLineCell", for: indexPath) as! LiveLineTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        let line = lines[indexPath.row]
        cell.setCellData(line)
        
        return cell
    }
    
    func minusButtonTapped(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LiveLineTableViewCell
        let line = lines[indexPath.row]
        guard let groupID = group?.documentId else {return}
        
        cell.betInitiated(line: line, groupID: groupID, sideTapped: "Minus")
        guard let lineID = line.documentId else {return}

    }
    
    func plusButtonTapped(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LiveLineTableViewCell
        let line = lines[indexPath.row]
        guard let groupID = group?.documentId else {return}
        guard let lineID = line.documentId else {return}

        cell.betInitiated(line: line, groupID: groupID, sideTapped: "Plus")

    }
    
    func lineCompletedTapped(at indexPath: IndexPath) {
        //TODO If line completed, delete or store in past lines history?
        //Assign points to users on side that won
        //Figure out how to store map between user and points
        
        
    }
}
