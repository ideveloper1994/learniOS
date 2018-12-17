//
//  AddMessageVC.swift
//  Arheb
//
//  Created on 6/13/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

protocol AddMessageDelegate {
    func onMessageAdded(messsage:String)
}

class AddMessageVC: UIViewController {
    
    // MARK:- IBOutlet(s)

    @IBOutlet var btnAddMsg: UIButton!
    @IBOutlet var imgHostThumb: UIImageView!
    @IBOutlet var txtMessage: UITextView?
    
    var delegate: AddMessageDelegate?
    var strMessage : String = ""
    var urlHostImg : String = ""
    var strHostUserId : String = ""
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMessage?.text = strMessage
        imgHostThumb.layer.cornerRadius = imgHostThumb.frame.size.height/2
        imgHostThumb.clipsToBounds = true
        txtMessage?.becomeFirstResponder()
        txtMessage?.text = (strMessage.characters.count>0) ? strMessage : ""
        UITextView.appearance().tintColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
        imgHostThumb.sd_setImage(with: NSURL(string: urlHostImg)! as URL, placeholderImage:UIImage(named:""))
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func onAddMessageTapped(_ sender:UIButton!) {
        if (txtMessage?.text.characters.count)!>0 {
            let  userDefaults = UserDefaults.standard
            userDefaults.set(txtMessage?.text, forKey: "hostmessage")
            userDefaults.synchronize()
            delegate?.onMessageAdded(messsage: (txtMessage?.text)!)
            self.onBackTapped(nil)
        }
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK:- Memory Warning(s)

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
