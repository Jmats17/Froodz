//
//  ActiveGroupTableViewCell.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import UIKit

class ActiveGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLbl : UILabel!
    @IBOutlet weak var codeLbl : UILabel!
    @IBOutlet weak var userNumLbl : UILabel!
    @IBOutlet weak var contentCellView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // add shadow on cell
        contentCellView.layer.masksToBounds = false
        contentCellView.layer.shadowOpacity = 0.2
        contentCellView.layer.shadowRadius = 4
        contentCellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentCellView.layer.shadowColor = UIColor.lightGray.cgColor

        // add corner radius on `contentView`
        contentCellView.layer.cornerRadius = 7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellDataWithGroup(_ group : Group) {
        self.groupNameLbl.text = group.groupName.uppercased()
        self.codeLbl.text = group.code
        self.userNumLbl.text = group.users.count.isSingular()
    }

}
