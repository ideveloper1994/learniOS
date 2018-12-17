//
//  RatingDetailCell.swift
//  Arheb
//
//  Created on 6/14/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class RatingDetailCell: UITableViewCell {
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblReviewDate: UILabel!
    @IBOutlet var lblReviewDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
