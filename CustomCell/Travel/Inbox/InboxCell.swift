//
//  InboxCell.swift
//  Arheb
//
//  Created by devloper65 on 6/9/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class InboxCell: UITableViewCell {
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblMessage:UILabel!
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblLocation:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(objInbox:InboxModel){
        lblName.text = objInbox.host_user_name
        let strCurrency = GETVALUE(USER_CURRENCY_SYMBOL)
        lblPrice.text = strCurrency + objInbox.total_cost
        imgProfile.sd_setImage(with: URL(string: objInbox.host_thumb_image))
        lblLocation.text = objInbox.room_location
        lblMessage.text = objInbox.last_message
        lblDate.text = objInbox.check_in_time + " - " + objInbox.check_out_time
        if objInbox.is_message_read == "YES"{
            self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        }else{
            self.backgroundColor = UIColor.white
        }
        lblStatus.text = objInbox.message_status
        if objInbox.message_status == "Cancelled" || objInbox.message_status == "Declined"
        {
            lblStatus?.textColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
        }
        else if objInbox.message_status == "Accepted"
        {
            lblStatus?.textColor = UIColor(red: 63.0 / 255.0, green: 179.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
        }
        else if objInbox.message_status == "Pre-Accepted" || objInbox.message_status == "Inquiry" || objInbox.message_status == "Expired"
        {
            lblStatus?.textColor = UIColor.darkGray
        }
        else if objInbox.message_status == "Pending"
        {
            lblStatus?.textColor = UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }

    }
    
}
