//
//  ArhebErrorView.swift
//  Arheb
//
//  Created on 5/31/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ArhebErrorView: UIView {
    
    var lblError = UILabel()
    var lblStaticError = UILabel()
    var btnCancel = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lblStaticError.frame = CGRect(x: 10, y: self.frame.size.width/2, width: 30, height: 16)
        lblStaticError.text = "Error"
        lblStaticError.textColor = UIColor.red
        
        btnCancel.frame = CGRect(x: self.frame.size.width - 40, y: self.frame.size.width/2, width: 30, height: 30)
        btnCancel.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
