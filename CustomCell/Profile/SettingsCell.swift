//
//  SettingsCell.swift
//  Arheb
//
//  Created on 6/1/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgOptions: UIImageView!
    @IBOutlet var lblRightTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
