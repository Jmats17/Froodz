//
//  SelectedTableView-Ext.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Haptico

extension SelectedGroupViewController: UITableViewDelegate, UITableViewDataSource, BetButtonDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
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
        Haptico.shared().generate(.medium)
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
    
    private func returnDataForBet(indexPath: IndexPath) -> (cell: LiveLineTableViewCell,line: Line,id: String)? {
        let cell = tableView.cellForRow(at: indexPath) as! LiveLineTableViewCell
        let line = lines[indexPath.row]
        guard let groupID = group?.documentId else {return nil}
        
        return (cell, line, groupID)
    }
    
    func singleBetButtonTapped(at indexPath: IndexPath) {
        Haptico.shared().generate(.medium)
        guard let data = returnDataForBet(indexPath: indexPath) else {return}
        data.cell.singleBetInitiated(line: data.line, groupID: data.id)

    }
    
    func doubleDownButtonTapped(at indexPath: IndexPath) {
        Haptico.shared().generate(.medium)
        guard let data = returnDataForBet(indexPath: indexPath) else {return}
        data.cell.doubleDownBetInitiated(line: data.line, groupID: data.id)
    }
    
    func removeCell_ReloadGroup(line: Line, group: Group) {
        self.allLineData.removeAll(where: { $0.lineName == line.lineName })
        self.lines.removeAll(where: { $0.lineName == line.lineName })
        self.reloadGroup(groupID: group.documentId)
    }
    
    func lineCompletedTapped(at indexPath: IndexPath) {
        guard let group = group else {return }
        let line = lines[indexPath.row]
        guard let lineID = line.documentId else {return}
        let alertController = UIAlertController(title: "Did the bet hit?", message: "Select if the bet hit or not so we can reward the players!", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes it did 🤝", style: .default) { (action) in
            Haptico.shared().generate(.medium)
            GroupService.addPointsToWinners(line: lineID, group: group, singleAmount: line.numOnLine) { (didSucceed) in
                if didSucceed {
                    self.removeCell_ReloadGroup(line: line, group: group)
                }
            }
        }
        let noAction = UIAlertAction(title: "Nope 👎", style: .default) { (action) in
            Haptico.shared().generate(.medium)
            GroupService.deductPointsToLosers(line: lineID, group: group, singleAmount: line.numOnLine) { (didSucceed) in
                if didSucceed {
                    self.removeCell_ReloadGroup(line: line, group: group)
                }
            }

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    }
}
