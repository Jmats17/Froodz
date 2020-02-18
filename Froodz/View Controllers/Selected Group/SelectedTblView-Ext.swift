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
        return 148
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
  
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if lines[indexPath.row].creator == user.username {
            let endAction = UIContextualAction(style: .destructive, title: "End Line", handler: { (action, view, completionHandler) in
                self.lineCompletedTapped(at: indexPath)
                completionHandler(true)
            })
            endAction.backgroundColor = UIColor(red: 70/255, green: 141/244, blue: 242/255, alpha: 1.0)
            let configuration = UISwipeActionsConfiguration(actions: [endAction])
            return configuration
        } else {
            return nil
        }
    }
    
    func singleBetButtonTapped(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LiveLineTableViewCell
        let line = lines[indexPath.row]
        guard let groupID = group?.documentId else {return}
        
        cell.singleBetInitiated(line: line, groupID: groupID)

    }
    
    func doubleDownButtonTapped(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LiveLineTableViewCell
        let line = lines[indexPath.row]
        guard let groupID = group?.documentId else {return}

        cell.doubleDownBetInitiated(line: line, groupID: groupID)

    }
    
    func lineCompletedTapped(at indexPath: IndexPath) {
        guard let group = group else {return }
        let line = lines[indexPath.row]
        let alertController = UIAlertController(title: "Did the bet hit?", message: "Select if the bet hit or not so we can reward the players!", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes it did 🤝", style: .destructive) { (action) in
            GroupService.addPointsToWinners(line: line, singleWinners: line.single, doubleWinners: line.doubleDown, group: group, singleAmount: line.numOnLine) { (didSucceed) in
                if didSucceed {
                    self.allLineData.removeAll(where: { $0.lineName == line.lineName })
                    self.lines.removeAll(where: { $0.lineName == line.lineName })
                    self.tableView.reloadData()
                }
            }
        }
        
        let noAction = UIAlertAction(title: "Nope 👎", style: .destructive) { (action) in
            GroupService.deductPointsToLosers(line: line, singleLosers: line.single, doubleLosers: line.doubleDown, group: group, singleAmount: line.numOnLine) { (didSucceed) in
                if didSucceed {
                    self.allLineData.removeAll(where: { $0.lineName == line.lineName })
                    self.lines.removeAll(where: { $0.lineName == line.lineName })
                    self.tableView.reloadData()
                }
            }
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
                 
        self.present(alertController, animated: true, completion: nil)

    }
}
