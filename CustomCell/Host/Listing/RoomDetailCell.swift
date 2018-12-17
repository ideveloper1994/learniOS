//
//  RoomDetailCell.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class RoomDetailCell: UITableViewCell {

    @IBOutlet var ConstImgWidth: NSLayoutConstraint!
    @IBOutlet var imgCheckBox: UIImageView!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
