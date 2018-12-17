//
//  GuestTypeCell.swift
//  Arheb
//
//  Created by LaNet on 6/20/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class GuestTypeCell: UITableViewCell {

    @IBOutlet var imgCheckMark: UIImageView!
    @IBOutlet var lblGuestType: UILabel!
    @IBOutlet var imgCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCheckMark.setTintColor(color: UIColor.red)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
