//
//  SettingsViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/20/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController {
    
    @IBOutlet weak var codeLbl: UILabel!
    
    var group: Group?
    
    override func viewDidLoad() {
        guard let group = group else {return}
        codeLbl.text = group.code
    }
  
    
    @IBAction func tappedDeleteGroup(sender : UIButton) {
        guard  let group = group else {return}
        
        if group.creator == User.current.username {
            let alert = UIAlertController(title: "Delete \(group.groupName)", message: "Are you sure you want to delete the group? This cannot be undone once you confirm.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                GroupService.deleteCurrentGroup(groupID: group.documentId) { (didDelete) in
                    if didDelete {
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
