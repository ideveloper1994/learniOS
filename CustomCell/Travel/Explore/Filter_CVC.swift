//
//  Filter_CVC.swift
//  Arheb
//
//  Created on 7/7/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class Filter_CVC: UICollectionViewCell {

    @IBOutlet var lblCantList: UILabel!
    @IBOutlet var btnRemoveFilter: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setCellInterface()
     }
    
    func setCellInterface() {
        self.lblCantList.text = cantList
        self.btnRemoveFilter.setTitle(removeFilters, for: .normal)
        btnRemoveFilter.layer.cornerRadius = 5
        btnRemoveFilter.layer.borderWidth = 1
        btnRemoveFilter.layer.borderColor = UIColor(red: 41/255, green: 152/255, blue: 134/255, alpha: 1).cgColor
        btnRemoveFilter.clipsToBounds = true
    }

}
