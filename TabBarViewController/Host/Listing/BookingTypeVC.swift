//
//  BookingTypeVC.swift
//  Arheb
//
//  Created on 03/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

class BookingTypeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var lbBookingType: UILabel!
    @IBOutlet var tblBookingType: UITableView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var animatedLoader: FLAnimatedImageView!
    
    var index = -1
    var arrListing = [String]()
    var strCurrentPolicy = ""
    var demoPolicy = ""
    var listModel : ListingModel!
    var txtTitle:String!
    var isBooking:Bool!
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        registerCell()
        demoPolicy = strCurrentPolicy
        lbBookingType.text = txtTitle
        btnSave.setTitle(save, for: .normal)
    }
    
    //MARK: - Tableview Delegate & Datasource Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        cell.imgCurrency.isHidden = false
        cell.lblCurrency.isHidden = false
        cell.lblCurrency.textColor = UIColor.darkGray
        cell.lblCurrency.font = cell.lblCurrency.font.withSize(15)
        cell.lblCurrency.text = arrListing[indexPath.row]
        if strCurrentPolicy == cell.lblCurrency.text{
            cell.imgCurrency.isHidden = false
            cell.imgCurrency.layer.borderColor = UIColor.red.cgColor
            cell.imgCurrency.image = #imageLiteral(resourceName: "check_red_active")
        } else {
            cell.imgCurrency.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        strCurrentPolicy = arrListing[indexPath.row]
        checkSaveButtonStatus()
        tblBookingType.reloadData()
    }
    
    //MARK: - Custom Method
    
    func checkSaveButtonStatus(){
        btnSave.isHidden = demoPolicy != strCurrentPolicy ? false : true
    }
    
    func viewcustomization(){
        btnSave.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        lbBookingType.text = booking_type
        self.navigationController?.isNavigationBarHidden = true
        tblBookingType.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = true
        btnSave.isHidden = true
        self.animatedLoader.isHidden = true
        setDotLoader(animatedLoader)
    }
    
    func registerCell(){
        tblBookingType.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
    }
    
    //MARK: - Api Call
    func saveInfo(){
        btnSave.isHidden = true
        animatedLoader.isHidden = false
        let param = NSMutableDictionary()
        let methodName:String!
        if isBooking {
            param.setValue(strCurrentPolicy.lowercased().replacingOccurrences(of: " ", with: "_"), forKey: "booking_type")
            methodName = API_UPDATE_BOOKING_TYPE
        } else {
            param.setValue(strCurrentPolicy, forKey: "policy_type")
            methodName = API_UPDATE_POLICY
        }
        param.setValue(listModel.room_id, forKey: "room_id")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: methodName, params: param, isTokenRequired: true, forSuccessionBlock: { (res, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(res != nil){
                        if self.isBooking {
                            self.listModel.booking_type = self.strCurrentPolicy
                        } else {
                            self.listModel.policy_type = self.strCurrentPolicy
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                self.animatedLoader.isHidden = true
                self.btnSave.isHidden = false
            }
        }) { (error) in
            self.animatedLoader.isHidden = true
            self.btnSave.isHidden = false
        }
    }
    
    //MARK: - IBAction Method
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        saveInfo()
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
