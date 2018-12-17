//
//  SignUpEmail.swift
//  Arheb
//
//  Created on 5/30/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class SignUpEmailVC: UIViewController {
    
    @IBOutlet var imgEmail: UIImageView!
    @IBOutlet var constBottomNext: NSLayoutConstraint!
    @IBOutlet var ConstVwMainLeading: NSLayoutConstraint!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var vwError: UIView!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var lblError: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var imgBackground: UIImageView!
    
    var strFirstName: String = ""
    var strLastName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        self.checkStatus()
        self.txtEmail.autocorrectionType = .no
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SignUpEmailVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SignUpEmailVC.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ConstVwMainLeading.constant += UIScreen.main.bounds.size.width*2
        // view.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.ConstVwMainLeading.constant -= UIScreen.main.bounds.size.width*2
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK: Here Customize the view
    func viewcustomization(){
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController?.navigationBar.isHidden = true
        btnNext.layer.cornerRadius = btnNext.frame.size.width/2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Textfield delegate methods
    @IBAction func textChanged(_ sender: UITextField) {
        if !vwError.isHidden{
            hideErrorView()
        }
        checkStatus()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtEmail){
            txtEmail.resignFirstResponder()
        }
        return true
    }
    
    //MARK: Here check the email
    func checkStatus(){
        if(!(txtEmail.text?.isEmpty)! && isValidEmail(testStr: txtEmail.text!)) {
            imgEmail.isHidden = false
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            btnNext.isUserInteractionEnabled = true
        }else{
            imgEmail.isHidden = true
            btnNext.isUserInteractionEnabled = false
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    
    //MARK: - IBAction Method
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClicked(_ sender: UIButton) {
        self.checkEmail()
    }
    
    @IBAction func btnCancelErroClicked(_ sender: Any) {
        hideErrorView()
    }
    
    //MARK: Handle the error message
    func showErrorMsg(message: String){
        self.imgBackground.isHidden = true
        self.mainView.backgroundColor = UIColor(red: 252.0 / 255.0, green: 100.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
        lblError.text = message
    }
    
    func hideErrorView(){
        vwError.isHidden = true
        mainView.backgroundColor = UIColor.clear
        imgBackground.isHidden = false
    }
    
    //MARK: Check Email Id already exists or not
    // @param {email}
    func checkEmail() {
        ProgressHud.shared.Animation = true
        let param = NSMutableDictionary()
        param.setValue(txtEmail.text?.trim(), forKey: "email")
        ServerAPI.sharedInstance.makeCall(apiName: API_EMAILVALIDATION, params: param, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    self.vwError.isHidden = false
                    self.showErrorMsg(message: error!)
                }else{
                    let dictRes:NSDictionary = response as! NSDictionary
                    let vc = CreatePasswordVC(nibName: "CreatePasswordVC", bundle: nil)
                    vc.strFirstName = self.strLastName
                    vc.strLastName = self.strLastName
                    vc.strEmail = self.txtEmail.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                ProgressHud.shared.Animation = false
            }
        }) { (err) in
            ProgressHud.shared.Animation = false
        }
        
//        let vc = CreatePasswordVC(nibName: "CreatePasswordVC", bundle: nil)
//        vc.strFirstName = self.strLastName
//        vc.strLastName = self.strLastName
//        vc.strEmail = self.txtEmail.text!
//        self.navigationController?.pushViewController(vc, animated: true)
        
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
