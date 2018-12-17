//
//  MessageReciever.swift
//  Arheb
//
//  Created by devloper65 on 6/3/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class MessageReciever: UITableViewCell {
    
    @IBOutlet weak var vwRecieved:UIView!
    @IBOutlet weak var lblRecieved:UILabel!
    @IBOutlet weak var btnReciever:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnReciever.layer.masksToBounds = true
        btnReciever.layer.cornerRadius = 25
    }
    
    func displayMessageText(convMesModel:ConversationMessageModel){
        btnReciever.sd_setImage(with: NSURL(string:convMesModel.receiver_thumb_image)! as URL, for: .normal)
        let replaced = convMesModel.receiver_messages.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let str = convMesModel.receiver_messages_dateTime
        let strMessage = String(format:"%@  %@",replaced,convMesModel.receiver_messages_dateTime)
        lblRecieved?.attributedText =  addBoldText(fullString: strMessage as NSString, boldPartOfString: str as NSString, font: UIFont(name:AppFont.CIRCULAR_LIGHT, size: 16), boldFont: UIFont(name:AppFont.CIRCULAR_BOOK, size: 14))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
