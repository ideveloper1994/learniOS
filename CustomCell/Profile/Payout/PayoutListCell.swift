//
//  PayoutListCell.swift
//  Arheb
//
//  Created on 6/3/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class PayoutListCell: UITableViewCell {

    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblDefault: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblDefault.text = dfault
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
