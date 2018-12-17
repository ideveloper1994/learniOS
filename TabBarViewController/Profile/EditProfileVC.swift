//
//  EditProfileVC.swift
//  Arheb
//
//  Created on 6/1/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import AFNetworking

class EditProfileVC: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate  {
    
    @IBOutlet var lblLastName: UILabel!
    @IBOutlet var lblBirthDate: UILabel!
    @IBOutlet var lblFirstName: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var lblAboutMe: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtAboutme: UITextView!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtGender: UITextField!
    @IBOutlet var txtDatePicker: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtLocation: UITextField!
    @IBOutlet var txtSchool: UITextField!
    @IBOutlet var txtWork: UITextField!
    @IBOutlet var imgUserThumb: UIImageView!
    @IBOutlet var btnCamera: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var constVwMainHeight: NSLayoutConstraint!
    @IBOutlet var constVwAboutHeight: NSLayoutConstraint!
    @IBOutlet var lblWork: UILabel!
    @IBOutlet var lblSchool: UILabel!
    @IBOutlet var constvwOuterHeight: NSLayoutConstraint!
    
    var genderPickerView = UIPickerView()
    var imagePicker = UIImagePickerController()
    let dateFormatter = DateFormatter()
    var arrPickerData : [String] = []
    static var isImageChange = false
    static var objUser: UserModel = UserModel()
    static var profileImg: UIImage!
    static var userThumbURL = ""
    var strGender = ""
    
    @IBOutlet var vwError: UIView!
    @IBOutlet var lblError: UILabel!
    
    @IBOutlet var imgIdProof: UIImageView!
    
    //ID and phone
    
    @IBOutlet var lblPhone: UILabel!
    
    @IBOutlet var lblPhoneNumber: UILabel!
    
    @IBOutlet var imgPhone: UIImageView!
    
    @IBOutlet var lblIdProof: UILabel!
    
    @IBOutlet var lblIdNumber: UILabel!
    
    @IBOutlet var btnAddPhone: UIButton!
    
    @IBOutlet var btnAddIdProof: UIButton!
    
    @IBOutlet var nsPhoneHeight: NSLayoutConstraint!
    
    @IBOutlet var nsIdProofHeight: NSLayoutConstraint!
    
    @IBOutlet var lblOptional: UILabel!
    
    @IBOutlet var lblRequired: UILabel!
    
    var arrPhoneNo = [PhoneNoModel]()
    
