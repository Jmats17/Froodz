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
        // Initialization code
        // Initialization code
        // add shadow on cell
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.lightGray.cgColor

        // add corner radius on `contentView`
        self.layer.cornerRadius = 7
        // Configure the view for the selected state
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCellData(_ line: Line) {
        self.liveLineNameLbl.attributedText = makeAttributedString(title: line.lineName, subtitle: "@\(line.creator.uppercased())")
    }
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .semibold), NSAttributedString.Key.foregroundColor: Constants.Color.primaryBlackText]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.lightGray]

        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)

        titleString.append(subtitleString)

        return titleString
    }

}
