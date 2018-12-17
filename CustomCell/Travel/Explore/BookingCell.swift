//
//  BookingCell.swift
//  Arheb
//
//  Created on 6/13/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class BookingCell: UITableViewCell {

    @IBOutlet weak var lblNightCount:UILabel!
    @IBOutlet weak var lblGuestCount:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblPaymentType:UILabel!
    @IBOutlet weak var lblCheckInDate: UILabel!
    @IBOutlet weak var lblCheckOutDate: UILabel!
    @IBOutlet weak var lblHost: UILabel!
    @IBOutlet weak var lblHouseRules: UILabel!
    @IBOutlet weak var btnGuest:UIButton!
    @IBOutlet weak var btnPrice:UIButton!
    @IBOutlet weak var btnNight:UIButton!
    @IBOutlet weak var btnWeek:UIButton!
    @IBOutlet weak var btnPayment:UIButton!
    @IBOutlet weak var btnMessage:UIButton!
    @IBOutlet weak var btnHouseRule:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnNight.setTitle(nights, for: .normal)
        btnGuest.setTitle(guests, for: .normal)
        let paymentTitle = "1."+payment
        btnPayment.setTitle(paymentTitle, for: .normal)
        let messageTitle = "2."+hostMessage
        btnMessage.setTitle(messageTitle, for: .normal)
        let houseRulesTitle = "2."+house_rules
        btnHouseRule.setTitle(houseRulesTitle, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPaymentDetail(objPayment:PrePaymentModel){
        let startDate:String = GETVALUE("START_DATE")
        let endDate:String = GETVALUE("END_DATE")
        lblCheckInDate.text = startDate.isEmptyString() ? objPayment.start_date : startDate
        lblCheckOutDate.text = endDate.isEmptyString() ? objPayment.end_date : endDate
        
        lblNightCount.text = objPayment.nights_count
        lblPrice.attributedText =  attributedTextboldText(String(format:"%@%@ %@",objPayment.currency_code,(objPayment.currency_symbol).stringByDecodingHTMLEntities, objPayment.total_price) as NSString, boldText: String(format:"%@ %@",(objPayment.currency_symbol ).stringByDecodingHTMLEntities, objPayment.total_price) , fontSize: 22.0)
    }
    
}
