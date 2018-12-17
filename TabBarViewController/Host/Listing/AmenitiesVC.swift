//
//  AmenitiesVC.swift
//  Arheb
//
//  Created on 03/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

class AmenitiesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblAmenitites: UITableView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var animatedLoader: FLAnimatedImageView!
    
    var arrSelectedItems : NSMutableArray = NSMutableArray()
    var arrDemoSelectedItems: NSMutableArray = NSMutableArray()
    var arrAminities = [AminitiesModel]()
    var listModel : ListingModel!
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        registerCell()
        getAminities()
        
        arrDemoSelectedItems.add(arrSelectedItems.componentsJoined(by: ","))
    }
    func viewcustomization(){
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        lblTitle.text = amenities
        btnSave.setTitle(save, for: .normal)
    }
    func registerCell(){
        tblAmenitites.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
    }
    
    //MARK: - Api Call
    func getAminities(){
        ProgressHud.shared.Animation = true
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_AMENITIES_LIST, params: NSMutableDictionary(), isTokenRequired: true, forSuccessionBlock: { (res, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(res != nil){
                        let resDic = res as! NSDictionary
                        let objAminity:AminitiesModel = AminitiesModel()
                        if(resDic.value(forKey: "data") != nil){
                            let arrData:NSArray = resDic.value(forKey: "data") as! NSArray
                            self.arrAminities = objAminity.initiateAminityData(arrRes: arrData)
                            self.tblAmenitites.reloadData()
                        }
                    }
                    ProgressHud.shared.Animation = false
                }
            }
        }) { (error) in
            ProgressHud.shared.Animation = false
        }
    }
    
    //MARK: - Tabelview Delegate & Datasource Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAminities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        cell.lblTickmark.isHidden = false
        cell.txtCell.isHidden = true
        cell.lblTickmark.layer.borderColor = UIColor.red.cgColor
        
        let objAminity:AminitiesModel = arrAminities[indexPath.row]
        cell.lblCurrency.text = objAminity.aminity_name
        let strId = objAminity.aminity_id
        cell.lblTickmark.text = (arrSelectedItems.contains(strId)) ? "9" : ""
        cell.lblCurrency.textColor = UIColor.darkGray
        cell.lblCurrency.font = cell.lblCurrency.font.withSize(15)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objAminity:AminitiesModel = arrAminities[indexPath.row]
        if(arrSelectedItems.contains(objAminity.aminity_id)){
            arrSelectedItems.remove(objAminity.aminity_id)
        }else{
            arrSelectedItems.add(objAminity.aminity_id)
        }
        
        tblAmenitites.reloadRows(at: [indexPath], with: .none)
        checkForSaveButton()
    }
    
    //MARK: - Custom Method
    func checkForSaveButton(){
        let arrDummyValues:NSMutableArray = NSMutableArray()
        arrDummyValues.add(arrSelectedItems.componentsJoined(by: ","))
        btnSave.isHidden = arrDemoSelectedItems == arrDummyValues ? true : false
    }
    
    
    func saveInfo(){
        btnSave.isHidden = true
        animatedLoader.isHidden = false
        setDotLoader(animatedLoader)
        let param = NSMutableDictionary()
        param.setValue(listModel.room_id, forKey: "room_id")
        param.setValue(arrSelectedItems.componentsJoined(by: ","), forKey: "selected_amenities")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_UPDATE_SELECTED_AMENITIES, params: param, isTokenRequired: true, forSuccessionBlock: { (res, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(res != nil){
                        let str = self.arrSelectedItems.componentsJoined(by: ",")
                        self.listModel.selected_amenities_id = str
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
        // Dispose of any resources that can be recreated.
    }
}
