//
//  ForgotPasswordVC.swift
//  Arheb
//
//  Created by on 5/30/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var constBottomNext: NSLayoutConstraint!
    @IBOutlet var imgEmail: UIImageView!
    @IBOutlet weak var imgBackground:UIImageView!
    @IBOutlet var vwError: UIView!
    @IBOutlet weak var vwMain:UIView!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet weak var lblError:UILabel!
    
    //MARK:Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        self.txtEmail.autocorrectionType = .no
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ForgotPasswordVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ForgotPasswordVC.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)    }
    
    func viewcustomization(){
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController?.navigationBar.isHidden = true
        btnNext.layer.cornerRadius = btnNext.frame.size.width/2
    }
    
    //MARK:textfield delegate & datasource method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtEmail){
            txtEmail.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func textfieldDidChange(_ textField: UITextField) {
        if !vwError.isHidden
        {
            hideErrorView()
        }
        let length = textField.text?.characters.count
        if textField==txtEmail
        {
            if length!>0 && isValidEmail(testStr: txtEmail.text!)
            {
                imgEmail.isHidden = false
            }
            else
            {
                imgEmail.isHidden = true
            }
        }
        
        checkLogin()
    }
    //MARK:Custom Method
    func showErrorMsg(message: String){
        self.imgBackground.isHidden = true
        self.vwMain.backgroundColor = UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
        lblError.text = message
    }
    
    func hideErrorView(){
        vwError.isHidden = true
        vwMain.backgroundColor = UIColor.clear
        imgBackground.isHidden = false
    }
    
    func checkLogin(){
        if(( !(txtEmail.text?.isEmpty)! && isValidEmail(testStr: txtEmail.text!))){
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            btnNext.isUserInteractionEnabled = true
        }else{
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            btnNext.isUserInteractionEnabled = false
        }
    }
    
    //MARK: - Api calling Method
    func callForgotPassword(){
        ProgressHud.shared.Animation = true
        let param = NSMutableDictionary()
        param.setValue(txtEmail.text?.trim(), forKey: "email")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_FORGOTPASSWORD, params: param, isTokenRequired: false, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                if(error != nil) {
                    self.vwError.isHidden = false
                    self.showErrorMsg(message:error!)
                }else{
                    let alert = UIAlertController(title: "Check your Email", message:String(format: "We sent an email to %@. Tap the link in that email to reset your password.", self.txtEmail.text!), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            print(error)
            ProgressHud.shared.Animation = false
        }
    }
    
    //MARK:IBAction Method
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNextClicked(_ sender: Any) {
        callForgotPassword()
    }
    @IBAction func btnCancelClicked(_ sender: Any) {
        hideErrorView()
    }
    
    //MARK:Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - keyboardNotification Method
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            constBottomNext.constant = keyboardSize.height + 15
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            constBottomNext.constant = 20
        }
    }
    
}
