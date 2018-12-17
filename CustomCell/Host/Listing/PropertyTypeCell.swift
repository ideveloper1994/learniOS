//
//  PropertyTypeCell.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class PropertyTypeCell: UITableViewCell {

    @IBOutlet var ConstCellLeading: NSLayoutConstraint!
    @IBOutlet var imgDetail: UIImageView!
    @IBOutlet var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
