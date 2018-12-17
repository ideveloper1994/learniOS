//
//  MoreCell.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {

    @IBOutlet var lblMore: UILabel!
    @IBOutlet var btnMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblMore.text = more
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
