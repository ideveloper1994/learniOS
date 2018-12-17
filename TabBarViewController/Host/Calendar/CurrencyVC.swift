//
//  CurrencyVC.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

@objc protocol CurrencyChangedDelegate {
    func roomCurrencyChanged(_ strCurrencyCode: String, strCurrencySymbol: String)
    func updateBookTypeOrPolicy(_ strDescription: String)
    func updateRoomPrice(_ modelList : ListingModel)
}

class CurrencyVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var tblCurrency: UITableView!
    @IBOutlet var vwTopBar: UIView!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet var lblTitle: UILabel!
    
    var strCurrentCurrency = ""
    var strCurrencySymbol = ""
    var strCurrency = ""
    var strTitle = ""
    var delegate: CurrencyChangedDelegate?
    var arrCurrencyData : NSMutableArray = NSMutableArray()
    var isFromAddRoom : Bool = false
    var strApiMethodName = ""
    var listModel : ListingModel!
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        tblCurrency.delegate = self
        tblCurrency.dataSource = self
        tblCurrency.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
        self.animatedLoader?.isHidden = true
        btnSave.isHidden = true
        strCurrency = strCurrentCurrency
        lblTitle.text = strTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !isFromAddRoom {
            self.callCurrencyAPI()
        }
    }
    
    // MARK:- TableView Method(s)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCurrencyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        if !isFromAddRoom {
            let currencyModel = self.arrCurrencyData[indexPath.row] as? CurrencyModel
            cell.lblCurrency.text = currencyModel?.currency_code
        } else {
            cell.lblCurrency.text = arrCurrencyData[indexPath.row] as? String
        }
        cell.imgCurrency.layer.borderColor = UIColor.red.cgColor
        cell.imgCurrency.image = UIImage(named: "check_red_active")
        cell.imgCurrency.isHidden = (strCurrentCurrency == cell.lblCurrency.text) ? false : true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isFromAddRoom {
            let currencyModel = arrCurrencyData[indexPath.row] as? CurrencyModel
            strCurrentCurrency = (currencyModel?.currency_code)!
            strCurrencySymbol =  (currencyModel?.currency_symbol)!
        } else {
            strCurrentCurrency = arrCurrencyData[indexPath.row] as! String
        }
        btnSave.isHidden = (strCurrency == strCurrentCurrency) ? true : false
        tblCurrency.reloadData()
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        if strApiMethodName == API_UPDATE_ROOM_CURRENCY {
            self.updateRoomCurrencyAPI()
        } else {
            setDotLoader(animatedLoader!)
            self.btnSave?.isHidden = true
            self.animatedLoader?.isHidden = false
            self.switchAPI()
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- API Calling Method(s)
    
    func callCurrencyAPI() {
        ProgressHud.shared.Animation = true
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_CURRENCY_LIST, params: NSMutableDictionary(), isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!, isSuccess: false)
                }else{
                    let result = response as! NSDictionary
                    self.arrCurrencyData.addObjects(from: CurrencyModel().initiateCurrencyData(jsonData: result))
                    self.tblCurrency.reloadData()
                    self.makeScroll()
                }
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            ProgressHud.shared.Animation = false
        }
    }
    
    func switchAPI() {
        ProgressHud.shared.Animation = true
        let dict = NSMutableDictionary()
        if strApiMethodName == API_UPDATE_POLICY {
            dict["policy_type"]   = strCurrentCurrency
        } else if strApiMethodName == API_UPDATE_BOOKING_TYPE {
            dict["booking_type"]   = strCurrentCurrency.lowercased().replacingOccurrences(of: " ", with: "_")
        }
        dict["room_id"]   = appDelegate?.strRoomID
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: strApiMethodName, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!, isSuccess: false)
                }else{
                    if self.strApiMethodName == API_UPDATE_ROOM_CURRENCY {
                        self.delegate?.roomCurrencyChanged(self.strCurrentCurrency, strCurrencySymbol: self.strCurrencySymbol)
                    } else{
                        self.delegate?.updateBookTypeOrPolicy(self.strCurrentCurrency)
                    }
                    self.navigationController!.popViewController(animated: true)
                }
                self.animatedLoader?.isHidden = true
                self.btnSave?.isHidden = false
                ProgressHud.shared.Animation = false
            }
        }, andFailureBlock: { (Error) in
            DispatchQueue.main.async {
                self.animatedLoader?.isHidden = true
                self.btnSave?.isHidden = false
                ProgressHud.shared.Animation = false
            }
        })
    }
    
    func updateRoomCurrencyAPI() {
        ProgressHud.shared.Animation = true
        let dict = NSMutableDictionary()
        self.animatedLoader?.isHidden = false
        setDotLoader(animatedLoader!)
        self.btnSave?.isHidden = true
        dict["currency_code"]   = strCurrentCurrency.replacingOccurrences(of: " ", with: "%20")
        dict["room_id"]   =  "\(self.listModel.room_id)"
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: strApiMethodName, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                
                let modelList = ListingModel()
                let result = response as! NSDictionary
                modelList.success_message = result["success_message"] as! String
                modelList.status_code = result["status_code"] as! String
                if modelList.status_code == "1" {
                    bindData(dic: result, str: "additional_guest_fee", type: &modelList.additionGuestFee)
                    bindData(dic: result, str: "cleaning_fee", type: &modelList.cleaningFee)
                    bindData(dic: result, str: "monthly_price", type: &modelList.monthly_price)
                    bindData(dic: result, str: "room_price", type: &modelList.room_price)
                    bindData(dic: result, str: "security_deposit", type: &modelList.securityDeposit)
                    bindData(dic: result, str: "weekend_pricing", type: &modelList.weekendPrice)
                    bindData(dic: result, str: "weekly_price", type: &modelList.weekly_price)
                    self.updateCurrencyChanges(modelList)
                }
                self.animatedLoader?.isHidden = true
                self.btnSave.isHidden = false
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            DispatchQueue.main.async {
                self.animatedLoader?.isHidden = true
                self.btnSave?.isHidden = false
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    // MARK:- Custom Method(s)
    
    func makeScroll() {
        for i in 0...self.arrCurrencyData.count-1 {
            let currencyModel = arrCurrencyData[i] as? CurrencyModel
            if currencyModel?.currency_code == strCurrentCurrency {
                let indexPath = IndexPath(row: i, section: 0)
                self.tblCurrency.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    func updateCurrencyChanges(_ modelList : ListingModel) {
        var tempModel = ListingModel()
        if listModel != nil {
            tempModel = listModel
        }
        tempModel.additionGuestFee = modelList.additionGuestFee
        tempModel.cleaningFee = modelList.cleaningFee
        tempModel.monthly_price = modelList.monthly_price
        tempModel.room_price = modelList.room_price
        tempModel.securityDeposit = modelList.securityDeposit
        tempModel.weekendPrice = modelList.weekendPrice
        tempModel.weekly_price = modelList.weekly_price
        delegate?.updateRoomPrice(tempModel)
        delegate?.roomCurrencyChanged(self.strCurrentCurrency, strCurrencySymbol: self.strCurrencySymbol)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Currency Change Delegate Method(s)
    
}
