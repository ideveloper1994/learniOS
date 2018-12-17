//
//  ReservationHistoryCellTableViewCell.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ReservationHistoryCell: UITableViewCell {
    @IBOutlet var lblReceiverMessage: UILabel?
    @IBOutlet var imgReceiverThumb: UIButton?
    //    @IBOutlet var viewReceiverHolder: UIView?
    @IBOutlet var imgReceiverIndicator: UIImageView?
    
    @IBOutlet var lblSenderMessage: UILabel?
    @IBOutlet var imgSenderThumb: UIButton?
    //    @IBOutlet var viewSenderHolder: UIView?
    @IBOutlet var imgSenderIndicator: UIImageView?
    
    @IBOutlet weak var lblMessageStatus : UILabel!
    @IBOutlet weak var lblMessageTime : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
