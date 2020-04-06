//
//  AlertView.swift
//  Froodz
//
//  Created by Justin Matsnev on 4/6/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import CleanyModal

struct AlertViewService {
    
    struct JoinGroup {
        static func join_ExistingGroup(user: User, viewController: UIViewController, completionHandler: @escaping (Bool) -> Void) {
            let alert = CleanyAlertViewController(
                title: "Join Group",
                message: "Enter the access code to join an existing group with your friends.")
            
            alert.addTextField { textField in
                textField.placeholder = "Code"
                textField.font = UIFont.systemFont(ofSize: 12)
                textField.autocorrectionType = .no
                textField.keyboardAppearance = .light
            }
            CleanyAlertConfig.getDefaultStyleSettings()
            alert.addAction(title: "Join Group", style: .default, handler: { action in
                let textField = alert.textFields![0]
                guard let code = textField.text, code != "" else {return}
                GroupService.didJoinExistingGroup(userID: user.documentId, code: code) { (didJoin, groupID) in
                    if didJoin {
                        guard let groupCode = groupID else {return}
                        PushNotificationService.sendPushNotification(to: groupCode, title: "\(user.fullName) joined!", body: "\(user.fullName) may now place and wager on group bets.")
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                       
                    }
                }
            })
            
            alert.addAction(title: "Cancel", style: .cancel)
            viewController.present(alert, animated: true, completion: nil)
        }
        
        static func showCodeError(viewController: UIViewController) {
            let alert = CleanyAlertViewController(
                title: "Error Joining Group",
                message: "Group not found. Check the code you're entering again or try another code.")

            alert.addAction(title: "OK", style: .default)
            alert.addAction(title: "Cancel", style: .cancel)
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

