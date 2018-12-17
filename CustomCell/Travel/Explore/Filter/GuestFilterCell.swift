//
//  GuestFilterCell.swift
//  Arheb
//
//  Created on 6/16/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class GuestFilterCell: UITableViewCell {

    @IBOutlet var btnToggle: UIButton!
    @IBOutlet var Count: UIButton!
    @IBOutlet var viewSwitch: UIView!
    @IBOutlet var btnSwitch: UIButton!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnRemove: UIButton!
    @IBOutlet var lbDesc: UILabel!
    @IBOutlet var lbGeusetTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnAdd.layer.borderColor = UIColor.white.cgColor
        btnAdd.layer.borderWidth = 1
        btnAdd.layer.cornerRadius = btnAdd.frame.size.width/2
        btnRemove.layer.borderColor = UIColor.white.cgColor
        btnRemove.layer.borderWidth = 1
        btnRemove.layer.cornerRadius = btnAdd.frame.size.width/2
        
        btnSwitch.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0).cgColor
        btnSwitch.layer.borderWidth = 1.5
        btnSwitch.layer.cornerRadius = btnSwitch.frame.size.height/2
        
        viewSwitch.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0).cgColor
        viewSwitch.layer.borderWidth = 1.5
        viewSwitch.layer.cornerRadius = viewSwitch.frame.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
