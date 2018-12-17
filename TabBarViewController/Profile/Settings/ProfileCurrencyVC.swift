//
//  CurrencyVC.swift
//  Arheb
//
//  Created on 6/2/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

protocol currencyListDelegate {
    func onCurrencyChanged(currency:String)
}

class ProfileCurrencyVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblCurrency: UITableView!
    @IBOutlet var btnSave: UIButton!
    
    var delegate: currencyListDelegate?
    var strCurrentCurrency = ""
    var arrCurrencyData : NSMutableArray = NSMutableArray()
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblCurrency.register(UINib(nibName: "ProfileCurrencyCell", bundle: nil), forCellReuseIdentifier: "ProfileCurrencyCell")
        self.callCurrencyAPI()
        btnSave.layer.cornerRadius = 5.0
        self.localization()
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
        return arrCurrencyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCurrencyCell", for: indexPath) as! ProfileCurrencyCell
        let currencyModel = arrCurrencyData[indexPath.row] as? CurrencyModel
        let strSymbol = self.makeCurrencySymbols(encodedString: (currencyModel?.currency_symbol as String?)!)
        cell.lblCurrency?.text = String(format: "%@ | %@",(currencyModel?.currency_code as String?)!,strSymbol)
        cell.imgTickMark?.isHidden = (strCurrentCurrency == cell.lblCurrency?.text) ? false : true
        cell.imgTickMark?.image = UIImage(named: "check_red_active.png")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! ProfileCurrencyCell
        appDelegate?.nSelectedIndex = indexPath.row
        strCurrentCurrency = (selectedCell.lblCurrency?.text)!
        tblCurrency.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func onSaveTapped(_ sender:UIButton!) {
        self.updateCurrencyAPI()
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK:- Custom Method(s)
    
    func updateCurrency() {
        let currencyModel = arrCurrencyData[(appDelegate?.nSelectedIndex)!] as? CurrencyModel
        STOREVALUE(value: (currencyModel?.currency_symbol)!, keyname: USER_CURRENCY_SYMBOL_ORG)
        STOREVALUE(value: (currencyModel?.currency_code)!, keyname: USER_CURRENCY_ORG)
    }
    
    func makeCurrencySymbols(encodedString : String) -> String {
        let encodedData = encodedString.stringByDecodingHTMLEntities
        return encodedData
    }
    
    func makeScroll() {
        for i in 0..<arrCurrencyData.count {
            let currencyModel = arrCurrencyData[i] as? CurrencyModel
            let str = strCurrentCurrency.components(separatedBy: " | ")
            if currencyModel?.currency_code == str[0] {
                let indexPath = IndexPath(row: i, section: 0)
                tblCurrency.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    // MARK:- API Calling Method(s)
    
    func callCurrencyAPI() {
        ProgressHud.shared.Animation = true
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_CURRENCY_LIST, params: NSMutableDictionary(), isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                }else{
                    let result = response as! NSDictionary
                    self.arrCurrencyData.addObjects(from: CurrencyModel().initiateCurrencyData(jsonData: result))
                    self.tblCurrency.reloadData()
                    self.makeScroll()
                }
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            OperationQueue.main.addOperation {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    //MARK:- Set Language
    func updateCurrencyAPI() {
        ProgressHud.shared.Animation = true
        let dict = NSMutableDictionary()
        let str = strCurrentCurrency.components(separatedBy: " | ")
        dict["currency_code"] = str[0]
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_CHANGE_CURRENCY, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    let result = response as! NSDictionary
                    ExploreVC.isCurrencyChange = true
                    self.delegate?.onCurrencyChanged(currency: self.strCurrentCurrency)
                    STOREVALUE(value: str[1], keyname: USER_CURRENCY_SYMBOL)
                    STOREVALUE(value: String(format:"%@ (%@)",str[0] as NSString,str[1]), keyname: USER_CURRENCY)
                    self.updateCurrency()
                    self.navigationController!.popViewController(animated: true)
                }
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            OperationQueue.main.addOperation {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    // MARK:- Localization Method
    func localization() {
        self.lblTitle.text = currency
        self.btnSave.setTitle(save, for: .normal)
    }
    
}
