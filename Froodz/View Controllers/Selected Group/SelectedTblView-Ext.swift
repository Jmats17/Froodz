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
        guard let group = group else {return }
        let line = lines[indexPath.row]
        let alertController = UIAlertController(title: "Who's the winnner?", message: "Which side of the bet hit?", preferredStyle: .alert)
        if line.type != "Coin Line" {
            let minusAction = UIAlertAction(title: "-\(line.numOnLine)", style: .default) { (action) in
                GroupService.addPointsToWinners(line: line, lineWinners: line.under, group: group, amountToWinners: line.numOnLine, winningSide: "Minus") { (didSucceed) in
                    if didSucceed {
                        self.allLineData.removeAll(where: { $0.lineName == line.lineName })
                        self.lines.removeAll(where: { $0.lineName == line.lineName })
                        self.tableView.reloadData()
                    }
                }
            }
            let plusAction = UIAlertAction(title: "+\(line.numOnLine)", style: .default) { (action) in
                GroupService.addPointsToWinners(line: line, lineWinners: line.over, group: group, amountToWinners: line.numOnLine, winningSide: "Plus") { (didSucceed) in
                    if didSucceed {
                        self.allLineData.removeAll(where: { $0.lineName == line.lineName })
                        self.lines.removeAll(where: { $0.lineName == line.lineName })
                        self.tableView.reloadData()
                    }
                }
            }
            alertController.addAction(minusAction)
            alertController.addAction(plusAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            guard let secondLine = line.optionalSecondLine else {return}
            let minusAction = UIAlertAction(title: "-\(line.numOnLine)", style: .default) { (action) in
                
            }
            let plusAction = UIAlertAction(title: "+\(secondLine)", style: .default) { (action) in
                
            }
            alertController.addAction(minusAction)
            alertController.addAction(plusAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}
