//
//  FilterAmenities.swift
//  Arheb
//
//  Created on 06/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class FilterAmenities: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var tableAmenities: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var lbAmenities: UILabel!
    
    var arrAminities = [AminitiesModel]()
    var arrSelectedItems: NSMutableArray = NSMutableArray()
    var arrCountryData : NSArray = NSArray()
    
    var selectedCountry:String = ""
    // MARK: - UIViewController method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.callCountryAPI()
        if(self.arrAminities.count == 0){
            lbAmenities.text = "Select Country"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setValues()
    }
    
    func registerCell(){
        self.tableAmenities.delegate = self
        self.tableAmenities.dataSource = self
        let nib = UINib(nibName: "AmenitiesCell", bundle: nil)
        self.tableAmenities.register(nib, forCellReuseIdentifier: "cell")
        tableAmenities.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
        self.tableAmenities.tableHeaderView = tblHeaderView
    }
    
    func setValues() {
        self.navigationController?.navigationBar.isHidden = true
        self.arrSelectedItems = FilterVC.arrSelectedAmenities
        tableAmenities.reloadData()
        self.checkSaveBtnStatus()
    }
    
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate Method(s)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.arrAminities.count == 0){
            return self.arrCountryData.count
        }
        return arrAminities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.arrAminities.count == 0) {
            let cell:AmenitiesCell = self.tableAmenities.dequeueReusableCell(withIdentifier: "cell") as! AmenitiesCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lblName.text = (arrCountryData[indexPath.row] as AnyObject).value(forKey: "country_name") as! String
            let strId = (arrCountryData[indexPath.row] as AnyObject).value(forKey: "country_id") as! Int
            if arrSelectedItems.contains(String(format:"%d",strId)) {
                cell.lblName?.textColor = UIColor.white
            } else {
                cell.lblName?.textColor = UIColor.darkGray
            }
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lblTickmark.isHidden = false
            cell.txtCell.isHidden = true
            let objAminity = self.arrAminities[indexPath.row]
            cell.lblCurrency.text = objAminity.aminity_name
            let strId = objAminity.aminity_id
            cell.lblTickmark.text = (arrSelectedItems.contains(strId)) ? "9" : ""
            cell.lblCurrency.textColor = UIColor.darkGray
            cell.lblCurrency.font = cell.lblCurrency.font.withSize(15)
             //cell.lblTickmark.layer.borderColor = UIColor.red.cgColor
            cell.lblTickmark.layer.borderColor = AppColor.mainColor.cgColor
            cell.lblTickmark.textColor = AppColor.mainColor
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.arrAminities.count == 0){
            let strId = (arrCountryData[indexPath.row] as AnyObject).value(forKey: "country_id") as! Int
            arrSelectedItems.removeAllObjects()
            arrSelectedItems.add(String(format:"%d",strId))
            self.checkSaveBtnStatus()
            
            selectedCountry = (arrCountryData[indexPath.row] as AnyObject).value(forKey: "country_name") as! String
            
            let  userDefaults = UserDefaults.standard
            userDefaults.set(selectedCountry, forKey: "countryname")
            userDefaults.synchronize()
            tableAmenities.reloadData()
            
        }else{
            let objAminity = self.arrAminities[indexPath.row]
            let strId = Int(objAminity.aminity_id)
            if arrSelectedItems.contains(String(format:"%d",strId!)) {
                arrSelectedItems.remove(String(format:"%d",strId!))
            } else {
                arrSelectedItems.add(String(format:"%d",strId!))
            }
            self.checkSaveBtnStatus()
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            tableAmenities.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    // MARK: - Custom Method(s)
    func checkSaveBtnStatus() {
        btnNext.alpha = arrSelectedItems.count > 0 ? 1.0 : 0.5
        btnNext.isUserInteractionEnabled = arrSelectedItems.count > 0 ? true : false
    }
    
    // MARK: - UIButton Method(s)
    @IBAction func gotoCardSelection(_ sender: UIButton) {
        if(self.arrAminities.count == 0){
            let vc = MakePaymentVC(nibName: "MakePaymentVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            FilterVC.arrSelectedAmenities = self.arrSelectedItems
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        if(self.arrAminities.count == 0){
            self.navigationController?.popViewController(animated: true)
        }else{
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func callCountryAPI()
    {
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_COUNTRY_LIST, params: NSMutableDictionary(), isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if response != nil {
                        let result = response as! NSDictionary
                        self.arrCountryData = result.value(forKey: "country_list") as! NSArray
                        self.tableAmenities.reloadData()
                    }
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            ProgressHud.shared.Animation = false
        }
    }
    
    
}
