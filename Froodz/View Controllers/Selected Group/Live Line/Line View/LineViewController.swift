//
//  LineViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/19/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit
import Haptica
import FirebaseMessaging

class LineViewController: UIViewController {

    @IBOutlet weak var lineNameLbl: UILabel!
    @IBOutlet weak var numMembersLbl: UILabel!
    @IBOutlet weak var wagerLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var agreedButton: UIButton!
    @IBOutlet weak var disagreedButton: UIButton! {
        didSet {
            disagreedButton.layer.borderColor =
                Constants.Color.primaryBlue.cgColor
        }
    }
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

    var line: Line?
    var group: Group?
    let user = User.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAttributes()
        setLabelAttributes()
    }
    
    private func setLabelAttributes() {
        guard let line = line else {return}
        lineNameLbl.text = line.lineName
        numMembersLbl.text = "\(line.users.count.isSingular())"
        segmentedControl.setTitle("Agreed - \(line.agreedUsers.count)", forSegmentAt: 0)
        segmentedControl.setTitle("Disagreed - \(line.disagreedUsers.count)", forSegmentAt: 1)
    }
    
    private func setButtonAttributes() {
        guard let line = line else {return}
        let isInteger = line.numOnLine.truncatingRemainder(dividingBy: 1) == 0

        if isInteger {
            self.wagerLbl.text = "\(Int(line.numOnLine)) Wager"
        } else {
            self.wagerLbl.text = "\(line.numOnLine) Wager"
        }
        
        if line.disagreedUsers.contains(user.username) ||
            line.agreedUsers.contains(user.username) {
            buttonDeactivated()
        } else { buttonActivated() }
        
        endButton_IsEnabled(line: line)
        
    }
    
    private func getLinePercentFilled(line: Line) -> Double {
        guard let group = group else {return 0.0 }
        return Double(line.agreedUsers.count + line.disagreedUsers.count)
        / Double(group.users.count)
    }
    
    private func endButton_IsEnabled(line: Line) {
        if line.creator != user.username {
            endButton.isHidden = true
        } else {
            if getLinePercentFilled(line: line) < 0.8 {
                endButton.setTitle("\(Int(getLinePercentFilled(line: line) * 100.0))% Filled", for: .normal)
                endButton.setTitleColor(Constants.Color.primaryBlackText, for: .normal)
                endButton.isEnabled = false
            } else {
                endButton.setTitle("End The Line - \(Int(getLinePercentFilled(line: line) * 100.0))% Filled", for: .normal)
                endButton.setTitleColor(Constants.Color.tertiaryRed, for: .normal)
                endButton.isEnabled = true
            }
        }
    }
    
    private func buttonActivated() {
        self.agreedButton.backgroundColor = Constants.Color.primaryBlue
        self.disagreedButton.layer.borderColor = Constants.Color.primaryBlue.cgColor
        self.disagreedButton.setTitleColor(Constants.Color.primaryBlue, for: .normal)
    }
    
    private func buttonDeactivated() {
        self.agreedButton.backgroundColor = Constants.Color.placeholderColor
        self.disagreedButton.layer.borderColor = Constants.Color.placeholderColor.cgColor
        self.disagreedButton.setTitleColor(Constants.Color.placeholderColor, for: .normal)
        self.agreedButton.isEnabled = false
        self.disagreedButton.isEnabled = false
    }
    
    
    func singleBetInitiated(completion: @escaping (Bool) -> Void) {
        guard let line = line, let id = line.documentId else {return}
        guard let group = group else {return}
        
        LineService.checkUserPlaceLineBet(groupID: group.documentId, lineID: id) { (didPlaceBet) in
            if !didPlaceBet {
                LineService.addUser_ToAgreedBet(groupID: group.documentId, lineID: id)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func doubleDownBetInitiated(completion: @escaping (Bool) -> Void) {
        guard let line = line, let id = line.documentId else {return}
        guard let group = group else {return}
        
        LineService.checkUserPlaceLineBet(groupID: group.documentId, lineID: id) { (didPlaceBet) in
            if !didPlaceBet {
                LineService.addUser_ToDisagreedBet(groupID: group.documentId, lineID: id)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func lineCompletedTapped() {
        guard let group = group else {return}
        guard let line = line, let lineID = line.documentId else {return}
        let alertController = UIAlertController(title: "Did the bet hit?", message: "Select if the bet hit or not so we can reward the players!", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes it did 🤝", style: .default) { (action) in
            Haptic.impact(.light).generate()
            GroupService.distributePoints_ToUsers(winningSide: "Agreed", line: lineID, group: group, amount: line.numOnLine) { (didSucceed) in
                if didSucceed {
                    PushNotificationService.sendPushNotification(to: lineID + "Agreed", title: "You won \(line.numOnLine.isEndingPointZero()) Coins 💰", body: "You shook on \"\(line.lineName)\" and it hit!")
                    PushNotificationService.sendPushNotification(to: lineID + "Disagreed", title: "You lost \(line.numOnLine.isEndingPointZero()) Coins 😕", body: "You disagreed on \"\(line.lineName)\" and it hit.")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        let noAction = UIAlertAction(title: "Nah 👎", style: .default) { (action) in
            Haptic.impact(.light).generate()
            GroupService.distributePoints_ToUsers(winningSide: "Disagreed", line: lineID, group: group, amount: line.numOnLine) { (didSucceed) in
                if didSucceed {
                    PushNotificationService.sendPushNotification(to: lineID + "Agreed", title: "You lost \(line.numOnLine.isEndingPointZero()) Coins 😕", body: "You shook on \"\(line.lineName)\" and it didn't hit.")
                    PushNotificationService.sendPushNotification(to: lineID + "Disagreed", title: "You won \(line.numOnLine.isEndingPointZero()) Coins 💰", body: "You disagreed on \"\(line.lineName)\" and you were right!")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    }
  
    //IBACTIONS BELOW
    //Tap line to close, tap single bet or double, settings
    
    @IBAction func didSwitchSideControl(sender: UISegmentedControl) {
        Haptic.impact(.light).generate()
        self.tableView.reloadData()
    }
    
    @IBAction func didTapEndLine(sender: UIButton) {
        Haptic.impact(.light).generate()
        self.lineCompletedTapped()
    }
    
    @IBAction func didTapAgree(sender: UIButton) {
        Haptic.impact(.light).generate()
        singleBetInitiated { (didComplete) in
            if didComplete {
                self.buttonDeactivated()
                guard var line = self.line, let lineID = line.documentId else {return}
                PushNotificationService.subscribeToLine(line: lineID + "Agreed")
                line.agreedUsers.append(self.user.username)
                self.line = line
                self.endButton_IsEnabled(line: line)
                self.segmentedControl.setTitle("Agreed - \(line.agreedUsers.count)", forSegmentAt: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func didTapDisagree(sender: UIButton) {
        Haptic.impact(.light).generate()
        doubleDownBetInitiated { (didComplete) in
            if didComplete {
                self.buttonDeactivated()
                guard var line = self.line, let lineID = line.documentId else {return}
                PushNotificationService.subscribeToLine(line: lineID + "Disagreed")
                line.disagreedUsers.append(self.user.username)
                self.line = line
                self.endButton_IsEnabled(line: line)
                self.segmentedControl.setTitle("Disagreed - \(line.disagreedUsers.count)", forSegmentAt: 1)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func didTapSettings(sender: UIButton) {
        Haptic.impact(.light).generate()
    }

}
