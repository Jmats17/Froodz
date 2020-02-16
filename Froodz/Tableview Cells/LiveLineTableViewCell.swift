//
//  LiveLineTableViewCell.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit

protocol BetButtonDelegate {
    func minusButtonTapped(at indexPath : IndexPath)
    func plusButtonTapped(at indexPath : IndexPath)
    func lineCompletedTapped(at indexPath : IndexPath)
}

class LiveLineTableViewCell: UITableViewCell {

    @IBOutlet weak var liveLineNameLbl : UILabel!
    @IBOutlet weak var first_BetButton : UIButton!
    @IBOutlet weak var second_BetButton : UIButton!
    @IBOutlet weak var lineCompletedButton : UIButton! {
        didSet {
            lineCompletedButton.isHidden = true
        }
    }

    var indexPath : IndexPath!
    var delegate : BetButtonDelegate!
    let user = User.current
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showCompletedButton(line: Line) {
        if line.creator == user.documentId {
            self.lineCompletedButton.isHidden = false
        }
    }
    
    func setCellData(_ line: Line) {
        self.lineCompletedButton.isHidden = true
        self.liveLineNameLbl.text = line.lineName
        showCompletedButton(line: line)
        
        if line.type != "Coin Line" {
            let newNumOnLine = Double(line.numOnLine) + 0.5
            self.first_BetButton.setTitle("-\(newNumOnLine)", for: .normal)
            self.second_BetButton.setTitle("+\(newNumOnLine)", for: .normal)
        } else {
            guard let secondNum = line.optionalSecondLine else { return }
            self.first_BetButton.setTitle("-\(line.numOnLine)", for: .normal)
            self.second_BetButton.setTitle("+\(secondNum)", for: .normal)
        }
    }
    
    func betInitiated(line : Line, groupID: String, sideTapped: String) {
        guard let lineID = line.documentId else {return}
        LineService.checkUserPlaceLineBet(groupID: groupID, lineID: lineID, selectedLine: sideTapped) { (didPlaceBet) in
            if !didPlaceBet {
                LineService.addUser_ToLineSide(groupID: groupID, lineID: lineID, sideTapped: sideTapped)
            }
        }
    }
    
    @IBAction func firstBetButtonTapped(sender : UIButton) {
        self.delegate?.minusButtonTapped(at: indexPath)
    }
    
    @IBAction func secondBetButtonTapped(sender : UIButton) {
        self.delegate?.plusButtonTapped(at: indexPath)
    }

    @IBAction func lineCompletedTapped(sender : UIButton) {
        self.delegate?.lineCompletedTapped(at: indexPath)
    }
}
