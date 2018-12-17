//
//  LoginVC.swift
//  Makent
//
//  Created on 5/29/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class LoginVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var constBottomNext: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var scrollview:UIScrollView!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var vwError:UIView!
    @IBOutlet weak var vwMain:UIView!
    @IBOutlet weak var imgEmail:UIImageView!
    @IBOutlet weak var imgPassword:UIImageView!
    @IBOutlet weak var imgBackground:UIImageView!
    @IBOutlet weak var lblError:UILabel!
    var isSecurePassword:Bool!
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        isSecurePassword = true
        self.txtEmail.autocorrectionType = .no
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginVC.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Customize the view
    func viewcustomization(){
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController?.navigationBar.isHidden = true
        btnNext.layer.cornerRadius = btnNext.frame.size.width/2
    }
    
    //MARK: - Textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtEmail){
            txtPassword.becomeFirstResponder()
        }else{
            txtPassword.resignFirstResponder()
        }
        return true
    }

    @IBAction func textfieldDidChange(_ textField: UITextField) {
        if !vwError.isHidden {
            hideErrorView()
        }
        if textField == txtEmail {
            if(!(txtEmail.text?.isEmptyString())! && isValidEmail(testStr: txtEmail.text!)) {
                imgEmail.isHidden = false
            }else{
                imgEmail.isHidden = true
            }
        }else if textField == txtPassword {
            if (txtPassword.text?.isEmptyString())!{
                imgPassword.isHidden = true
            }else{
                imgPassword.isHidden = false
            }
        }
        checkLogin()
    }
    
    //MARK: - Custom Method
    
    func checkLogin(){
        if(( !(txtEmail.text?.isEmpty)! && isValidEmail(testStr: txtEmail.text!)) && (!(txtPassword.text?.isEmpty)!)){
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            btnNext.isUserInteractionEnabled = true
        }else{
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            btnNext.isUserInteractionEnabled = false
        }
    }
    
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
    
    //MARK: - Api calling Method
    // @param {email, password}
    func callLogin(){
        ProgressHud.shared.Animation = true
        let param = NSMutableDictionary()
        param.setValue(txtEmail.text?.trim(), forKey: "email")
        param.setValue(txtPassword.text?.trim(), forKey: "password")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_LOGIN, params: param, isTokenRequired: false, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    self.vwError.isHidden = false
                    self.showErrorMsg(message: error!)
                }else{
                    let dictRes:NSDictionary = res as! NSDictionary;
                    var objLoginModel = LoginModel()
                    objLoginModel =  objLoginModel.addResponseToLogin(res: dictRes)
                    setUserDetails(user: objLoginModel)
                    self.dismiss(animated: true, completion: nil)
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            print(error)
            ProgressHud.shared.Animation = false
        }
    }
    
    //MARK: - IBAction Method
    @IBAction func bntShowClicked(_ sender: Any) {
        if(!(txtPassword.text?.isEmpty)!){
            if(!isSecurePassword){
                isSecurePassword = true
                txtPassword.isSecureTextEntry = true
            }else{
                isSecurePassword = false
                txtPassword.isSecureTextEntry = false
            }
        }
    }
    
    @IBAction func bntLoginClicked(_ sender: Any) {
       
        KeychainWrapper.standard.set("", forKey: keyChainKey.email)
        KeychainWrapper.standard.set("", forKey: keyChainKey.password)
        callLogin()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        hideErrorView()
    }
    
    @IBAction func btnForgotPasswordClick(_ sender: Any) {
        let forgotVC = ForgotPasswordVC(nibName: "ForgotPasswordVC", bundle: nil)
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    //MARK: - Memory Warning
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
