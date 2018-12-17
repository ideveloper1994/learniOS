//
//  PhoneNumberVC.swift
//  Arheb
//
//  Created on 6/19/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class PhoneNumberVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblIdType:UILabel!
    @IBOutlet weak var lblIdNumberOrPhone:UILabel!
    @IBOutlet weak var txtIdTypeOrCode:UITextField!
    @IBOutlet weak var txtNumber: NBTextField!
    @IBOutlet weak var btnSkip:UIButton!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var vwPicker:UIView!
    @IBOutlet weak var imgTickMark:UIImageView!
    @IBOutlet weak var bottomNxtBtn: NSLayoutConstraint!
    @IBOutlet var ConstVwMainLeading: NSLayoutConstraint!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var vwMain: UIView!
    @IBOutlet var vwError: UIView!
    @IBOutlet var lblError: UILabel!
    
    var isVerification:Bool!
    var isSkip:Bool!
    var strIdType:String = "National ID"
    var strPhoneCode = ""
    var arrCountry = [CountryModel]()
    var arrIdTypes = [GovernmentModel]()
    var phoneCode = ""
    var proofId = ""
    var phoneUtil:NBPhoneNumberUtil = NBPhoneNumberUtil()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BirthdayVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BirthdayVC.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        if(isVerification) {
            getCountryList()
        }else {
            getIdTypeList()
        }
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
        self.txtIdTypeOrCode.delegate = self
        btnSkip.isHidden = isSkip == true ? false : true
        if isVerification{
            lblIdType.isHidden = false
            lblIdType.text = countryCodeType
            lblTitle.text = headerPhoneNumber
            lblIdNumberOrPhone.text = phone
            if((appDelegate?.phoneNoDetail.count)! > 0){
                //                txtIdTypeOrCode.text = ""
                txtNumber.text = appDelegate!.phoneNoDetail[0].phone_number
                self.phoneCode = appDelegate!.phoneNoDetail[0].phone_code
            }
        }else{
            lblIdType.isHidden = false
            lblTitle.text = headerIdProof
            lblIdType.text = idType
            lblIdNumberOrPhone.text = idNumber
            proofId = GETVALUE("government_id_type")
            txtIdTypeOrCode.text = GETVALUE("government_id_name")
            txtNumber.text = GETVALUE("government_id")
        }
        self.hideErrorView()
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
        if(isVerification){
            self.addPhoneList()
        }else{
            self.addIdTypeList()
        }
    }
    
    @IBAction func btnSkipClicked(_ sender: Any) {
        if(isVerification) {
            let phoneVC = PhoneNumberVC(nibName: "PhoneNumberVC", bundle: nil)
            phoneVC.isVerification = false
            phoneVC.isSkip = true
            self.navigationController?.pushViewController(phoneVC, animated: true)
        }else {
            let upVC = PhotoUploadVC(nibName: "PhotoUploadVC", bundle: nil)
            self.navigationController?.pushViewController(upVC, animated: true)
            
            //            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        txtIdTypeOrCode.text = strIdType
        txtNumber.becomeFirstResponder()
        checkStatus()
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
    
    //MARK: - Pickeview Delegate  Method(s)
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(isVerification){
            return arrCountry.count;
        }
        return arrIdTypes.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(isVerification){
            let obj = self.arrCountry[row]
            let str = "+" + obj.phone_code + " " + "(" + obj.country_name + ")"
            return str
        }
        return  String(describing: arrIdTypes[row].name)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(isVerification){
            if(arrCountry.count >= row) {
                let obj = self.arrCountry[row]
                let str = "+" + obj.phone_code + " " + "(" + obj.country_name + ")"
                self.strPhoneCode = str
                self.phoneCode = obj.phone_code
                txtNumber.applyRegioncode(obj.country_code)
                txtIdTypeOrCode.text = str
            }
        }else{
            if(arrIdTypes.count >= row) {
                proofId = arrIdTypes[row].id
                strIdType = arrIdTypes[row].name
                txtIdTypeOrCode.text = strIdType
            }
        }
    }
    
    
    //MARK: - TextField Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1{
            vwPicker.isHidden = false
            vwPicker.removeFromSuperview()
            vwPicker.frame = CGRect(x: 0, y: 0, width: Screen.width, height: 150)
            textField.inputView = vwPicker
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.tag == 2){
            textField.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    
    @IBAction func textChange(_ sender: UITextField) {
        self.hideErrorView()
        checkStatus()
    }
    
    //MARK: - Custom Method
    func checkStatus(){
        if !isVerification{
            if self.txtIdTypeOrCode.text! == "National ID" || self.txtIdTypeOrCode.text! == "Iqama"{
                if (txtNumber.text!.trim().characters.count) == 10 && !(txtIdTypeOrCode.text!.isEmptyString()) {
                    enableView()
                }else{
                    disableView()
                }
            }
            else if(!(txtIdTypeOrCode.text?.isEmptyString())! && !(txtNumber.text?.isEmptyString())!){
                enableView()
            }else{
                disableView()
            }
        }else{
            if(!(txtIdTypeOrCode.text?.isEmptyString())! && !(txtNumber.text?.isEmptyString())!){
                enableView()
            }else{
                disableView()
            }
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
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- API call get Country details
    func getCountryList() {
        let params = NSMutableDictionary()
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_COUNTRY_LIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil) {
                    //                    showToastMessage(error!)
                }else{
                    if(response != nil) {
                        let resDic = response as! NSDictionary
                        let dicRes = resDic.value(forKey: "country_list") as! NSArray
                        self.arrCountry = CountryModel().initiateCountryData(arrRes: dicRes)
                        self.pickerView.reloadAllComponents()
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
    
    //MARK:- API call get Country details
    func getIdTypeList() {
        let params = NSMutableDictionary()
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_GOVERNMMENT_TYPE, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    //                    showToastMessage(error!)
                }else{
                    if(response != nil) {
                        let resDic = response as! NSDictionary
                        let dicRes = resDic.value(forKey: "government_id_type_list") as! NSArray
                        self.arrIdTypes = GovernmentModel().initiateCountryData(arrRes: dicRes)
                        self.pickerView.reloadAllComponents()
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
    //MARK:- API call get Country details
    func addIdTypeList() {
        let param = NSMutableDictionary()
        param.setValue(proofId, forKey: "government_id_type")
        param.setValue(txtNumber.text?.trim(), forKey: "government_id")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_VERIFY_GOVERNMMENT_TYPE, params: param, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil) {
                    //                    showToastMessage(error!)
                    self.vwError.isHidden = false
                    self.showErrorMsg(message: error!)
                }else {
                    if(response != nil) {
                        let resDic = response as! NSDictionary   //government_id  government_id_type
                        let objLogin = getUserDetails()
                        if let government_id = resDic.value(forKey: "government_id") as? String {
                            objLogin?.government_id = government_id
                            STOREVALUE(value: government_id, keyname: "government_id")
                        }
                        if let government_id_type = resDic.value(forKey: "government_id_type") as? String {
                            objLogin?.government_id_type = government_id_type
                            STOREVALUE(value: government_id_type, keyname: "government_id_type")
                        }
                        
                        objLogin?.government_id_name = (self.txtNumber.text?.trim())!
                        setUserDetails(user: objLogin!)
                        STOREVALUE(value: (self.txtIdTypeOrCode.text?.trim())!, keyname: "government_id_name")
                        
                        if(appDelegate?.isFromProfilePage)!{
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            let upVC = PhotoUploadVC(nibName: "PhotoUploadVC", bundle: nil)
                            self.navigationController?.pushViewController(upVC, animated: true)
                            //                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.vwError.isHidden = false
                self.showErrorMsg(message: invalidPhoneNumberOrcode)
            }
        }
    }
    
    //MARK:- API call get Country details
    func addPhoneList() {
        let params = NSMutableDictionary()
        params.setValue(self.phoneCode, forKey: "phone_code")
        let phoneNo = txtNumber.text?.trim().replacingOccurrences(of: " ", with: "")
        params.setValue(phoneNo, forKey: "phone_number")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_UPDATE_PHONE_NUMBER, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    //                    showToastMessage(error!)
                    self.vwError.isHidden = false
                    self.showErrorMsg(message: error!)
                }else{
                    if(response != nil) {
                        appDelegate?.getPhoneNumbers()
                        let resDic = response as! NSDictionary
                        let phoneVC = PhoneVerificationVC(nibName: "PhoneVerificationVC", bundle: nil)
                        self.navigationController?.pushViewController(phoneVC, animated: true)
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
    
    
}
