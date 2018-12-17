//
//  SignUPVC.swift
//  Arheb
//
//  Created on 5/30/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var constBottomNext: NSLayoutConstraint!
    @IBOutlet var ConstVwMainLeading: NSLayoutConstraint!
    @IBOutlet var imglastName: UIImageView!
    @IBOutlet var imgFirstName: UIImageView!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        self.checkStatus()
        txtLastName.delegate = self
        txtLastName.delegate = self
        self.txtFirstName.autocorrectionType = .no
        self.txtLastName.autocorrectionType = .no
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SignUpVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SignUpVC.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ConstVwMainLeading.constant += UIScreen.main.bounds.size.width*2
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
        self.navigationController?.navigationBar.isHidden = true
        btnNext.layer.cornerRadius = btnNext.frame.size.width/2
        imglastName.isHidden = true
        imgFirstName.isHidden = true
    }
    
    //MARK: Here check the textInput
    func checkStatus(){
        if (txtFirstName.text?.isEmptyString())!{
            imgFirstName.isHidden = true
        }else{
            imgFirstName.isHidden = false
        }
        if (txtLastName.text?.isEmptyString())!{
            imglastName.isHidden = true
        }else {
            imglastName.isHidden = false
        }
        if (txtFirstName.text?.isEmptyString())! || (txtLastName.text?.isEmptyString())! {
            btnNext.isUserInteractionEnabled = false
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }else  {
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            btnNext.isUserInteractionEnabled = true
        }
    }
    
    //MARK: - Textfield delegate methods
    @IBAction func textChanged(_ sender: UITextField) {
        self.checkStatus()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtFirstName){
            txtLastName.becomeFirstResponder()
        }else{
            txtLastName.resignFirstResponder()
        }
        return true
    }

    //MARK: - IBAction Method
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnNextClicked(_ sender: UIButton) {
        let vc = SignUpEmailVC(nibName: "SignUpEmailVC", bundle: nil)
        vc.strFirstName = txtFirstName.text!
        vc.strLastName = txtLastName.text!
        self.navigationController?.pushViewController(vc, animated: true)
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
