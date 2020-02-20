//
//  LineViewController.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/19/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit
import Haptica

class LineViewController: UIViewController {

    @IBOutlet weak var lineNameLbl: UILabel!
    @IBOutlet weak var numMembersLbl: UILabel!
    @IBOutlet weak var wagerLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var singleButton: UIButton!
    @IBOutlet weak var doubleDownButton: UIButton! {
        didSet {
            doubleDownButton.layer.borderColor =
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
        segmentedControl.setTitle("Single - \(line.single.count)", forSegmentAt: 0)
        segmentedControl.setTitle("Double Down - \(line.doubleDown.count)", forSegmentAt: 1)
    }
    
    private func setButtonAttributes() {
        guard let line = line else {return}
        let isInteger = line.numOnLine.truncatingRemainder(dividingBy: 1) == 0

        if isInteger {
            self.wagerLbl.text = "\(Int(line.numOnLine)) Wager"
            self.singleButton.setTitle("\(Int(line.numOnLine))", for: .normal)
        } else {
            self.wagerLbl.text = "\(line.numOnLine) Wager"
            self.singleButton.setTitle("\(line.numOnLine)", for: .normal)
        }
        
        if line.doubleDown.contains(user.username) ||
            line.single.contains(user.username) {
            buttonDeactivated()
        } else { buttonActivated() }
        
        endButton_IsEnabled(line: line)
        
    }
    
    private func getLinePercentFilled(line: Line) -> Double {
        return Double(line.single.count + line.doubleDown.count)
        / Double(line.users.count)
    }
    
    private func endButton_IsEnabled(line: Line) {
        if line.creator != user.username {
            endButton.isHidden = true
        } else {
            print(getLinePercentFilled(line: line))
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
        self.singleButton.backgroundColor = Constants.Color.primaryBlue
        self.doubleDownButton.layer.borderColor = Constants.Color.primaryBlue.cgColor
        self.doubleDownButton.setTitleColor(Constants.Color.primaryBlue, for: .normal)
    }
    
    private func buttonDeactivated() {
        self.singleButton.backgroundColor = Constants.Color.placeholderColor
        self.doubleDownButton.layer.borderColor = Constants.Color.placeholderColor.cgColor
        self.doubleDownButton.setTitleColor(Constants.Color.placeholderColor, for: .normal)
        self.singleButton.isEnabled = false
        self.doubleDownButton.isEnabled = false
    }
    
    
    func singleBetInitiated(completion: @escaping (Bool) -> Void) {
        guard let line = line, let id = line.documentId else {return}
        guard let group = group else {return}
        
        LineService.checkUserPlaceLineBet(groupID: group.documentId, lineID: id) { (didPlaceBet) in
            if !didPlaceBet {
                LineService.addUser_ToSingleBet(groupID: group.documentId, lineID: id)
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
                LineService.addUser_ToDoubleDown(groupID: group.documentId, lineID: id)
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
            GroupService.addPointsToWinners(line: lineID, group: group, singleAmount: line.numOnLine) { (didSucceed) in
                if didSucceed {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        let noAction = UIAlertAction(title: "Nope 👎", style: .default) { (action) in
            Haptic.impact(.light).generate()
            GroupService.deductPointsToLosers(line: lineID, group: group, singleAmount: line.numOnLine) { (didSucceed) in
                if didSucceed {
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
    
    @IBAction func didTapSingleBet(sender: UIButton) {
        Haptic.impact(.light).generate()
        singleBetInitiated { (didComplete) in
            if didComplete {
                self.buttonDeactivated()
                guard var line = self.line else {return}
                line.single.append(self.user.username)
                self.line = line
                self.endButton_IsEnabled(line: line)
                self.segmentedControl.setTitle("Single - \(line.single.count)", forSegmentAt: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func didTapDoubleDown(sender: UIButton) {
        Haptic.impact(.light).generate()
        doubleDownBetInitiated { (didComplete) in
            if didComplete {
                self.buttonDeactivated()
                guard var line = self.line else {return}
                line.doubleDown.append(self.user.username)
                self.line = line
                self.endButton_IsEnabled(line: line)
                self.segmentedControl.setTitle("Single - \(line.doubleDown.count)", forSegmentAt: 1)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func didTapSettings(sender: UIButton) {
        Haptic.impact(.light).generate()
    }

}
