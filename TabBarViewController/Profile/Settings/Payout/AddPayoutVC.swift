//
//  AddPayoutVC.swift
//  Arheb
//
//  Created on 6/3/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class AddPayoutVC: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var vwNav: UIView!
    @IBOutlet var navTitle: UILabel!
    
    @IBOutlet var vwError: UIView!
    
    @IBOutlet var lblError: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var lblSubTitle: UILabel!
    
    @IBOutlet var txtAddress1: UITextField!
    @IBOutlet var txtAddress2: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtstate: UITextField!
    @IBOutlet var txtPostalCode: UITextField!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var lbladdress1: UILabel!
    
    @IBOutlet var lblAddress2: UILabel!
    @IBOutlet var lblCity: UILabel!
    
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblPostalCode: UILabel!
    
    @IBOutlet var lblCountry: UILabel!
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var vwGetEmail: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var btnSave: UIButton!
    
    var arrCountry = [CountryModel]()
    var countryPickerView = UIPickerView()
    
    //Payment Type
    
    @IBOutlet var vwSelectPayment: UIView!
    
    @IBOutlet var txtAccountHolderName: UITextField!
    @IBOutlet var txtBankName: UITextField!
    
    @IBOutlet var txtBranchName: UITextField!
    
    @IBOutlet var txtIBANNumber: UITextField!
    
    @IBOutlet var vwBankDetail: UIView!
    @IBOutlet var btnSubmitBankDetail: UIButton!
    
    var selectedMethod = ""
    var viewType = "Main"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCountryList()
        self.viewcustomization()
        self.setDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = checkSaveButtonStatus()
        checkSubmitButtonStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Customize the view
    func viewcustomization(){
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        vwNav.layer.shadowColor = UIColor.lightGray.cgColor
        btnSubmit.layer.cornerRadius = 5
        btnSave.layer.cornerRadius = 5
        lbladdress1.text = address1
        lblAddress2.text = address2
        lblCity.text = city
        lblPostalCode.text = postalCode
        lblState.text = state
        lblCountry.text = country
        lblSubTitle.text = addAddress
        navTitle.text = payout
        txtCountry.placeholder = country
        txtEmail.placeholder = paypalEmail
        txtCountry.inputView = countryPickerView
        txtEmail.layer.cornerRadius = 5
        txtEmail.layer.borderWidth = 1
        txtEmail.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        txtAddress1.delegate = self
        txtAddress2.delegate = self
        txtstate.delegate = self
        txtCountry.delegate = self
        txtPostalCode.delegate = self
        txtEmail.delegate = self
        txtCity.delegate = self
        btnSubmitBankDetail.layer.cornerRadius = 5
        
        let paddingView = UIView(frame:  CGRect(x: 0, y: 0, width: 10, height: self.txtEmail.frame.height))
        txtEmail.leftView = paddingView
        txtEmail.leftViewMode = UITextFieldViewMode.always
        
    }
    
    func setDetails() {
//        let path = Bundle.main.path(forResource: "country", ofType: "plist")
//        arrCountry = NSMutableArray(contentsOfFile: path!)!
        countryPickerView.delegate = self
    }
    
    //MARK:- Customize Picker view
    @IBAction func countryTextInputClick(_ sender: UITextField) {
        vwNav.layer.shadowColor = UIColor.lightGray.cgColor
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        countryPickerView = UIPickerView(frame:CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 200))
        inputView.addSubview(countryPickerView)
        let doneButton = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(self.btnDoneCountry), for: UIControlEvents.touchUpInside)
        countryPickerView.delegate = self
        sender.inputView = inputView
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        
        if (sender.tag == 20){
            txtEmail.text = sender.text
        }else if (sender.tag == 21){
            txtAddress1.text = sender.text
        }else if (sender.tag == 22){
            txtAddress2.text = sender.text
        }else if (sender.tag == 23){
            txtCity.text = sender.text
        }else if (sender.tag == 24){
            txtstate.text = sender.text
        }else if (sender.tag == 25){
            txtPostalCode.text = sender.text
        }else if (sender.tag == 26){
            txtCountry.text = ""
        }
        checkSubmitButtonStatus()
        _ = checkSaveButtonStatus()
    }
    func checkSubmitButtonStatus() {
        if (!txtAddress1.text!.isEmptyString() && !txtAddress2.text!.isEmptyString() && !txtCity.text!.isEmptyString() && !txtstate.text!.isEmptyString() && !txtPostalCode.text!.isEmptyString() && !txtCountry.text!.isEmptyString()) {
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 83/255, alpha: 1.0)
        }else{
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.backgroundColor = UIColor.gray
        }
    }
    
    func btnDoneCountry(sender:UIButton){
        txtCountry.resignFirstResponder()
    }
    
    func checkSaveButtonStatus() -> Bool{
        if (!txtEmail.text!.isEmptyString() && isValidEmail(testStr: txtEmail.text!)) {
            btnSave.isUserInteractionEnabled = true
            btnSave.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 83/255, alpha: 1.0)
            return true
        } else {
            btnSave.isUserInteractionEnabled = false
            btnSave.backgroundColor = UIColor.gray
            return false
        }
        
    }
    // MARK: - UIPickerView Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCountry.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return (arrCountry[row] as AnyObject).value(forKey: "country_name") as? String
        return arrCountry[row].country_name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.txtCountry.text = (arrCountry[row] as AnyObject).value(forKey: "country_name") as? String
        self.txtCountry.text = arrCountry[row].country_name
        checkSubmitButtonStatus()
    }
    
    
    //MARK: - Textfield delegate methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.vwError.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtAddress1){
            txtAddress2.becomeFirstResponder()
        }else if(textField == txtAddress2){
            txtCity.becomeFirstResponder()
        }else if(textField == txtCity){
            txtstate.becomeFirstResponder()
        }else if(textField == txtstate){
            txtPostalCode.becomeFirstResponder()
        }else if(textField == txtPostalCode){
            txtCountry.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        if(viewType == "Main") {
            self.navigationController?.popViewController(animated: true)
        }else if(viewType == "SelectPaymentType") {
            if(self.view.subviews.contains(self.vwSelectPayment)){
                self.vwSelectPayment.removeFromSuperview()
            }
            self.vwError.isHidden = true
            self.scrollView.isHidden = false
            self.vwGetEmail.isHidden = true
            self.viewType = "Main"
            
        }else if(viewType == "BankDetail") {
            if(self.view.subviews.contains(self.vwBankDetail)){
                self.vwBankDetail.removeFromSuperview()
            }
            self.vwError.isHidden = true
            self.scrollView.isHidden = true
            self.vwGetEmail.isHidden = true
            self.vwSelectPayment.frame = CGRect(x: 0, y: 64, width: Screen.width, height: Screen.height - 64)
            self.view.addSubview(self.vwSelectPayment)
            self.viewType = "SelectPaymentType"
        }else if(viewType == "Email") {
            self.vwError.isHidden = true
            self.scrollView.isHidden = true
            self.vwGetEmail.isHidden = false
            self.vwSelectPayment.frame = CGRect(x: 0, y: 64, width: Screen.width, height: Screen.height - 64)
            self.view.addSubview(self.vwSelectPayment)
            self.viewType = "SelectPaymentType"
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    @IBAction func btnSubmitClick(_ sender: Any) {
        self.vwError.isHidden = true
        self.scrollView.isHidden = true
        self.vwGetEmail.isHidden = true
        self.vwSelectPayment.frame = CGRect(x: 0, y: 64, width: Screen.width, height: Screen.height - 64)
        self.view.addSubview(self.vwSelectPayment)
        self.viewType = "SelectPaymentType"
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        if checkSaveButtonStatus(){
            self.savePayOutDetails()
        }else{
            self.lblError.text = enterValidEmail
            self.vwError.isHidden = false
        }
    }
    
    @IBAction func btnPaypalClicked(_ sender: Any) {
        self.vwSelectPayment.removeFromSuperview()
        self.vwError.isHidden = true
        self.scrollView.isHidden = true
        self.vwGetEmail.isHidden = false
        self.viewType = "Email"
        self.selectedMethod = "Paypal"
    }
    
    @IBAction func btnBankClicked(_ sender: Any) {
        self.vwSelectPayment.removeFromSuperview()
        self.vwError.isHidden = true
        self.scrollView.isHidden = true
        self.vwGetEmail.isHidden = true
        self.vwBankDetail.frame = CGRect(x: 0, y: 64, width: Screen.width, height: Screen.height - 64)
        self.view.addSubview(self.vwBankDetail)
        self.viewType = "BankDetail"
        self.selectedMethod = "Bank"
    }
    
    @IBAction func btnSubmtBankDetailClicked(_ sender: Any) {
        
    }
    
    //MARK:- API call get Country details
    func getCountryList() {
        let params = NSMutableDictionary()
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_COUNTRY_LIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(response != nil) {
                        let resDic = response as! NSDictionary
                        let dicRes = resDic.value(forKey: "country_list") as! NSArray
                        self.arrCountry = CountryModel().initiateCountryData(arrRes: dicRes)
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
    //MARK:- API call for save payment
    func savePayOutDetails()
    {
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        params.setValue(txtAddress1.text?.trim(), forKey: "address1")
        params.setValue(txtAddress2.text?.trim(), forKey: "address2")
        params.setValue(txtCity.text?.trim(), forKey: "city")
        params.setValue(txtstate.text?.trim(), forKey: "state")
        params.setValue(txtPostalCode.text?.trim(), forKey: "postal_code")
        params.setValue(txtCountry.text?.trim(), forKey: "country")
        params.setValue(txtEmail.text?.trim(), forKey: "paypal_email")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_ADD_PAYOUT_DETAILS, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil) {
                    self.lblError.text = error!
                    self.vwError.isHidden = false
                    self.vwGetEmail.isHidden = true
                }else{
                    if(response != nil){
                        ProfilePaymentListVC.isPaymentAdd = true
                        self.vwError.isHidden = true
                        self.vwGetEmail.isHidden = true
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    // MARK:- Localization Method
    func localization() {
        self.navTitle.text = payouts
        self.lblSubTitle.text = payouts
        self.btnSave.setTitle(submit, for: .normal)
        self.btnSubmit.setTitle(submit, for: .normal)
    }
    
}
