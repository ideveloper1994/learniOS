//
//  FilterCell.swift
//  Arheb
//
//  Created on 07/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet var btnCheck: CheckBoxButton!
    @IBOutlet var lblAmenities: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
