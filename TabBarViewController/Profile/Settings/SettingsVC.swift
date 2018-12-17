//
//  SettingsVC.swift
//  Arheb
//
//  Created on 6/1/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, currencyListDelegate {
    
    @IBOutlet var tblSettings: UITableView!
    @IBOutlet var vwNav: UIView!
    var arrSettings: [String] = []
    var strCurrency : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
        self.setDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewcustomization()
        self.setCurrentCurrency()
        self.tblSettings.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Customize the view
    func viewcustomization(){
        self.navigationController?.navigationBar.isHidden = true
        self.tblSettings.tableFooterView = UIView()
        vwNav.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    //MARK:- Register Profile table
    func registerTableView() {
        tblSettings.dataSource = self
        tblSettings.delegate = self
        tblSettings.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
    }
    
    func setDetails() {
        
        arrSettings.append(currency)
        arrSettings.append(language)
        arrSettings.append(paymentMethod)
        
        let hostOrTravel = GETVALUE(UserDefaultKey.kHostorTravel)
        if(hostOrTravel == HostOrTravel.host){
            arrSettings.append(wallet)
            arrSettings.append(transactionHistory)
        }
        
        arrSettings.append(termsNService)
        arrSettings.append(version)
        arrSettings.append(logout)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSettings.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.lblTitle.text = arrSettings[indexPath.row]
        if(arrSettings[indexPath.row] == currency){
            cell.lblRightTitle.isHidden = false
            cell.imgOptions.isHidden = true
            cell.lblRightTitle.text = strCurrency
            cell.lblRightTitle.textColor = UIColor(red: 255/255, green: 86/255, blue: 84/255, alpha: 1)
        }else if(arrSettings[indexPath.row] == language){
            cell.lblRightTitle.isHidden = false
            cell.imgOptions.isHidden = true
            cell.lblRightTitle.text = GETVALUE(USER_LANGUAGE)
            cell.lblRightTitle.textColor = UIColor(red: 255/255, green: 86/255, blue: 84/255, alpha: 1)
        }else if(arrSettings[indexPath.row] == version){
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                 cell.lblTitle.text = arrSettings[indexPath.row] + version
            }
            cell.imgOptions.isHidden = true
            cell.lblRightTitle.isHidden = true
        }else{
            cell.imgOptions.isHidden = false
            cell.lblRightTitle.isHidden = true
        }
        return cell
    }
    
    //MARK: Perform all navigation from the options
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(arrSettings[indexPath.row] == currency) {
            let currencyVC = ProfileCurrencyVC(nibName: "ProfileCurrencyVC", bundle: nil)
            let strCurr = strCurrency.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").components(separatedBy: " ")
            currencyVC.strCurrentCurrency = String(format: "%@ | %@",strCurr[0],strCurr[1])
            currencyVC.delegate = self
            currencyVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(currencyVC, animated: true)
        }else if(arrSettings[indexPath.row] == language) {
            let languageVC = ProfileLanguageVC(nibName: "ProfileLanguageVC", bundle: nil)
            languageVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(languageVC, animated: true)
        }else if(arrSettings[indexPath.row] == paymentMethod) {
            let payoutVC = ProfilePaymentListVC(nibName: "ProfilePaymentListVC", bundle: nil)
            self.navigationController?.pushViewController(payoutVC, animated: true)
        }else if(arrSettings[indexPath.row] == termsNService) {
            let objLoadWebView = LoadWebView(nibName: "LoadWebView", bundle: nil)
            objLoadWebView.hidesBottomBarWhenPushed = true
            objLoadWebView.strPageTitle = termsNService
            objLoadWebView.strWebUrl = webServerUrl + URL_TERMS_OF_SERVICE
            self.navigationController?.pushViewController(objLoadWebView, animated: true)
        }else if(arrSettings[indexPath.row] == version) {
            
        }else if(arrSettings[indexPath.row] == logout) {
            showPrompts()
        }else if(arrSettings[indexPath.row] == transactionHistory) {
            
        }else if(arrSettings[indexPath.row] == wallet) {
            let walletVC = WalletVC(nibName: "WalletVC", bundle: nil)
            self.navigationController?.pushViewController(walletVC, animated: true)
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- ActionSheet
    func showPrompts() {
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: logout, style: UIAlertActionStyle.destructive, handler: { (action) in
            onLogout()
            
            let hostVC = ArhebTabbar()
            appDelegate?.window?.rootViewController = hostVC
        }))
        actionSheet.addAction(UIAlertAction.init(title: cancel, style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK:- Custom Method(s)
    
    func setCurrentCurrency() {
        let userCurrency = UserDefaults.standard.object(forKey: USER_CURRENCY) as? NSString
        if (userCurrency != nil && userCurrency != "") {
            strCurrency = userCurrency! as String
        } else {
            strCurrency = "USD ($)"
        }
    }
    
    // MARK:- Currency Delegate Method(s)
    
    func onCurrencyChanged(currency: String) {
        let str = currency.components(separatedBy: " | ")
        strCurrency = String(format:"%@ (%@)", str[0],str[1])
        STOREVALUE(value: strCurrency, keyname: USER_CURRENCY)
        let indexPath = IndexPath(row: 1, section: 0)
        tblSettings.reloadRows(at: [indexPath], with: .none)
        tblSettings.reloadData()
    }
}
