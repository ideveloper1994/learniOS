//
//  PreAcceptVC.swift
//  Arheb
//
//  Created on 31/05/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class PreAcceptVC: UIViewController, UITextViewDelegate {
    
    // MARK: IBOutlet(s)
    
    @IBOutlet var lblOptionalMessage: UILabel!
    @IBOutlet var txtMessage : UITextView!
    @IBOutlet var lblTitle : UILabel?
    @IBOutlet var btnAccept : UIButton?
    
    var strSeletedReason : String = ""
    var strReservationId : String = ""
    var strRoomId : String = ""
    var strPageTitle : String = ""
    var arrCurrency = NSArray()
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle?.text = pre_accept_this_request
        lblOptionalMessage.text = type_optional_message_to_guest
        btnAccept?.setTitle(pre_accept, for: .normal)
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func onPreAcceptTapped(_ sender:UIButton!)
    {
        ProgressHud.shared.Animation = true
        let dict = NSMutableDictionary()
        dict["reservation_id"] = strReservationId
        if strPageTitle.characters.count > 0 {
            dict["message"]    = txtMessage.text
            dict["template"]    = "1"
        } else {
            dict["message_to_guest"] = txtMessage.text
        }
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: ((strPageTitle.characters.count > 0) ? API_PRE_APPROVAL_OR_DECLINE as NSString : API_PRE_ACCEPT as NSString) as String, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "preacceptchanged"), object: self, userInfo: nil)
                    self.onBackTapped(nil)
                }
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            OperationQueue.main.addOperation {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    
    // MARK:- TextView Delegate(s)
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 0 && (text == " ") {
            return false
        }
        if (text == "") {
            return true
        }
        if (text == "\n") {
            txtMessage.resignFirstResponder()
            return true
        }
        return true
    }
    
    // MARK:- Custom Method(s)
    
    func setUp() {
        txtMessage.text = ""
        txtMessage.textColor = UIColor.darkGray
        txtMessage.returnKeyType = UIReturnKeyType.done
        txtMessage.delegate = self
        txtMessage.layer.cornerRadius = 2.0
        txtMessage.layer.borderColor = UIColor(red: 0.8196078431, green: 0.831372549, blue: 0.8705882353, alpha: 1.0).cgColor
        txtMessage.layer.borderWidth = 1.0
        self.navigationController?.isNavigationBarHidden = true
        if strPageTitle.characters.count > 0 {
            btnAccept?.setTitle(strPageTitle, for: .normal)
            lblTitle?.text = strPageTitle
        }
        lblTitle?.layer.shadowColor = UIColor.gray.cgColor;
        lblTitle?.layer.shadowOffset = CGSize(width:1.0, height:1.0)
        lblTitle?.layer.shadowOpacity = 0.5
        lblTitle?.layer.shadowRadius = 1.0
    }
    
}
