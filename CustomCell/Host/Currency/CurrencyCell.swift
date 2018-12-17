//
//  CurrencyCell.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet var txtCell: UITextField!
    @IBOutlet var imgCurrency: UIImageView!
    @IBOutlet var lblCurrency: UILabel!
    @IBOutlet var lblCurrencySign:UILabel!
    @IBOutlet var lblTickmark:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 6{
            textField.resignFirstResponder()
        }else{
            textField.becomeFirstResponder()
        }
        return true
    }
    
}
