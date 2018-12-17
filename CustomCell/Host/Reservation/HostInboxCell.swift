//
//  HostInboxCell.swift
//  Makent
//
//  Created on 30/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SDWebImage

class HostInboxCell: UITableViewCell {
    
    // MARK:- IBOutlets

    @IBOutlet var lblTripStatus: UILabel?
    @IBOutlet var lblUserName: UILabel?
    @IBOutlet var lblTripDate: UILabel?
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var lblLocation: UILabel?
    @IBOutlet var imgUserThumb: UIImageView?
    @IBOutlet var btnPreAccept: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnPreAccept?.setTitle(preAccept, for: .normal)
        self.lblTripStatus?.text = preAccept
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK:- Custom Method(s)
    
    func setReservationDetails(_ modelTrips: ReservationModel)
    {
        btnPreAccept?.isHidden = (modelTrips.trip_status == "Pending") ? false : true
        var rectLblView = lblLocation?.frame
        rectLblView?.size.width = self.frame.size.width - ((modelTrips.trip_status == "Pending") ? 120 : 40) - (lblLocation?.frame.origin.y)!
        lblLocation?.frame = rectLblView!
        
        btnPreAccept?.layer.cornerRadius = 3.0
        lblUserName?.text = modelTrips.guest_user_name as String
        lblDetails?.text = modelTrips.room_name as String
        lblTripDate?.text = modelTrips.trip_date.replacingOccurrences(of: "to", with: "-")
        lblLocation?.text = modelTrips.room_location as String
        imgUserThumb?.sd_setImage(with: URL(string: modelTrips.guest_thumb_image as String)!, placeholderImage:UIImage(named:""))
        lblTripStatus?.text = modelTrips.trip_status as String
        if modelTrips.trip_status == "Cancelled" || modelTrips.trip_status == "Declined" || modelTrips.trip_status == "Expired" {
            lblTripStatus?.textColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
        } else if modelTrips.trip_status == "Accepted" {
            lblTripStatus?.textColor = UIColor(red: 63.0 / 255.0, green: 179.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
        } else if modelTrips.trip_status == "Pre-Accepted" || modelTrips.trip_status == "Inquiry" {
            lblTripStatus?.textColor = UIColor.darkGray
        } else if modelTrips.trip_status == "Pending" {
            lblTripStatus?.textColor = UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }
    }

    
}
