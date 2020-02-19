//
//  LiveLineTableViewCell.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit

protocol BetButtonDelegate {
    func singleBetButtonTapped(at indexPath : IndexPath)
    func doubleDownButtonTapped(at indexPath : IndexPath)
}

class LiveLineTableViewCell: UITableViewCell {

    @IBOutlet weak var createdLbl : UILabel!
    @IBOutlet weak var liveLineNameLbl : UILabel!
    @IBOutlet weak var single_BetButton : UIButton! {
        didSet {
            single_BetButton.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet weak var doubleDown_BetButton : UIButton! {
        didSet {
            doubleDown_BetButton.layer.cornerRadius = 4.0
            doubleDown_BetButton.layer.borderWidth = 1.0
            doubleDown_BetButton.layer.borderColor = UIColor(red: 55/255, green: 135/255, blue: 191/255, alpha: 1.0).cgColor
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
    
    func setCellData(_ line: Line) {
        self.liveLineNameLbl.text = line.lineName
        self.createdLbl.text = "@\(line.creator.uppercased())"
        let isInteger = line.numOnLine.truncatingRemainder(dividingBy: 1) == 0

        if isInteger {
            self.single_BetButton.setTitle("\(Int(line.numOnLine))", for: .normal)
        } else {
            self.single_BetButton.setTitle("\(line.numOnLine)", for: .normal)
        }
    }
    
    func singleBetInitiated(line : Line, groupID: String) {
        guard let lineID = line.documentId else {return}
        LineService.checkUserPlaceLineBet(groupID: groupID, lineID: lineID) { (didPlaceBet) in
            if !didPlaceBet {
                LineService.addUser_ToSingleBet(groupID: groupID, lineID: lineID)
            }
        }
    }
    
    func doubleDownBetInitiated(line : Line, groupID: String) {
        guard let lineID = line.documentId else {return}
        LineService.checkUserPlaceLineBet(groupID: groupID, lineID: lineID) { (didPlaceBet) in
            if !didPlaceBet {
                LineService.addUser_ToDoubleDown(groupID: groupID, lineID: lineID)
            }
        }
    }
    
    @IBAction func singleBetButtonTapped(sender : UIButton) {
        self.delegate?.singleBetButtonTapped(at: indexPath)
    }
    
    @IBAction func DoubleDownButtonTapped(sender : UIButton) {
        self.delegate?.doubleDownButtonTapped(at: indexPath)
    }

}
