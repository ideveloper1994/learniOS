//
//  EditTitleAndSummaryVC.swift
//  Arheb
//
//  Created on 03/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

protocol EditTitleDelegate {
    func editTitleTapped(strDescription: String)
}

class EditTitleAndSummaryVC: UIViewController, UITextViewDelegate {
    
    // MARK:- IBOutlet Method(s)
    
    @IBOutlet var vwBottom: UIView!
    @IBOutlet var lblPlaceHolder: UILabel!
    @IBOutlet var ConstLblHeight: NSLayoutConstraint!
    @IBOutlet var lblCharCount: UILabel!
    @IBOutlet var txvDesc: UITextView!
    @IBOutlet var ConstVwBottom: NSLayoutConstraint!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var animatedLoader: FLAnimatedImageView!
    
    var maxLength = -1
    var descriptionText = String()
    var delegate: EditTitleDelegate?
    var strRoomId = ""
    var isFromEditProfile : Bool = false
    var isFromRoomDesc : Bool = false
    var strTitle:String = ""
    var strPlaceHolder:String = ""
    var strAboutMe:String = ""
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = currency
        btnSave.setTitle(save, for: .normal)
        lblTitle.text = currency
        btnSave.setTitle(save, for: .normal)
        self.tabBarController?.tabBar.isHidden = true
        setDotLoader(animatedLoader)
        self.navigationController?.isNavigationBarHidden = true
        btnSave.isHidden = true
        txvDesc.delegate = self
        txvDesc.becomeFirstResponder()
        btnSave.isHidden = true
        if maxLength == 0 {
            vwBottom.isHidden = true
        }
        lblPlaceHolder.isHidden = (strAboutMe.characters.count > 0) ? true : false
        txvDesc.text = (strAboutMe.characters.count > 0) ? strAboutMe : ""
        btnSave.isHidden = (strAboutMe.characters.count > 0) ? false : true
        if isFromEditProfile {
            btnSave.isHidden = false
            txvDesc.text = (strAboutMe.characters.count > 0) ? strAboutMe : ""
            btnSave.setTitleColor(UIColor.darkGray, for: .normal)
            lblTitle.isHidden = true
            lblPlaceHolder.isHidden = true
            vwBottom.isHidden = true
            self.view.backgroundColor = UIColor.white
        }
        let length =  txvDesc.text?.characters.count
        lblCharCount.text = String(format:"%d Characters left",maxLength - length!)
        self.animatedLoader?.isHidden = true
        lblTitle.text = strTitle
        lblPlaceHolder.text = strPlaceHolder
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        self.ConstVwBottom.constant = keyboardFrame.size.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if maxLength == -1{
            vwBottom.isHidden = true
        } else {
            vwBottom.isHidden = false
        }
        lblTitle.text = strTitle
        lblPlaceHolder.text = descriptionText
        ConstLblHeight.constant = heightForView(text: lblPlaceHolder.text!, font: lblPlaceHolder.font, width: lblPlaceHolder.frame.size.width) + 3
    }
    
    // MARK:- TextView Method(s)
    
    func textViewDidChange(_ textView: UITextView) {
        let length =  txvDesc.text?.characters.count
        if !isFromEditProfile {
            if length!>0 {
                btnSave.isHidden = false
                lblPlaceHolder.isHidden = true
            } else {
                btnSave.isHidden = true
                lblPlaceHolder.isHidden = false
            }
        }
        if isFromRoomDesc {
            btnSave.isHidden = false
        }
        if maxLength != 0 {
            lblCharCount.text = String(format:"%d Characters left",maxLength - length!)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if maxLength == -1{
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        } else {
            let length =  txvDesc.text?.characters.count
            if range.location == 0 && (text == " ") {
                return false
            }
            if text == "" {
                return true
            }
            if maxLength == 0 {
                return true
            }
            let newLength = length! + text.characters.count
            if newLength <= maxLength {
                return true
            } else {
                let emptySpace: Int = maxLength - length!
                if !(emptySpace > text.characters.count) {
                    return false
                }
                if emptySpace > maxLength {
                    return false
                }
            }
            if length! >= maxLength {
                return false
            }
            return true
        }
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if isFromEditProfile {
            let st = (txvDesc.text.characters.count)>0 ? txvDesc.text : ""
            delegate?.editTitleTapped(strDescription: st!)
            self.navigationController!.popViewController(animated: true)
            return
        }
        if strAboutMe == txvDesc.text {
            self.btnBackClicked(nil)
            return
        }
        let dict = NSMutableDictionary()
        dict["room_id"]   = strRoomId
        let strTextValue = txvDesc.text
        if isFromRoomDesc {
            if strTitle == "The Space" {
                dict["space"]   = strTextValue
            } else if strTitle == "Guest Access" {
                dict["guest_access"]   = strTextValue
            } else if strTitle == "Interaction with Guests" {
                dict["interaction_guests"]   = strTextValue
            } else if strTitle == "Overview" {
                dict["neighborhood_overview"]   = strTextValue
            } else if strTitle == "Getting Around" {
                dict["getting_arround"]   = strTextValue
            } else if strTitle == "Other Things to Note" {
                dict["notes"]   = strTextValue
            } else if strTitle == "House Rules" {
                dict["house_rules"]   = strTextValue
                self.updateDescription(dict, methodName: API_UPDATE_HOUSE_RULES)
                return
            }
            self.updateDescription(dict, methodName: API_UPDATE_ROOM_DESC)
        } else if txvDesc.text.characters.count > 0 {
            if strTitle == "Edit Title" || strTitle == "Edit Summary" {
                if strTitle == "Edit Title"  {
                    dict["room_title"]   = strTextValue
                } else {
                    dict["room_description"]   = strTextValue
                }
                self.updateDescription(dict, methodName: API_UPDATE_TITLE)
            }
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:- API Calling Method(s)
    
    func updateDescription(_ dict: NSMutableDictionary,methodName: String) {
        self.btnSave.isHidden = true
        self.animatedLoader.isHidden = false
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: methodName, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    self.btnSave.isHidden = false
                    self.animatedLoader?.isHidden = true
                }else{
                    if methodName == API_UPDATE_ROOM_DESC {
                        let result = response as! NSDictionary
                        let abtModel = AboutTitleModel().initiateTitleData(responseDict: result)
                        self.delegate?.editTitleTapped(strDescription: self.txvDesc.text)
                        self.navigationController!.popViewController(animated: true)
                    } else {
                        self.delegate?.editTitleTapped(strDescription: self.txvDesc.text)
                        self.navigationController!.popViewController(animated: true)
                    }
                }
                self.animatedLoader?.isHidden = true
            }
        }) { (Error) in
            DispatchQueue.main.async {
                self.btnSave.isHidden = false
                self.animatedLoader?.isHidden = true
            }
        }
    }
    
}
