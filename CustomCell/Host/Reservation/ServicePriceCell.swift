//
//  ServicePriceCell.swift
//  Arheb
//
//  Created on 6/1/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ServicePriceCell: UITableViewCell {

    @IBOutlet var lblNote: UILabel!
    @IBOutlet var lblServiceFee: UILabel!
    @IBOutlet weak var lblServicePrice:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblNote.text = serviceNote
        self.lblServiceFee.text = serviceFee
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
