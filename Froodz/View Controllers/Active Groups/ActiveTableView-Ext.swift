//
//  ActiveGroups-TableViewExtension.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

extension ActiveGroupsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 119
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "SelectedGroupVC") as? SelectedGroupViewController {
            vc.group = group
            vc.modalPresentationStyle = .fullScreen

            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
      
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveGroupCell", for: indexPath) as! ActiveGroupTableViewCell
        
        let group = groups[indexPath.row]
        cell.setCellDataWithGroup(group)
        
        return cell
    }
    
    
}

extension ActiveGroupsViewController: UITextFieldDelegate {
    
    func joinGroup() {
        guard let code = joinGroupTextField.text else { return }
        GroupService.didJoinExistingGroup(userID: user.documentId, code: code) { (didJoin) in
            if didJoin {
                self.joinGroupTextField.text = ""
            } else {
                self.codeNotFoundAlert()
            }
        }
    }
    
    private func codeNotFoundAlert() {
        let alert = UIAlertController(title: "Code Not Found", message: "Please try another code or check again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        joinGroup()
        textField.resignFirstResponder()
        return true
    }
}
