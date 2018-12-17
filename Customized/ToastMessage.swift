//
//  ToastMessage.swift
//  Arheb
//
//  Created on 6/10/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import Foundation
import UIKit

func showToastMessage(_ strMessage:String, isSuccess: Bool = false) {
    let lblMessage=UILabel(frame: CGRect(x: 0, y: (appDelegate?.window?.frame.size.height)!+70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70))
    lblMessage.tag = 500
    lblMessage.text = strMessage
    lblMessage.textColor = (isSuccess) ? UIColor.darkGray : UIColor.red
    lblMessage.backgroundColor = UIColor.white
    lblMessage.font = UIFont(name: AppFont.CIRCULAR_BOOK, size: CGFloat(15))
    lblMessage.textAlignment = NSTextAlignment.center
    lblMessage.numberOfLines = 0
    lblMessage.layer.shadowColor = UIColor.black.cgColor
    lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0)
    lblMessage.layer.shadowOpacity = 0.5
    lblMessage.layer.shadowRadius = 1.0
    moveLabelToYposition(lblMessage)
    UIApplication.shared.keyWindow?.addSubview(lblMessage)
}

func moveLabelToYposition(_ lblView:UILabel) {
    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
        lblView.frame = CGRect(x: 0, y: (appDelegate?.window?.frame.size.height)!-70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70)
    }, completion: { (finished: Bool) -> Void in
        onCloseAnimation(lblView)
    })
}

func onCloseAnimation(_ lblView:UILabel) {
    UIView.animate(withDuration: 0.3, delay: 3.5, options: UIViewAnimationOptions(), animations: { () -> Void in
        lblView.frame = CGRect(x: 0, y: (appDelegate?.window?.frame.size.height)!+70, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 70)
    }, completion: { (finished: Bool) -> Void in
        lblView.removeFromSuperview()
    })
}
