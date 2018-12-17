//
//  HostListingCell.swift
//  Arheb
//
//  Created on 5/31/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class HostListingCell: UITableViewCell {
    @IBOutlet var lblRemainingSteps: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgRoomThumb: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK:- Custom Method(s)
    
    func setRoomDatas(modelListing: ListingModel) {
        if (modelListing.room_title as String).characters.count > 0 {
            lblName?.text = modelListing.room_title as String
        } else {
            lblName?.text = String(format:"%@ in %@",modelListing.room_name,((modelListing.city_name as String).characters.count > 0) ? modelListing.city_name : modelListing.room_location)
        }
        if modelListing.remaining_steps == "0" {
            lblRemainingSteps?.text = modelListing.isListEnabled == "Yes" ? listed : unlisted
            lblRemainingSteps?.textColor = UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        } else {
            lblRemainingSteps?.attributedText = makeHostAttributeTextColor(originalText: String(format:"%@ steps to list - %@",modelListing.remaining_steps,modelListing.room_name) as NSString, normalText: String(format:" - %@",modelListing.room_name) as NSString, attributeText: String(format:"%@ steps to list",modelListing.remaining_steps) as NSString, font: (lblRemainingSteps?.font)!)
        }
        if (modelListing.room_thumb_images.count) > 0 {
            imgRoomThumb?.sd_setImage(with: NSURL(string: modelListing.room_thumb_images[0] as! String)! as URL, placeholderImage:UIImage(named:"room_default_no_photos.png"))
        } else {
            imgRoomThumb?.image = UIImage(named:"room_default_no_photos.png")
        }
    }
    
}
