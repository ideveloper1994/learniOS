//
//  EditPriceVC.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

@objc protocol EditPriceDelegate {
    func PriceEditted(strDescription: String)
    func currencyChangedInEditPrice(strCurrencyCode: String, strCurrencySymbol: String)
    func updateAllRoomPrice(modelList : ListingModel)
}

class EditPriceVC : UIViewController, UITextFieldDelegate, CurrencyChangedDelegate {
    
    // MARK:- IBOutlet(s)
    @IBOutlet var lblPriceTip: UILabel!
    @IBOutlet var lblLearnMore: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewBottomHolder : UIView!
    @IBOutlet var txtFldPrice : UITextField!
    @IBOutlet var viewPriceHolder : UIView!
    @IBOutlet var lblCurrency : UILabel!
    @IBOutlet var btnSave : UIButton!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet var btnChangeCurrency : UIButton!
    @IBOutlet var lblFixedPrice: UILabel!
    
    var delegate: EditPriceDelegate?
    var strPrice = ""
    var strRoomId = ""
    var room_currency_code = ""
    var room_currency_symbol = ""
    var isFromCalendar : Bool = false
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animatedLoader?.isHidden = true
        if isFromCalendar {
            btnChangeCurrency.isHidden = true
        }
        btnSave.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        txtFldPrice.becomeFirstResponder()
        viewBottomHolder.isHidden = true
        lblCurrency.text = room_currency_symbol.stringByDecodingHTMLEntities
        viewPriceHolder.layer.borderColor = UIColor(red: 207.0 / 255.0, green: 207.0 / 255.0, blue: 205.0 / 255.0, alpha: 1.0).cgColor
        viewPriceHolder.layer.borderWidth = 1.0
        
        if strPrice != "" && strPrice != "0" {
            txtFldPrice.text = strPrice
        }
        self.localization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: TextField Delegate Method(s)
    
    @IBAction private func textFieldDidChange(textField: UITextField) {
        if strPrice == textField.text {
            btnSave.isHidden = true
            return
        }
        btnSave.isHidden = ((textField.text?.characters.count)! > 0) ? false : true
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
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func onSaveTapped(_ sender:UIButton!) {
        self.view.endEditing(true)
        if isFromCalendar {
            self.delegate?.PriceEditted(strDescription: self.txtFldPrice.text!)
            self.navigationController!.popViewController(animated: true)
            return
        }
        setDotLoader(animatedLoader!)
        self.btnSave?.isHidden = true
        self.animatedLoader?.isHidden = false
        self.editPriceApi()
    }
    
    @IBAction func onChangeCurrencyTapped(_ sender:UIButton!) {
        self.view.endEditing(true)
        let currencyView = CurrencyVC(nibName: "CurrencyVC", bundle: nil)
        currencyView.strApiMethodName = API_UPDATE_ROOM_CURRENCY
        currencyView.strCurrentCurrency = room_currency_code
        currencyView.strTitle = "Currency"
        currencyView.delegate = self
        self.navigationController?.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(currencyView, animated: true)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.view.endEditing(true)
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK:- Currency change delegate(s)
    
    func updateBookTypeOrPolicy(_ strDescription: String) {
    }
    
    func roomCurrencyChanged(_ strCurrencyCode: String, strCurrencySymbol: String) {
        delegate?.currencyChangedInEditPrice(strCurrencyCode: strCurrencyCode, strCurrencySymbol: strCurrencySymbol)
        room_currency_code = strCurrencyCode
        lblCurrency.text = strCurrencySymbol.stringByDecodingHTMLEntities
    }
    
    func updateRoomPrice(_ modelList : ListingModel) {
        self.txtFldPrice.text = ((modelList.room_price as String) == "0") ? "" : modelList.room_price as String
        self.delegate?.updateAllRoomPrice(modelList : modelList)
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- API Calling Method(s)
    
    func editPriceApi() {
        strPrice = txtFldPrice.text!
        let dicts = NSMutableDictionary()
        dicts["room_id"]   = strRoomId
        dicts["room_price"]   = strPrice
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_ADD_ROOM_PRICE, params: dicts, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    self.delegate?.PriceEditted(strDescription: self.txtFldPrice.text!)
                    self.navigationController!.popViewController(animated: true)
                }
                self.animatedLoader?.isHidden = true
                self.btnSave?.isHidden = false
            }
        }) { (Error) in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                self.btnSave?.isHidden = false
            }
        }
    }
    
    // MARK:- Localization Method
    func localization() {
        self.lblTitle.text = editPrice
        self.lblPriceTip.text = priceTip
        self.lblFixedPrice.text = fixedPrice
        self.lblLearnMore.text = learnMore
        self.btnChangeCurrency.setTitle(changeCurrency, for: .normal)
        self.btnSave.setTitle(save, for: .normal)
    }
    
}
