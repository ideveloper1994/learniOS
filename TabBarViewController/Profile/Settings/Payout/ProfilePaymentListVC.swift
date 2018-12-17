//
//  ProfilePaymentListVC.swift
//  Arheb
//
//  Created on 6/3/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ProfilePaymentListVC: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblPayoutList: UITableView!
    @IBOutlet var btnAddPayout: UIButton!
    @IBOutlet var vwNav: UIView!
    
    var arrPayouts = [PayoutModel]()
    static var isPaymentAdd = false
    var chagedRow = 0
    var defaultRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
        self.viewcustomization()
        self.getPayOutDetails()
        self.localization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(ProfilePaymentListVC.isPaymentAdd){
            self.getPayOutDetails()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Customize the view
    func viewcustomization(){
        self.navigationController?.navigationBar.isHidden = true
        self.tblPayoutList.tableFooterView = UIView()
        vwNav.layer.shadowColor = UIColor.lightGray.cgColor
        btnAddPayout.layer.cornerRadius = 5
    }
    
    //MARK:- Register Profile table
    func registerTableView() {
        tblPayoutList.dataSource = self
        tblPayoutList.delegate = self
        tblPayoutList.register(UINib(nibName: "PayoutListCell", bundle: nil), forCellReuseIdentifier: "PayoutListCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPayouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPayoutList.dequeueReusableCell(withIdentifier: "PayoutListCell", for: indexPath) as! PayoutListCell
        cell.lblDefault.text = (self.arrPayouts[indexPath.row].set_default == "Yes") ? "Default" : ""
        if(self.arrPayouts[indexPath.row].set_default == "Yes"){
            self.defaultRow = indexPath.row
        }
        cell.lblEmail.text = self.arrPayouts[indexPath.row].paypal_email
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(self.arrPayouts[indexPath.row].set_default == "Yes"){
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: remove) { (action, indexPath) in
            self.makeAsDefaultPayOutDetail(type: "delete", id: self.arrPayouts[indexPath.row].payout_id)
            self.chagedRow = indexPath.row
        }
        
        let makeDefault = UITableViewRowAction(style: .default, title: mkDefault) { (action, indexPath) in
            self.makeAsDefaultPayOutDetail(type: "default", id: self.arrPayouts[indexPath.row].payout_id)
            self.chagedRow = indexPath.row
        }
        
        makeDefault.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 83/255, alpha: 1.0)
        return [delete, makeDefault]
    }
    
    @IBAction func btnAddPayoutClicked(_ sender: Any) {
        let addVC = AddPayoutVC(nibName: "AddPayoutVC", bundle: nil)
        addVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    @IBAction func onBackClicked(_ sender:UIButton!){
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK:- API call Get all payment details
    func getPayOutDetails()
    {
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_GET_PAYOUT_LIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(response != nil){
                        let resDic = response as! NSDictionary
                        let paymentDic = resDic.value(forKey: "payout_details") as! NSArray
                        self.arrPayouts = PayoutModel().initiatePayoutData(arrRes: paymentDic)
                        self.tblPayoutList.reloadData()
                        ProfilePaymentListVC.isPaymentAdd = false
                    }
                }
                ProgressHud.shared.Animation = false
                
            }
        }) { (error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    //MARK:- API call for make default or delete
    func makeAsDefaultPayOutDetail(type: String, id: String)
    {
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        params.setValue(id, forKey: "payout_id")
        params.setValue(type, forKey: "type")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_PAYOUT_CHANGES, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(response != nil){
                        let indexpath = IndexPath(row: self.chagedRow, section: 0)
                        if(type == "delete"){
                            self.arrPayouts.remove(at: self.chagedRow)
                            self.tblPayoutList.deleteRows(at: [indexpath], with: UITableViewRowAnimation.fade)
                        }else{
                            self.arrPayouts[self.chagedRow].set_default = "Yes"
                            self.arrPayouts[self.defaultRow].set_default = "No"
                            let defaultIndex = IndexPath(row: self.defaultRow, section: 0)
                            self.defaultRow = self.chagedRow
                            self.tblPayoutList.reloadRows(at: [indexpath,defaultIndex], with: .none)
                        }
                    }
                    ProgressHud.shared.Animation = false
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    // MARK:- Localization Method
    func localization() {
        self.lblTitle.text = payouts
        self.btnAddPayout.setTitle(addPayout, for: .normal)
    }
    
}
