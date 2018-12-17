//
//  PhoneNumberVC.swift
//  Arheb
//
//  Created on 6/19/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class PhoneVerificationVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet var lblcode: UILabel!
    
    @IBOutlet weak var txtNumber:UITextField!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var imgTickMark:UIImageView!
    @IBOutlet weak var bottomNxtBtn: NSLayoutConstraint!
    @IBOutlet var ConstVwMainLeading: NSLayoutConstraint!
    
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var vwMain: UIView!
    @IBOutlet var vwError: UIView!
    @IBOutlet var lblError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BirthdayVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BirthdayVC.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        viewcustomization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ConstVwMainLeading.constant += UIScreen.main.bounds.size.width*2
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.ConstVwMainLeading.constant -= UIScreen.main.bounds.size.width*2
            // self.view.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func viewcustomization() {
        self.txtNumber.delegate = self
        lblTitle.text = headerVerification
        lblcode.text = code
        self.hideErrorView()
        self.checkStatus()
    }
    
    
    //MARK: - keyboardNotification Method
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomNxtBtn.constant = keyboardSize.height + 15
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            bottomNxtBtn.constant = 20
        }
    }
    
    //MARK: - IBAction Method
    @IBAction func btnNextClicked(_ sender: Any) {
        verifyPhoneNo()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelErroClicked(_ sender: Any) {
        hideErrorView()
    }
    
    func showErrorMsg(message: String){
        self.txtNumber.resignFirstResponder()
        self.imgBackground.isHidden = true
        self.vwMain.backgroundColor = UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
        lblError.text = message
    }
    
    func hideErrorView(){
        vwError.isHidden = true
        vwMain.backgroundColor = UIColor.clear
        imgBackground.isHidden = false
    }
    
    //MARK: - TextField Delegate Method

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    
    @IBAction func textChange(_ sender: UITextField) {
        self.hideErrorView()
        checkStatus()
    }
    
    //MARK: - Custom Method
    func checkStatus(){
        if(!(txtNumber.text?.isEmptyString())! && txtNumber.text!.trim().characters.count > 3) {
            enableView()
        }else{
            disableView()
        }
    }
    
    func enableView(){
        imgTickMark.isHidden = false
        btnNext.backgroundColor = UIColor.white
        btnNext.isUserInteractionEnabled = true
    }
    
    func disableView(){
        imgTickMark.isHidden = true
        btnNext.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        btnNext.isUserInteractionEnabled = false
    }
    
    //MARK:- API call get Country details
    func verifyPhoneNo() {
        let param = NSMutableDictionary()
        var id = "0"
        if(appDelegate?.phoneNoDetail.count != 0){
            id = appDelegate!.phoneNoDetail[0].id
        }
        param.setValue(id, forKey: "id")
        param.setValue(txtNumber.text?.trim(), forKey: "otp")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_VERIFY_PHONE_NUMBER, params: param, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil) {
                    self.vwError.isHidden = false
                    self.showErrorMsg(message: error!)
                }else {
                    if(response != nil) {
                        appDelegate?.getPhoneNumbers()
                        if(appDelegate?.isFromProfilePage)!{
                            let editVC = EditProfileVC(nibName: "EditProfileVC", bundle: nil)
                            self.navigationController?.pushViewController(editVC, animated: true)
                        }else{
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
}

