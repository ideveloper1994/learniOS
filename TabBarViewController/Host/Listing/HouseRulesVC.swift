//
//  HouseRulesVC.swift
//  Arheb
//
//  Created on 03/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

protocol HouseRulesAgreeDelegate
{
    func onAgreeTapped()
}

class HouseRulesVC: UIViewController, UITextViewDelegate {

    // MARK:- IBOutlet(s)
    
    @IBOutlet var txvHouseRules: UITextView!
    @IBOutlet var lblPlaceHolder: UILabel!
    @IBOutlet var btnAgree: UIButton!
    @IBOutlet var vwAgree: UIView!
    @IBOutlet var btnClose: UIButton!
    
    var strRoomId = ""
    var strHostUserName = ""
    var strHouseRules = ""
    var isFromRoomDetails : Bool = false
    var isFromRoomAboutHome : Bool = false
    var delegate: HouseRulesAgreeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        txvHouseRules.delegate = self
        vwAgree?.isHidden = (isFromRoomDetails) ? true : false
        if isFromRoomAboutHome {
            lblPlaceHolder?.text = aboutHome
        } else{
            lblPlaceHolder?.text = String(format:"%@'s %@",strHostUserName,house_rules)
        }
        let height = heightForView(text: String(format:"%@'s %@",strHostUserName,house_rules), font: (lblPlaceHolder?.font)!, width: (lblPlaceHolder?.frame.size.width)!)
        var rectViewRule = lblPlaceHolder?.frame
        rectViewRule?.size.height = height+5
        lblPlaceHolder?.frame = rectViewRule!
        self.txvHouseRules?.text = strHouseRules
    }
    func viewcustomization(){
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        btnAgree.setTitle(agree, for: .normal)
    }
    
    // MARK:- TextView Delegate Method(s)
    
    func textViewDidChange(_ textView: UITextView) {
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK:- Memory Warning(s)

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func handleBtnAgree(_ sender: UIButton) {
        delegate?.onAgreeTapped()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleBtnClose(_ sender: UIButton) {        
        dismiss(animated: true, completion: nil)
    }
    
    
}
