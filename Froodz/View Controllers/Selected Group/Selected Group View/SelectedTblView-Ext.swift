//
//  SelectedTableView-Ext.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Haptica

extension SelectedGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LiveLineTableViewCell
        Haptic.impact(.light).generate()

        let line = lines[indexPath.row]
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "LineViewVC") as? LineViewController {
            vc.group = group
            vc.line = line
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveLineCell", for: indexPath) as! LiveLineTableViewCell
        let line = lines[indexPath.row]
        cell.setCellData(line)

        return cell
    }
//    
//    private func returnDataForBet(indexPath: IndexPath) -> (cell: LiveLineTableViewCell,line: Line,id: String)? {
//        if segmentedView.selectedSegmentIndex == 1 || segmentedView.selectedSegmentIndex == 2 {
//            Haptic.impact(.light).generate()
//        }
//        let cell = tableView.cellForRow(at: indexPath) as! LiveLineTableViewCell
//        let line = lines[indexPath.row]
//        guard let groupID = group?.documentId else {return nil}
//
//        return (cell, line, groupID)
//    }

}
