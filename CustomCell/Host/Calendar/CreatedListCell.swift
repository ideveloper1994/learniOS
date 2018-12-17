//
//  CreatedListCell.swift
//  Arheb
//
//  Created on 6/2/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class CreatedListCell: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblSteps: UILabel!
    @IBOutlet var imgRoomView: UIImageView!
    @IBOutlet var lblTickMark: UILabel!
    
    func setRoomDatas(modelListing: ListingModel)
    {
        if (modelListing.room_name as String).characters.count > 0
        {
            lblName?.text = modelListing.room_name as String
        }
        else
        {
            lblName?.text = String(format:"%@ in %@",modelListing.room_type,modelListing.room_location)
        }
        
        if modelListing.remaining_steps == "0"
        {
            lblSteps?.text = listed
            lblSteps?.textColor = UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }
        else
        {
// Esha commented            lblSteps?.attributedText = MakentSupport().makeHostAttributeTextColor(originalText: String(format:"%@ steps - %@",modelListing.remaining_steps,modelListing.room_type) as NSString, normalText: String(format:"- %@",modelListing.room_type) as NSString, attributeText: String(format:"%@ steps",modelListing.remaining_steps) as NSString, font: (lblSteps?.font)!)
        }
        
        if (modelListing.room_thumb_images.count) > 0
        {
            imgRoomView?.sd_setImage(with: NSURL(string: modelListing.room_thumb_images[0] as! String)! as URL, placeholderImage:UIImage(named:""))
        }
        else
        {
            imageView?.image = UIImage(named:"room_default_no_photos.png")
        }
        
    }
    
    

    
}
