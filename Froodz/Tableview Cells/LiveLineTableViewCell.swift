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
}

class LiveLineTableViewCell: UITableViewCell {

    @IBOutlet weak var createdLbl : UILabel!
    @IBOutlet weak var liveLineNameLbl : UILabel!
    @IBOutlet weak var first_BetButton : UIButton! {
        didSet {
            first_BetButton.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet weak var second_BetButton : UIButton! {
        didSet {
            second_BetButton.layer.cornerRadius = 4.0
            second_BetButton.layer.borderWidth = 1.0
            second_BetButton.layer.borderColor = UIColor(red: 55/255, green: 135/255, blue: 191/255, alpha: 1.0).cgColor
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
        self.createdLbl.text = "Created by: \(line.creator)"
        
        if line.type != "Coin Line" {
            let newNumOnLine = Double(line.numOnLine)
            self.first_BetButton.setTitle("-\(newNumOnLine)", for: .normal)
            self.second_BetButton.setTitle("+\(newNumOnLine)", for: .normal)
        } else {
            let newNumOnLine = Int(line.numOnLine)
            self.first_BetButton.setTitle("\(newNumOnLine)", for: .normal)
            self.second_BetButton.isHidden = true
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

}
