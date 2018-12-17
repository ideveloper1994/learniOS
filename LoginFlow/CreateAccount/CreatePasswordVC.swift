//
//  CreatePasswordVC.swift
//  Arheb
//
//  Created on 30/05/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class CreatePasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var constBottomNext: NSLayoutConstraint!
    @IBOutlet var btnShow: UIButton!
    @IBOutlet var imgPassword: UIImageView!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var ConstVwMainLeading: NSLayoutConstraint!
    var strFirstName: String = ""
    var strLastName: String = ""
    var strEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        self.checkStatus()
        txtPassword.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CreatePasswordVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CreatePasswordVC.keyboardWillHide(notification:)),
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
            // self.view.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }

    func viewcustomization(){
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController?.navigationBar.isHidden = true
        btnNext.layer.cornerRadius = btnNext.frame.size.width/2
    }

    //MARK: - Textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtPassword.resignFirstResponder()
        return true
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        checkStatus()
    }
    
    func checkStatus(){
        //check email validation first
        if ((txtPassword.text?.isEmptyString())!)
        {
            imgPassword.isHidden = true
            btnNext.isUserInteractionEnabled = false
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
        else
        {
            imgPassword.isHidden = false
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            btnNext.isUserInteractionEnabled = true
        }
        
    }
    
    //MARK: - IBAction Method
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClicked(_ sender: UIButton) {
        let vc = BirthdayVC(nibName: "BirthdayVC", bundle: nil)
        vc.strFirstName = self.strLastName
        vc.strLastName = self.strLastName
        vc.strEmail = self.strEmail
        vc.strPassword = txtPassword.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnShowClicked(_ sender: UIButton) {
        if(txtPassword.isSecureTextEntry){
            txtPassword.isSecureTextEntry = false
            btnShow.setTitle("Hide", for: .normal)
        }else{
            txtPassword.isSecureTextEntry = true
            btnShow.setTitle("Show", for: .normal)
        }
    }
    
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
