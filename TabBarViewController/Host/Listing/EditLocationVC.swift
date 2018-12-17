//
//  EditLocationVC.swift
//  Arheb
//
//  Created on 05/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

@objc protocol EditLocationDelegate {
    func saveLocationName(dicts : NSMutableDictionary, isSuccess: Bool)
    func goBack()
}

class EditLocationVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

    // MARK:- IBOutlet Method(s)
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtZip: UITextField!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtApt: UITextField!
    @IBOutlet var txtStreet: UITextField!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var vwpicker: UIView!
   
    var arrPickerData: NSArray!
    var strLatitude = ""
    var strLongitude = ""
    var strStreetName = ""
    var strAbtName = ""
    var strCityName = ""
    var strStateName = ""
    var strZipcode = ""
    var strCountryName = ""
    var googleModel: GoogleLocationModel!
    var delegate: EditLocationDelegate?
    var isFromFromEditing:Bool = false
    var dictLocation = NSMutableDictionary()
    
    // MARK:- View Method(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        vwpicker?.isHidden = true
        let path = Bundle.main.path(forResource: "country", ofType: "plist")
        arrPickerData = NSMutableArray(contentsOfFile: path!)!
        pickerView.delegate = self
        txtCountry.delegate = self
        txtZip.delegate = self
        txtState.delegate = self
        txtCity.delegate = self
        txtApt.delegate = self
        txtStreet.delegate = self

        self.localization()
        
        if isFromFromEditing {
            self.setEditField()
        } else {
            self.setAddressField()
        }
    }
    
    // MARK:- Custom Method(s)
    
    func setEditField() {
        let tempModel = GoogleLocationModel()
        tempModel.street_address = strStreetName
        tempModel.premise_name = strAbtName
        tempModel.city_name = strCityName
        tempModel.state_name = strStateName
        tempModel.postal_code = strZipcode
        tempModel.country_name = strCountryName
        googleModel = tempModel
        self.setAddressField()
    }
    
    func setAddressField() {
        txtStreet.text = googleModel.street_address
        txtApt.text = googleModel.premise_name
        txtCity.text = googleModel.city_name
        txtState.text = googleModel.state_name
        txtZip.text = googleModel.postal_code
        txtCountry.text = googleModel.country_name
        checkLoginButtonStatus()
        self.makeScroll(strSelection: strCountryName)
    }
    
    func checkLoginButtonStatus() {
        if (txtCity.text?.characters.count)!>0 && (txtState.text?.characters.count)!>0 && (txtCountry.text?.characters.count)!>0 {
            btnSave.setTitleColor(UIColor.red, for: .normal)
            btnSave.isUserInteractionEnabled = true
        } else {
            btnSave.isUserInteractionEnabled = false
            btnSave.setTitleColor(UIColor.darkGray, for: .normal)
        }
    }
    
    func validateLocation() {
        let addressString = String(format:"%@, %@, %@, %@, %@, %@",txtStreet.text!,txtApt.text!,txtCity.text!,txtState.text!,txtCountry.text!,txtZip.text!)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString, completionHandler: {(placemarks, error) -> Void in
            OperationQueue.main.addOperation {
                if placemarks == nil {
                    self.dictLocation["is_success"]   = "No"
                    self.goBack(isSuccess : false)
                    return
                }
                if (placemarks?.count)! > 0 {
                    let pm = (placemarks?[0])
                    if pm != nil {
                        self.stringPlaceMark(pm!)
                    }
                }
            }
        })
    }
    
    func stringPlaceMark(_ placemark: CLPlacemark) {
        var isSuccess = false
        dictLocation["is_success"]   = "No"
        if (placemark.thoroughfare != nil) {
            print(placemark.thoroughfare! as String)
            isSuccess = true
            dictLocation["is_success"]   = "Yes"
        }
        goBack(isSuccess : isSuccess)
    }
    
    func goBack(isSuccess : Bool) {
        dismiss(animated: true, completion: {
            self.delegate?.saveLocationName(dicts : self.dictLocation, isSuccess: isSuccess)
            ProgressHud.shared.Animation = false
        })
    }
    
    func makeScroll(strSelection: String) {
        if strSelection.characters.count == 0 {
            return
        }
        for i in 0 ..< arrPickerData.count {
            let str = ((arrPickerData[i] as AnyObject).value(forKey: "country_name") as! String)
            if str == strSelection {
                pickerView?.selectRow(i, inComponent: 0, animated: true)
            }
        }
    }
    
    // MARK:- IBOutlet method(s)
    
    @IBAction func textChange(_ sender: UITextField) {
        self.checkLoginButtonStatus()
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            self.delegate?.goBack()
        })
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        ProgressHud.shared.Animation = true
        dictLocation["room_id"]   = appDelegate?.strRoomID
        dictLocation["street_name"]    = txtStreet.text
        dictLocation["street_address"] = txtApt.text
        dictLocation["city"]           = txtCity.text
        dictLocation["state"]          = txtState.text
        dictLocation["zip"]            = txtZip.text
        dictLocation["country"]        = txtCountry.text
        dictLocation["latitude"]       = strLatitude
        dictLocation["longitude"]      = strLongitude
        dictLocation["is_success"]   = "No"
        validateLocation()
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        vwpicker.isHidden = true
    }
    
    // MARK:- TextField Delegate(s)
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtCountry {
            self.view.endEditing(true)
            textField.inputView = pickerView
            vwpicker?.isHidden = false
            pickerView?.reloadAllComponents()
            self.makeScroll(strSelection: strCountryName)
        } else {
            textField.inputView = nil
            vwpicker?.isHidden = true
            textField.becomeFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        } else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK:- PickerView Method(s)

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  ((arrPickerData[row] as AnyObject).value(forKey: "country_name") as! String)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        strCountryName = ((arrPickerData[row] as AnyObject).value(forKey: "country_name") as! String)
        txtCountry.text = ((arrPickerData[row] as AnyObject).value(forKey: "country_name") as! String)
    }
    
    // MARK:- Memory Warning(s)

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- Localization Method
    func localization() {
        self.txtStreet.placeholder = street
        self.txtApt.placeholder = aptBuilding
        self.txtZip.placeholder = zip
        self.txtCity.placeholder = city
        self.txtState.placeholder = state
        self.txtCountry.placeholder = country
        self.btnClose.setTitle(close, for: .normal)
        self.btnSave.setTitle(save, for: .normal)
        self.lblTitle.text = location
        self.btnCancel.setTitle(strcancel, for: .normal)
    }
}
