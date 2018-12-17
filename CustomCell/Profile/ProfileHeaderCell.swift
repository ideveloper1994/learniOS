//
//  ProfileHeaderCell.swift
//  Arheb
//
//  Created on 6/1/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

class ProfileHeaderCell: UITableViewCell {
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblInfoText: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var imgLoader: FLAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellInterface()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellInterface() {
        imgProfile.layer.cornerRadius = imgProfile.frame.width/2
        imgProfile.clipsToBounds = true
        lblInfoText.text = viewNedit
        setDotLoader(imgLoader!)
    }
    
}
