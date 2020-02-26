//
//  LiveLineTableViewCell.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit

class LiveLineTableViewCell: UITableViewCell {

    @IBOutlet weak var liveLineNameLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.lightGray.cgColor

        self.layer.cornerRadius = 7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCellData(_ line: Line) {
        self.liveLineNameLbl.attributedText = makeAttributedString(title: "Created By \(line.creator.uppercased())", subtitle: line.lineName)
    }
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .semibold), NSAttributedString.Key.foregroundColor: Constants.Color.primaryBlackText]
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)

        titleString.append(subtitleString)

        return titleString
    }

}
