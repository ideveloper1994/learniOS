//
//  CancelReservationCell.swift
//  Arheb
//
//  Created  on 6/1/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class CancelReservationCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSelected:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblSelected.layer.borderColor = UIColor.red.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
