//
//  BirthdayVC.swift
//  Arheb
//
//  Created on 31/05/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class BirthdayVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var constBottomNext: NSLayoutConstraint!
    @IBOutlet var txtDatePicker: UITextField!
    @IBOutlet var imgDone: UIImageView!
    @IBOutlet var ConstVwMainLeading: NSLayoutConstraint!
    let dateFormatter = DateFormatter()
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var vwMain: UIView!
    @IBOutlet var vwError: UIView!
    @IBOutlet var lblError: UILabel!
    var strFirstName: String = ""
    var strLastName: String = ""
    var strEmail: String = ""
    var strPassword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        viewcustomization()
        self.checkStatus()
        txtDatePicker.delegate = self
        self.txtDatePicker.autocorrectionType = .no
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BirthdayVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BirthdayVC.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func viewcustomization(){
        self.navigationController?.navigationBar.isHidden = true
        btnNext.layer.cornerRadius = btnNext.frame.size.width/2
    }
    
    @IBAction func dateTextInputClicked(_ sender: UITextField) {
        //Create the view
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
//        let date = Date()
        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())

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
    
    //MARK: check email validation first
    func checkStatus(){
        if ((txtDatePicker.text?.isEmptyString())!){
            imgDone.isHidden = true
            btnNext.isUserInteractionEnabled = false
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }else{
            imgDone.isHidden = false
            btnNext.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            btnNext.isUserInteractionEnabled = true
        }
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        txtDatePicker.text = dateFormatter.string(from: sender.date)
        checkStatus()
    }
    
    //MARK: To resign the inputView on clicking done.
    func doneButton(sender:UIButton){
        txtDatePicker.resignFirstResponder()
        btnNext.backgroundColor = UIColor.white
        btnNext.isUserInteractionEnabled = true
    }
    
    //MARK: - IBAction Method
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClicked(_ sender: UIButton) {
        self.registration()
    }
    
    @IBAction func btnCancelErroClicked(_ sender: Any) {
        hideErrorView()
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
    
    //MARK: Signup api call
    func registration() {
        ProgressHud.shared.Animation = true
        self.hideErrorView()
        let param = NSMutableDictionary()
        // @param {first_name, email, last_name, password, dob}
        param.setValue(strLastName.trim(), forKey: Signup.lastName)
        param.setValue(strFirstName.trim(), forKey: Signup.firstName)
        param.setValue(strEmail.trim(), forKey: Signup.emailId)
        param.setValue(strPassword.trim(), forKey: Signup.password)
        param.setValue(txtDatePicker.text!.trim(), forKey: Signup.dob)
        
        ServerAPI.sharedInstance.makeCall(apiName: API_SIGNUP, params: param, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    self.vwError.isHidden = false
                    self.showErrorMsg(message: error!)
                }else{
                    let dictRes:NSDictionary = res as! NSDictionary;
                    var objLoginModel = LoginModel()
                    objLoginModel =  objLoginModel.addResponseToLogin(res: dictRes)
                    setUserDetails(user: objLoginModel)
                    let phoneVC = PhoneNumberVC(nibName: "PhoneNumberVC", bundle: nil)
                    phoneVC.isVerification = true
                    phoneVC.isSkip = true
                    self.navigationController?.pushViewController(phoneVC, animated: true)
                }
                ProgressHud.shared.Animation = false
            }
        }) { (err) in
            ProgressHud.shared.Animation = false
        }
        
//        let phoneVC = PhoneNumberVC(nibName: "PhoneNumberVC", bundle: nil)
//        phoneVC.isVerification = false
//        phoneVC.isSkip = true
//        self.navigationController?.pushViewController(phoneVC, animated: true)

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
