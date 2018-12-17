//
//  AdditionalPriceVC.swift
//  Arheb
//
//  Created on 03/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

class AdditionalPriceVC: UIViewController,UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var tblAdditionalPrices: UITableView!
    @IBOutlet var btnSave:UIButton!
    @IBOutlet var vwPicker:UIView!
    @IBOutlet var animatedLoader: FLAnimatedImageView!
    
    let arrTitle = ["Weekly Price","Monthly Price","Cleaning fee","Additional guests","For each guest after","Security deposit","Weekend pricing"]
    var strWeekPrice = ""
    var strMonthPrice = ""
    var strCleaningFee = ""
    var strAdditionGuestFee = ""
    var strAdditionGuestCount = ""
    var strSecurityDeposit = ""
    var strWeekendPrice = ""
    var strCurrency = "&#36;"
    var selectedCell : CurrencyCell!
    var arrValues = [String]()
    var arrDummyValues = [String]()
    var listModel : ListingModel!
    
    //MARK: - view LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        registerCell()
        strWeekPrice = ((listModel.weekly_price ) == "0" || (listModel.weekly_price ) == "") ? "" : listModel.weekly_price 
        strMonthPrice = ((listModel.monthly_price ) == "0" || (listModel.monthly_price ) == "") ? "" : listModel.monthly_price 
        strCleaningFee = ((listModel.cleaningFee ) == "0" || (listModel.cleaningFee ) == "") ? "" : listModel.cleaningFee 
        strAdditionGuestFee = ((listModel.additionGuestFee ) == "0" || (listModel.additionGuestFee ) == "") ? "" : listModel.additionGuestFee 
        strAdditionGuestCount = ((listModel.additionGuestCount ) == "0" || (listModel.additionGuestCount ) == "") ? "" : listModel.additionGuestCount
        strSecurityDeposit = ((listModel.securityDeposit ) == "0" || (listModel.securityDeposit ) == "") ? "" : listModel.securityDeposit
        strWeekendPrice = ((listModel.weekendPrice ) == "0" || (listModel.weekendPrice ) == "") ? "" : listModel.weekendPrice
        strCurrency = (listModel.currency_symbol ).characters.count > 0 ? (listModel.currency_symbol ).stringByDecodingHTMLEntities : strCurrency
        arrValues = [strWeekPrice,strMonthPrice,strCleaningFee,strAdditionGuestFee,strAdditionGuestCount,strSecurityDeposit,strWeekendPrice]
        arrDummyValues = arrValues
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        tblAdditionalPrices.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK: - TextField Delegate Method
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 4{
            vwPicker.isHidden = false
            vwPicker.removeFromSuperview()
            vwPicker.frame = CGRect(x: 0, y: 0, width: Screen.width, height: 150)
            textField.inputView = vwPicker
            var indexPath = IndexPath()
            indexPath = IndexPath(row: 1, section: 2)
            selectedCell = tblAdditionalPrices.cellForRow(at: indexPath) as! CurrencyCell
        }
    }
    
    //MARK: - Data Picker DataSource & Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 16
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format:(row==15) ? "%d+" : "%d",row+1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCell.txtCell?.text = String(format:"%d",row+1)
        strAdditionGuestCount = String(format:"%d",row+1)
        arrValues = [strWeekPrice,strMonthPrice,strCleaningFee,strAdditionGuestFee,strAdditionGuestCount,strSecurityDeposit,strWeekendPrice]
        checkSaveButtonStatus()
    }
    
    //MARK: - Tableview Delegate and Datasource Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblAdditionalPrices.frame.size.width) ,height: 30)
        let lblRoomName:UILabel = UILabel()
        lblRoomName.frame =  CGRect(x: 0, y:0, width: viewHolder.frame.size.width ,height: 30)
        if section == 0 {
            lblRoomName.text="Long-term prices"
        } else if section == 1 {
            lblRoomName.text="Additional Pricing Options"
        }
        viewHolder.backgroundColor = self.view.backgroundColor
        lblRoomName.textAlignment = NSTextAlignment.center
        lblRoomName.textColor = UIColor.darkGray
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 30
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (indexPath.row == 0) ? 50 :60
        } else {
            return (indexPath.row == 1) ? 50 :60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 2
        } else if section == 3 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        cell.lblCurrencySign.isHidden = false
        cell.txtCell.isHidden = false
        cell.lblCurrency.textColor = UIColor.darkGray
        cell.lblCurrency.font = cell.lblCurrency.font.withSize(15)
        cell.txtCell.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        cell.txtCell.delegate = self
        cell.lblCurrency.text = listModel.currency_code
        if indexPath.section == 0 {
            cell.lblCurrency?.text = arrTitle[indexPath.row]
            cell.txtCell.text = arrValues[indexPath.row]
            cell.txtCell.tag = indexPath.row
        } else if indexPath.section == 1 {
            cell.lblCurrency?.text = arrTitle[indexPath.row+2]
            cell.txtCell.text = arrValues[indexPath.row+2]
            cell.txtCell.tag = indexPath.row+2
        } else if indexPath.section == 2 {
            if indexPath.row == 1 {
                cell.lblCurrencySign.isHidden = true
            } else {
                cell.lblCurrencySign.isHidden = false
            }
            cell.lblCurrency?.text = arrTitle[indexPath.row+3]
            cell.txtCell.tag = indexPath.row+3
            cell.txtCell.text = arrValues[indexPath.row+3]
        } else if indexPath.section == 3 {
            cell.lblCurrency?.text = arrTitle[indexPath.row+5]
            cell.txtCell.tag = indexPath.row+5
            cell.txtCell.text = arrValues[indexPath.row+5]
        } else if indexPath.section == 4 {
            cell.lblCurrency?.text = arrTitle[indexPath.row+6]
            cell.txtCell.tag = indexPath.row+6
            cell.txtCell.text = arrValues[indexPath.row+6]
            cell.txtCell.returnKeyType = .done
        }
        return cell
    }
    
    //MARK: - Gesture Recognizer Method
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    //MARK: - API Call
    
    func saveInfo() {
        btnSave.isHidden = true
        animatedLoader.isHidden = false
        setDotLoader(animatedLoader)
        let param = NSMutableDictionary()
        param.setValue(listModel.room_id, forKey: UpdateLongTerms.roomId)
        param.setValue(strWeekPrice, forKey: UpdateLongTerms.weeklyPrice)
        param.setValue(strMonthPrice, forKey: UpdateLongTerms.monthlyPrice)
        param.setValue(strCleaningFee, forKey: UpdateLongTerms.additionalGuest)
        param.setValue(strSecurityDeposit, forKey: UpdateLongTerms.securityDeposite)
        param.setValue(strAdditionGuestCount, forKey: UpdateLongTerms.forEachGuest)
        param.setValue(strWeekendPrice, forKey: UpdateLongTerms.weekendPricing)
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_UPDATE_LONG_TERM_PRICE, params: param, isTokenRequired: true, forSuccessionBlock: { (res,error) in

            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    self.animatedLoader.isHidden = true
                    self.btnSave.isHidden = false
                    self.updateListModel()
                }
            }
        }) { (error) in
            self.animatedLoader.isHidden = true
            self.btnSave.isHidden = false
        }
    }
    
    //MARK: - Custom Method
    
    func checkSaveButtonStatus() {
        if arrValues == arrDummyValues {
            btnSave.isHidden = true
        } else {
            btnSave.isHidden = false
        }
    }
    
    func updateListModel() {
        self.listModel.weekly_price = strWeekPrice
        self.listModel.monthly_price = strMonthPrice
        self.listModel.cleaningFee = strCleaningFee
        self.listModel.additionGuestFee = strAdditionGuestFee
        self.listModel.additionGuestCount = strAdditionGuestCount
        self.listModel.securityDeposit = strSecurityDeposit
        self.listModel.weekendPrice = strWeekendPrice
        self.navigationController?.popViewController(animated: true)
    }
    
    func viewcustomization() {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        btnSave.setTitle(save, for: .normal)
    }
    
    func registerCell() {
        tblAdditionalPrices.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
    }
    
    //MARK: - IBAction Method(s)
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClicked(_ sender: UIButton) {
        let txtField:UITextField = self.view.viewWithTag(5) as! UITextField
        txtField.becomeFirstResponder()
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        saveInfo()
    }
    
    @IBAction private func textFieldDidChange(textField: UITextField) {
        if textField.tag == 0 {
            strWeekPrice = textField.text!        // WEEKLY PRICE
        } else if textField.tag == 1 {
            strMonthPrice = textField.text!     // MONTHLY PRICE
        } else if textField.tag == 2 {
            strCleaningFee = textField.text!    // Cleaning Fee
        } else if textField.tag == 3 {
            strAdditionGuestFee = textField.text!   // Additional Guest Fee
        } else if textField.tag == 5 {
            strSecurityDeposit = textField.text!    // Security Deposit
        } else if textField.tag == 6 {
            strWeekendPrice = textField.text!       // Week End Price
        }
        arrValues = [strWeekPrice,strMonthPrice,strCleaningFee,strAdditionGuestFee,strAdditionGuestCount,strSecurityDeposit,strWeekendPrice]
        checkSaveButtonStatus()
    }
    
    //MARK: - Memory Warning Method(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
