//
//  LoaderCollectionViewCell.swift
//  Arheb
//
//  Created on 6/7/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

class LoaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet var animatedLoader: FLAnimatedImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDotLoader(animatedLoader!)
    }

}
