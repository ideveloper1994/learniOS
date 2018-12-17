//
//  ContactHostCell.swift
//  Arheb
//
//  Created on 13/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ContactHostCell: UITableViewCell {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var vwHolder: UIView!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
