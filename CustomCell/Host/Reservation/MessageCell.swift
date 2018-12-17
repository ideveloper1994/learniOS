//
//  MessageCell.swift
//  Arheb
//
//  Created by devloper65 on 6/2/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var vwSend:UIView!
    @IBOutlet weak var lblSend:UILabel!
    @IBOutlet weak var btnSender:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSender.layer.masksToBounds = true
        btnSender.layer.cornerRadius = 25
        self.selectionStyle = .none
    }
    
    func displayMessageText(convMesModel:ConversationMessageModel){
        btnSender.sd_setImage(with: NSURL(string:convMesModel.sender_thumb_image)! as URL, for: .normal)
        let replaced = convMesModel.sender_messages.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let strMessage = String(format:"%@  %@",replaced,convMesModel.sender_messages_dateTime)
        let str = convMesModel.sender_messages_dateTime
        lblSend?.attributedText =  addBoldText(fullString: strMessage as NSString, boldPartOfString: str as NSString, font: UIFont(name:AppFont.CIRCULAR_LIGHT, size: 16), boldFont: UIFont(name:AppFont.CIRCULAR_BOOK, size: 14))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
