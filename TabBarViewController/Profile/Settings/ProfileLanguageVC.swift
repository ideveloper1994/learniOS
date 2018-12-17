//
//  CurrencyVC.swift
//  Arheb
//
//  Created on 6/2/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit


class ProfileLanguageVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tblLanguage: UITableView!
    @IBOutlet var btnSave: UIButton!
    
    var arrLanguage : NSMutableArray = NSMutableArray()
    var selectedLanguage = ""
    var selectedRow = 0
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblLanguage.register(UINib(nibName: "ProfileCurrencyCell", bundle: nil), forCellReuseIdentifier: "ProfileCurrencyCell")
        self.selectedLanguage = GETVALUE(USER_LANGUAGE)
        arrLanguage.add(english)
        arrLanguage.add(arabic)
        btnSave.layer.cornerRadius = 5.0
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Table View Method(s)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCurrencyCell", for: indexPath) as! ProfileCurrencyCell
        let language = self.arrLanguage[indexPath.row] as? String
        if(language == selectedLanguage) {
            self.selectedRow = indexPath.row
        }
        cell.imgTickMark?.isHidden = (language == selectedLanguage) ? false : true
        cell.imgTickMark?.image = UIImage(named: "check_red_active.png")
        cell.lblCurrency.text = language
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLanguage = self.arrLanguage[indexPath.row] as! String
        tblLanguage.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func onSaveTapped(_ sender:UIButton!) {
        STOREVALUE(value: self.selectedLanguage.trim(), keyname: USER_LANGUAGE)
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK:- Custom Method(s)
    
    func updateCurrency() {
        let currencyModel = arrLanguage[(appDelegate?.nSelectedIndex)!] as? CurrencyModel
        STOREVALUE(value: (currencyModel?.currency_symbol)!, keyname: USER_CURRENCY_SYMBOL_ORG)
        STOREVALUE(value: (currencyModel?.currency_code)!, keyname: USER_CURRENCY_ORG)
    }
    
    
    
}
