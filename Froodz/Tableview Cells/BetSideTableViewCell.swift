//
//  BetSideTableViewCell.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/19/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

class BetSideTableViewCell:  UITableViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func awakeFromNib() {}
    
    func setCellData(username: String) {
        self.usernameLbl.text = username.uppercased()
    }
    
}
