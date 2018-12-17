//
//  ReservationDetailsCell.swift
//  Arheb
//
//  Created on 30/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ReservationDetailsCell: UITableViewCell {

    @IBOutlet var lblTitleName: UILabel!
    @IBOutlet var imghAccessory: UIImageView!
    @IBOutlet var lblDetails: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
