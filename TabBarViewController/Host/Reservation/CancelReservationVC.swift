//
//  CancelReservationVC.swift
//  Arheb
//
//  Created on 6/1/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

protocol CancelReservationDelegate {
    func CancelReservationChanged(strDescription: NSString)
}

class CancelReservationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var lbCancelReservation: UILabel!
    @IBOutlet weak var vwCancel: UIView!
    @IBOutlet weak var vwNav: UIView!
    @IBOutlet weak var txtReason: UITextView!
    @IBOutlet weak var tblReason:UITableView!
    @IBOutlet weak var lblReason:UILabel!
    @IBOutlet var btnReason: UIButton!
    @IBOutlet var btnCancelReservation: UIButton!
    
    var arrCancelTitles = [String]()
    var selectedIndex = IndexPath()
    var strSeletedReason : String = ""
    var strReservationId : String = ""
    var strMethodName : String = ""
    var strButtonTitle = ""
    var delegate: CancelReservationDelegate?
    var isInbox:Bool = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCustomization()
        lbCancelReservation.text = cancel_this_reservation
        lblReason.text = why_are_you_declining
        registerCell()
        selectedIndex = IndexPath(row: 0, section: 0) as IndexPath
    }
    
    //MARK:- Custom Method(s)
    
    func viewCustomization(){
        tblReason.estimatedRowHeight = 100
        tblReason.rowHeight = UITableViewAutomaticDimension
        txtReason.text = ""
        txtReason.delegate = self
        txtReason.textColor = UIColor.darkGray
        strSeletedReason = arrCancelTitles[0] as String
        if strButtonTitle.characters.count > 0 {
            btnCancelReservation.setTitle(strButtonTitle, for: .normal)
        }
        tblReason.isHidden = true
        tblReason.reloadData()
        txtReason.returnKeyType = UIReturnKeyType.done
        vwCancel.layer.borderColor = AppColor.dark_border.cgColor
        txtReason.layer.borderColor = AppColor.light_border.cgColor
        vwNav.layer.shadowColor = UIColor.lightGray.cgColor
        tblReason.layer.borderColor = AppColor.light_border.cgColor
        tblReason.separatorColor = UIColor.clear
    }
    
    func registerCell() {
        tblReason.register(UINib(nibName: "CancelReservationCell", bundle: nil), forCellReuseIdentifier: "CancelReservationCell")
    }
    
    //MARK: - TableView Method(s)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCancelTitles.count > 0 ? arrCancelTitles.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CancelReservationCell = tblReason.dequeueReusableCell(withIdentifier: "CancelReservationCell") as! CancelReservationCell
        cell.lblTitle.text = arrCancelTitles[indexPath.row]
        cell.lblSelected.isHidden = indexPath == selectedIndex ? false : true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lblReason.text = arrCancelTitles[indexPath.row]
        selectedIndex = indexPath
        tblReason.isHidden = true
        tblReason.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    //MARK: - IBAction Method(s)
    
    @IBAction func btnCancelClicked(_ sender: UIButton!) {
        if isInbox {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnReservationClicked(_ sender: Any) {
        tblReason.isHidden = !tblReason.isHidden
    }
    
    @IBAction func btnCancelReservationClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.cancelReservationAPI()
    }
    
    // MARK:- TextView delegate(s)
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 0 && (text == " ") {
            return false
        }
        if (text == "") {
            return true
        }
        if (text == "\n") {
            txtReason.resignFirstResponder()
            return true
        }
        return true
    }
    
    //MARK: - Memory warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- API Calling Method(s)
    
    func cancelReservationAPI() {
        ProgressHud.shared.Animation = true
        let dict = NSMutableDictionary()
        dict["reservation_id"] = strReservationId
        if self.strMethodName == API_DECLINE_RESERVATION {
            dict["decline_message"] = txtReason.text
            dict["decline_reason"] = (arrCancelTitles[0] == strSeletedReason) ? "" : strSeletedReason.replacingOccurrences(of: " ", with: "%20")
        } else if self.strMethodName == API_PRE_APPROVAL_OR_DECLINE{
            dict["message"]    = txtReason.text
            dict["template"]    = "9"
        } else {
            dict["cancel_message"] = txtReason.text
            dict["cancel_reason"] = (arrCancelTitles[0] == strSeletedReason) ? "" : strSeletedReason.replacingOccurrences(of: " ", with: "%20")
        }
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: strMethodName, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    self.btnCancelClicked(nil)
                    if self.strMethodName == API_CANCEL_RESERVATION || self.strMethodName == API_DECLINE_RESERVATION || self.strMethodName == API_PRE_APPROVAL_OR_DECLINE {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CancelReservation"), object: self, userInfo: nil)
                        if self.strMethodName == API_DECLINE_RESERVATION {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CancelResquestToBook"), object: self, userInfo: nil)
                    }
                }
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            OperationQueue.main.addOperation {
                ProgressHud.shared.Animation = false
            }
        }
    }
}
