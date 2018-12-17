//
//  FacebookSignUpVC.swift
//  Arheb
//
//  Created on 5/31/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class FacebookSignUpVC: UIViewController {
    
    @IBOutlet var constBottomNext: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgFirstName: UIImageView!
    @IBOutlet weak var imgLastName: UIImageView!
    @IBOutlet weak var imgDob: UIImageView!
    @IBOutlet weak var imgBackground:UIImageView!
    @IBOutlet weak var lblError:UILabel!
    @IBOutlet weak var vwError:UIView!
    @IBOutlet weak var vwMain:UIView!
    let dateFormatter = DateFormatter()
    
    var firstName: String = ""
    var lastName: String = ""
    var dob: String = ""
    var fbId: String = ""
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        if(!firstName.isEmptyString()){
            txtFirstName.text = firstName
            imgFirstName.isHidden = false
            txtFirstName.isUserInteractionEnabled = false
        }
        if(!lastName.isEmptyString()){
            txtLastName.text = lastName
            imgLastName.isHidden = false
            txtLastName.isUserInteractionEnabled = false
        }
        if(!dob.isEmptyString()){
            txtDob.text = lastName
            imgDob.isHidden = false
            txtDob.isUserInteractionEnabled = false
        }
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.txtLastName.autocorrectionType = .no
        self.txtFirstName.autocorrectionType = .no
        self.txtDob.autocorrectionType = .no
        self.txtEmail.autocorrectionType = .no
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FacebookSignUpVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FacebookSignUpVC.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func viewcustomization(){
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController?.navigationBar.isHidden = true
        btnNext.layer.cornerRadius = btnNext.frame.size.width/2
    }
    
    //MARK: - IBAction Method
    @IBAction func bntLoginClicked(_ sender: Any) {
        validEmail()
    }
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCancelClicked(_ sender: Any) {
        hideErrorView()
    }
    //MARK: - Textfield delegate and datsource method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtFirstName){
            txtLastName.becomeFirstResponder()
        }else if(textField == txtLastName){
            txtDob.becomeFirstResponder()
        }else if(textField == txtDob){
            txtEmail.becomeFirstResponder()
        }
        else{
            txtEmail.resignFirstResponder()
        }
        return true
    }
    @IBAction func dateTextInputClicked(_ sender: UITextField) {
        //Create the view
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        let date = Date()
        let datePickerView  : UIDatePicker = UIDatePicker(frame:CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 200))//CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = date
        inputView.addSubview(datePickerView) // add date picker to UIView
        let doneButton = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: #selector(BirthdayVC.doneButton), for: UIControlEvents.touchUpInside) // set button click event
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(BirthdayVC.handleDatePicker), for: .valueChanged)
        
    }
    @IBAction func textfieldDidChange(_ textField: UITextField) {
        if !vwError.isHidden
        {
            hideErrorView()
        }
        if textField == txtEmail
        {
            if (!(txtEmail.text?.isEmptyString())!) && isValidEmail(testStr: txtEmail.text!)
            {
                imgEmail.isHidden = false
            }
            else
            {
                imgEmail.isHidden = true
            }
        }
        
        if textField == txtFirstName
        {
            if (!(txtFirstName.text?.isEmptyString())!) {
                imgFirstName.isHidden = false
            }
            else
            {
                imgFirstName.isHidden = true
            }
        }
        if textField == txtLastName
        {
            if (!(txtLastName.text?.isEmptyString())!) {
                imgLastName.isHidden = false
            }
            else
            {
                imgLastName.isHidden = true
            }
        }
        if textField == txtDob
        {
            if (!(txtDob.text?.isEmptyString())!) {
                imgDob.isHidden = false
            }
            else
            {
                imgDob.isHidden = true
            }
        }
        checkLogin()
    }
    //MARK: - Api calling Method
    // @param {email}
    func validEmail(){
        ProgressHud.shared.Animation = true
        let param = NSMutableDictionary()
        param.setValue(txtEmail.text?.trim(), forKey: Signup.emailId)
    
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_EMAILVALIDATION, params: param, isTokenRequired: false, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    self.vwError.isHidden = false
                    self.showErrorMsg(message: error!)
                }else {
                    self.callSignUp()
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            print(error)
            ProgressHud.shared.Animation = false
        }
    }
    
    func callSignUp() {
        ProgressHud.shared.Animation = true
        let param = NSMutableDictionary()
        param.setValue(txtEmail.text?.trim(), forKey: Signup.emailId)
        param.setValue("", forKey: Signup.password)
        param.setValue(txtFirstName.text?.trim(), forKey: Signup.firstName)
        param.setValue(txtLastName.text?.trim(), forKey: Signup.lastName)
        param.setValue(fbId.trim(), forKey: Signup.facebookId)
        param.setValue(txtDob.text?.trim(), forKey: Signup.dob)
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_SIGNUP, params: param, isTokenRequired: false, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                if(error != nil) {
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
    
    //MARK: - Custom Method
    func checkLogin(){
        if(( !(txtEmail.text?.isEmpty)! && isValidEmail(testStr: txtEmail.text!)) && (!(txtLastName.text?.isEmpty)!) && (!(txtDob.text?.isEmpty)!) && (!(txtFirstName.text?.isEmpty)!)){
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
    func handleDatePicker(sender: UIDatePicker) {
        txtDob.text = dateFormatter.string(from: sender.date)
        checkLogin()
    }
    func doneButton(sender:UIButton){
        txtEmail.becomeFirstResponder()
        if (!(txtDob.text?.isEmptyString())!) {
            imgDob.isHidden = false
        }
        else
        {
            imgDob.isHidden = true
        }        
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