    // MARK: - UIViewController method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCustomization()
        self.imgUserThumb?.sd_setImage(with: URL(string: EditProfileVC.objUser.large_image_url)!, placeholderImage:UIImage(named:""))
        self.localization()
        
    }
    
    func checkSaveButtonStatus(){
        if (!txtFirstName.text!.isEmptyString() && !txtLastName.text!.isEmptyString() && !txtGender.text!.isEmptyString() && !txtDatePicker.text!.isEmptyString() && !txtEmail.text!.isEmptyString()){
            if !isValidEmail(testStr: txtEmail.text!){
                btnSave.isHidden = true
            }else{
                btnSave.isHidden = false
            }
        }else{
            btnSave.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        assignValues()
        checkSaveButtonStatus()
        //        self.getPhoneNumbers()
        setPhoneDetail()
    }
    
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Customize the view
    func viewCustomization(){
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
//        dateFormatter.dateFormat = "dd-MM-yyyy"
           dateFormatter.dateFormat = "yyyy-MM-dd"
        self.arrPickerData = [notSpecified, male, female, other]
        txtGender.inputView = genderPickerView
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtDatePicker.delegate = self
        txtEmail.delegate = self
        txtGender.delegate = self
        txtLocation.delegate = self
        txtWork.delegate = self
        txtSchool.delegate = self
    }
    
    func assignValues() {
        txtFirstName.text = EditProfileVC.objUser.first_name
        txtLastName.text = EditProfileVC.objUser.last_name
        txtAboutme.text = EditProfileVC.objUser.about_me
        if(EditProfileVC.objUser.gender != "") {
            txtGender.text = EditProfileVC.objUser.gender
        }
        txtLocation.text = EditProfileVC.objUser.user_location
        txtSchool.text = EditProfileVC.objUser.school
        txtEmail.text = EditProfileVC.objUser.email
        txtWork.text = EditProfileVC.objUser.work
        txtDatePicker.text = EditProfileVC.objUser.dob
        
        let height = heightForView(text: txtAboutme.text, font: txtAboutme.font!, width: txtAboutme.frame.size.width)
        constVwAboutHeight.constant = height + 10
        constvwOuterHeight.constant = constVwAboutHeight.constant + 60
        constVwMainHeight.constant = constVwMainHeight.constant - 100 + constvwOuterHeight.constant
        
    }
    
    // MARK:- IBActions
    @IBAction func onAddPhotoTapped(_ sender: Any) {
        self.view.endEditing(true)
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: clickPhoto, style: UIAlertActionStyle.default, handler: { (action) in
            self.takePhoto()
        }))
        actionSheet.addAction(UIAlertAction.init(title: selectPhoto, style: UIAlertActionStyle.default, handler: { (action) in
            self.choosePhoto()
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Save profile detail- validate the fields and display tost message
    @IBAction func btnSaveClicked(_ sender: Any) {
        if(EditProfileVC.isImageChange){
            self.uploadImage()
        }else{
            self.editProfile()
        }
    }
    
    @IBAction func btnEditClicked(_ sender: Any) {
        let aboutVC = AboutMeVC(nibName: "AboutMeVC", bundle: nil)
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    @IBAction func btnPhoneClicked(_ sender: Any) {
        if(appDelegate!.phoneNoDetail[0].status == "Pending"){
            let verifyVc = PhoneVerificationVC(nibName: "PhoneVerificationVC", bundle: nil)
            self.navigationController?.pushViewController(verifyVc, animated: true)
        }
    }
    
    @IBAction func btnIdProofClicked(_ sender: Any) {
        appDelegate?.isFromProfilePage = true
        let phoneVC = PhoneNumberVC(nibName: "PhoneNumberVC", bundle: nil)
        phoneVC.isVerification = false
        phoneVC.isSkip = false
        self.navigationController?.pushViewController(phoneVC, animated: true)
    }
    
    @IBAction func btnAddIdClicked(_ sender: Any) {
        appDelegate?.isFromProfilePage = true
        let phoneVC = PhoneNumberVC(nibName: "PhoneNumberVC", bundle: nil)
        phoneVC.isVerification = false
        phoneVC.isSkip = false
        self.navigationController?.pushViewController(phoneVC, animated: true)
    }
    
    @IBAction func btnAddPhoneClicked(_ sender: Any) {
        appDelegate?.isFromProfilePage = true
        let phoneVC = PhoneNumberVC(nibName: "PhoneNumberVC", bundle: nil)
        phoneVC.isVerification = true
        phoneVC.isSkip = false
        self.navigationController?.pushViewController(phoneVC, animated: true)
    }
    
    
    // MARK: - Custom method(s)
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            let settingsActionSheet: UIAlertController = UIAlertController(title:"Error", message:noCamera, preferredStyle:UIAlertControllerStyle.alert)
            settingsActionSheet.addAction(UIAlertAction(title:ok, style:UIAlertActionStyle.cancel, handler:nil))
            present(settingsActionSheet, animated:true, completion:nil)
        }
    }
    
    func choosePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func doneButton(sender:UIButton){
        checkSaveButtonStatus()
        txtDatePicker.resignFirstResponder()
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        checkSaveButtonStatus()
        txtDatePicker.text = dateFormatter.string(from: sender.date)
    }
    
    func doneGenderButton(sender:UIButton){
        self.txtGender.text = self.strGender
        txtGender.resignFirstResponder()
    }
    
    // MARK: - UIImagePickerController delegate method(s)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            self.imgUserThumb.image = (info[UIImagePickerControllerOriginalImage] as? UIImage)
            EditProfileVC.isImageChange = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: saveFailed,
                                          message: failedToSave,
                                          preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                         completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextField Action Method(s)
    @IBAction func dateTextInputClicked(_ sender: UITextField) {
        self.vwError.isHidden = true
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        //        let date = Date()
        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        let datePickerView  : UIDatePicker = UIDatePicker(frame:CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 200))
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        datePickerView.maximumDate = date
        inputView.addSubview(datePickerView)
        let doneButton = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(self.doneButton), for: UIControlEvents.touchUpInside)
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker), for: .valueChanged)
    }
    
    @IBAction func genderTextInputClick(_ sender: UITextField) {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        genderPickerView = UIPickerView(frame:CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 200))
        inputView.addSubview(genderPickerView)
        let doneButton = UIButton(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(self.doneGenderButton), for: UIControlEvents.touchUpInside) // set button click event
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        
        sender.inputView = inputView
    }
    
    //MARK: - Textfield delegate methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtFirstName){
            txtLastName.becomeFirstResponder()
        }else if(textField == txtLastName){
            txtGender.becomeFirstResponder()
        }else if(textField == txtGender){
            txtDatePicker.becomeFirstResponder()
        }else if(textField == txtDatePicker){
            txtEmail.becomeFirstResponder()
        }else if(textField == txtEmail){
            txtLocation.becomeFirstResponder()
        }else if(textField == txtLocation){
            txtSchool.becomeFirstResponder()
        }else if(textField == txtSchool){
            txtWork.becomeFirstResponder()
        }else if(textField == txtWork){
            textField.resignFirstResponder()
        }
        checkSaveButtonStatus()
        return true
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        self.vwError.isHidden = true
        if(sender.tag == 11){
            txtFirstName.text = sender.text!
        }else if(sender.tag == 12){
            txtLastName.text = sender.text!
        }else if(sender.tag == 14){
            txtGender.text = ""
        }else if(sender.tag == 15){
            txtDatePicker.text = ""
        }else if(sender.tag == 16){
            txtEmail.text = sender.text!
        }else if(sender.tag == 17){
            txtLocation.text = sender.text!
        }else if(sender.tag == 18){
            txtSchool.text = sender.text!
        }else if(sender.tag == 19){
            txtWork.text = sender.text!
        }
        checkSaveButtonStatus()
    }
    
    // MARK: - UIPickerView Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.strGender = arrPickerData[row]
        checkSaveButtonStatus()
    }
    
    //MARK:- API Call
    func editProfile() {
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        let dateString = txtDatePicker.text?.trim()
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.date(from:dateString!)
        let formatedDate = dateFormatter.string(from: strDate!)
        
        params.setValue(formatedDate, forKey: Signup.dob)
        
        params.setValue(txtFirstName.text?.trim(), forKey: Signup.firstName)
        params.setValue(txtLastName.text?.trim(), forKey: Signup.lastName)
        if(txtAboutme.text?.trim() != ""){
            params.setValue(txtAboutme.text?.trim(), forKey: Signup.aboutMe)
        }
        
        if(txtLocation.text?.trim() != ""){
            params.setValue(txtLocation.text?.trim(), forKey: Signup.location)
        }
        
        if(txtSchool.text?.trim() != ""){
            params.setValue(txtSchool.text?.trim(), forKey: Signup.school)
        }
        
        if(txtWork.text?.trim() != ""){
            params.setValue(txtWork.text?.trim(), forKey: Signup.work)
        }
        
        if(EditProfileVC.userThumbURL != "" && EditProfileVC.isImageChange){
            params.setValue(EditProfileVC.userThumbURL.trim(), forKey: Signup.urlThumb)
        }
        
        params.setValue(txtGender.text?.trim(), forKey: Signup.gender)
        
//        params.setValue(txtEmail.text?.trim(), forKey: Signup.emailId)
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_EDIT_PROFILE, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    self.vwError.isHidden = false
                    self.lblError.text = error!
                }else{
                    ProfileDetailVC.isProfileEdited = true
                    self.navigationController?.popViewController(animated: true)
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            OperationQueue.main.addOperation {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    //Upload Profile Image
    func uploadImage() {
        ProgressHud.shared.Animation = true
        if((self.imgUserThumb.image) != nil){
            let params = NSMutableDictionary()
            if KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken) != nil{
                let authToken = KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken)
                params.setValue(authToken, forKey: "token")
            }
            let manager = AFHTTPSessionManager()
            let data = UIImageJPEGRepresentation(self.imgUserThumb.image!, 50)! as Data
            manager.post(baseUrl+API_UPLOAD_PROFILE_IMAGE, parameters: params, constructingBodyWith: { (_ formData: AFMultipartFormData) in
                formData.appendPart(withFileData: data, name: "image", fileName: "tmp.jpg", mimeType: "image/jpeg")
            }, progress: { (process) in
                //print(process)
            }, success: { (task, response) in
                DispatchQueue.main.async {
                    let res = response as! NSDictionary
                    let generalModel = GeneralModel().addResponseToModel(res: res)
                    if(generalModel.status_code == "1"){
                        if(res.value(forKey: "normal_image_url") != nil){
                            EditProfileVC.userThumbURL = res.value(forKey: "normal_image_url") as! String
                            self.editProfile()
                        }
                        //normal_image_url  large_image_url   small_image_url
                    }else{
                        //Fail to upload image
                    }
                }
            }, failure: { (task, error) in
                ProgressHud.shared.Animation = false
                OperationQueue.main.addOperation {
                    //Fail to upload image
                }
            })
        }
    }
    //
    //    //Get hpone Numbers
    //    func getPhoneNumbers() {
    //        let params = NSMutableDictionary()
    //        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_GET_PHONE_NUMBER, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
    //            DispatchQueue.main.async {
    //                if(error != nil) {
    //
    //                }else{
    //                    if(response != nil) {
    //                        let resDic = response as! NSDictionary
    //                        let dicRes = resDic.value(forKey: "users_phone_numbers") as! NSArray
    //                        self.arrPhoneNo = PhoneNoModel().initiatePhoneData(arrRes: dicRes)
    //                        self.setPhoneDetail()
    //                    }
    //                }
    //            }
    //        }) { (error) in
    //            DispatchQueue.main.async {
    //            }
    //        }
    //    }
    
    //Set phone detail
    func setPhoneDetail() {
        if(appDelegate?.phoneNoDetail.count == 0){
            self.btnAddPhone.isHidden = false
            nsPhoneHeight.constant = 65
        }else{
            self.btnAddPhone.isHidden = true
            nsPhoneHeight.constant = 99
            self.lblPhoneNumber.text = appDelegate!.phoneNoDetail[0].phone_number_full
            if(appDelegate!.phoneNoDetail[0].status == "Pending") {
                self.imgPhone.isHidden = true
            }else {
                self.imgPhone.isHidden = false
                self.imgPhone.setTintColor(color: AppColor.mainColor)
            }
            
        }
        
        let government_id = GETVALUE("government_id")
        let objUser = getUserDetails()
        if(government_id != "") {
            self.btnAddIdProof.isHidden = true
            nsIdProofHeight.constant = 99
//            self.lblIdNumber.text = (objUser?.government_id_type)! + " (" + (objUser?.government_id_name)! + ")"
            
            self.lblIdNumber.text = GETVALUE("government_id")  + " (" + GETVALUE("government_id_name") + ")"
            
            self.imgIdProof.isHidden = false
            
        }else{
            self.btnAddIdProof.isHidden = false
            nsIdProofHeight.constant = 65
            self.imgIdProof.isHidden = true
        }
        
    }
    
    // MARK:- Localization Method
    func localization() {
        self.lblTitle.text = updateProfile
        self.txtFirstName.placeholder = enterFirstName
        self.txtLastName.placeholder = enterLastName
        self.txtLocation.placeholder = enterLocation
        self.btnEdit.setTitle(edit, for: .normal)
        self.btnSave.setTitle(save, for: .normal)
        self.lblAboutMe.text = aboutMe
        self.lblGender.text = gender
        self.txtGender.placeholder = selectGender
        self.lblBirthDate.text = birthDate
        self.txtDatePicker.placeholder = selectBirthDate
        self.lblEmail.text = email
        self.txtEmail.placeholder = enterEmail
        self.lblLocation.text = location
        self.lblSchool.text = school
        self.txtSchool.placeholder = enterSchool
        self.lblWork.text = work
        self.txtWork.placeholder = enterWork
        self.lblFirstName.text = sFirstName
        self.lblLastName.text = sLastName
        self.lblIdProof.text = idProof
        self.lblPhone.text = phone
        self.lblRequired.text = requiredField
        self.lblOptional.text = optionalField
    }
    
    
}
