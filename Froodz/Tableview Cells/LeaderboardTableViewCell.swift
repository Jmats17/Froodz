//
//  LeaderboardTableViewCell.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/18/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCellData(name: String, num: Int, points: Double ) {
        let isInteger = points.truncatingRemainder(dividingBy: 1) == 0
        self.nameLbl.text = "\(num + 1). \(name.uppercased())"

        if isInteger {
            self.pointsLbl.text = "\(Int(points))"
        } else {
            self.pointsLbl.text = "\(points)"
        }
    }

}
