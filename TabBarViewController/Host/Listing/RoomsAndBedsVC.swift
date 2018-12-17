//
//  RoomsAndBedsVC.swift
//  Arheb
//
//  Created on 03/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

class RoomsAndBedsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    
    // MARK:- IBOutlet(ss

    @IBOutlet var btnClose: UIButton!
    @IBOutlet var lblRoomsAndBeds: UILabel!
    @IBOutlet var vwPicker: UIView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var tblRooms: UITableView!
    @IBOutlet var animatedLoader: FLAnimatedImageView!
    
    var arrPickerData : NSArray!
    let arrMostCommon = [bedrooms,beds,bathrooms, max_guests]
    let arrBedRooms = ["1","2","3", "4","5","6","7", "8","9", "10"]
    let arrBeds = ["1","2","3", "4","5","6","7", "8","9", "10","11","12","13", "14","15","16+"]
    let arrBathRooms = ["0","0.5","1", "1.5","2","2.5","3", "3.5","4", "4.5","5","5.5","6", "6.5","7","7.5","8+"]
    let arrGuests = ["1","2","3", "4","5","6","7", "8","9", "10","11","12","13", "14","15","16+"]
    let arrRoomType = [entire_home,private_room,shared_room]
    let arrHomeType = [apartment,house,bedBreakFast,loft,townhouse,condominium,bungalow,cabin,villa,castle,dorm,treehouse,boat,plane,cameraRv,lgloo,lighthouse,yrt,tipi,cave,island,chalet,earthHouse,hut,train,Tent,other]
    var arrValues = ["1","1","1","1",entire_home,apartment]
    var arrDummyValues = [String]()
    var currentIndex = Int()
    var listModel : ListingModel!
    var strBedRoomcount:String = ""
    var strBedsCount:String = ""
    var strBathroomCount:String = ""
    var strMaxGuest:String = ""
    var strRoomType:String = ""
    var strHomeType:String = ""
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        registerCell()
        arrPickerData = arrBeds as NSArray
        let room = Int(listModel.room_type as String)!
        strBedRoomcount = ((listModel.bedroom_count as String).characters.count > 0) ? (String(format:"%@",listModel.bedroom_count)) : ""
        strBedsCount = ((listModel.beds_count as String).characters.count > 0) ? (String(format:(listModel.beds_count as String == "16") ? "%@+" : "%@",listModel.beds_count)) : ""
        strBathroomCount = ((listModel.bathrooms_count as String).characters.count > 0) ? (String(format:(listModel.bathrooms_count as String == "8") ? "%@+" : "%@",listModel.bathrooms_count.replacingOccurrences(of: ".0", with: ""))) : ""
        strMaxGuest = ((listModel.max_guest_count as String).characters.count > 0) ? (String(format:(listModel.max_guest_count as String == "16") ? "%@+" : "%@",listModel.max_guest_count)) : ""
        strRoomType = ((listModel.room_type as String).characters.count > 0) ? arrRoomType[room-1] : arrRoomType[0]
        strHomeType = ((listModel.home_type as String).characters.count > 0) ? (String(format:"%@",listModel.home_type)) : ""
        arrValues = [strBedRoomcount,strBedsCount,strBathroomCount,strMaxGuest,strRoomType,strHomeType]
        arrDummyValues = arrValues
    }
    
    //MARK: - Tabelview Delegate & Datasource Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblRooms.frame.size.width) ,height: 20)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrMostCommon.count
        } else if section == 1 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        cell.imgCurrency.isHidden = true
        cell.txtCell.isHidden = false
        cell.txtCell.isUserInteractionEnabled = false
        cell.lblCurrency.textColor = UIColor.darkGray
        cell.lblCurrency.font = cell.lblCurrency.font.withSize(15)
        cell.lblCurrencySign.isHidden = true
        cell.lblTickmark.isHidden = true
        if indexPath.section == 0 {
            cell.lblCurrency?.text = arrMostCommon[indexPath.row]
            cell.txtCell?.text = arrValues[indexPath.row]
        } else if indexPath.section == 1 {
            cell.lblCurrency?.text = roomtype
            cell.txtCell?.text = arrValues[indexPath.row+4]
        } else {
            cell.lblCurrency?.text = hometype
            cell.txtCell?.text = arrValues[indexPath.row+5]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            currentIndex = indexPath.row
        } else if indexPath.section == 1 {
            currentIndex = 4
        } else {
            currentIndex = 5
        }
        arrPickerData = self.getPickerData()
        vwPicker?.isHidden = false
        pickerView?.reloadAllComponents()
    }
    
    //MARK: - Custom Method
    
    func getPickerData() -> NSArray {
        if currentIndex == 0 {
            arrPickerData = arrBedRooms as NSArray!
        } else if currentIndex == 1 {
            arrPickerData = arrBeds as NSArray!
        } else if currentIndex == 2 {
            arrPickerData = arrBathRooms as NSArray!
        } else if currentIndex == 3 {
            arrPickerData = arrGuests as NSArray!
        } else if currentIndex == 4 {
            arrPickerData = arrRoomType as NSArray!
        } else {
            arrPickerData = arrHomeType as NSArray!
        }
        return arrPickerData
    }
    
    func checkSaveButtonStatus() {
        if arrValues == arrDummyValues {
            btnSave.isHidden = true
        } else {
            btnSave.isHidden = false
        }
    }
    func updateListModel(){
        listModel.home_type = self.strHomeType
        listModel.beds_count = self.strBedsCount
        listModel.bedroom_count = self.strBedRoomcount
        listModel.max_guest_count = self.strMaxGuest
        listModel.bathrooms_count = self.strBathroomCount
        listModel.room_type = (self.strRoomType == "Entire Home") ? "1" : (self.strRoomType == "Private Room") ? "2" : "3"
        self.navigationController?.popViewController(animated: true)
    }
    
    func viewcustomization() {
        vwPicker?.isHidden = true
        tblRooms.tableFooterView = UIView()
        btnSave.setTitle(save, for: .normal)
        btnSave.isHidden = true
        btnClose.setTitle(close, for: .normal)
        lblRoomsAndBeds.text = roomsandbeds
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        tblRooms.tableFooterView = UIView()
    }
    
    func registerCell() {
        pickerView.delegate = self
        tblRooms.dataSource = self
        tblRooms.delegate = self
        tblRooms.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
    }
    
    //MARK: - Pickeview Delegate  Method(s)
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  String(describing: arrPickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var str = ""
        if currentIndex == 5 {
            let arr = (arrPickerData[row] as? String)?.components(separatedBy: "~~~")
            str = (arr?[0])!
        } else {
            str = (arrPickerData[row] as? String)!
        }
        //        selectedCell.lblSubValues?.text = str
        
        if currentIndex == 0 {
            strBedRoomcount = str
        } else if currentIndex == 1 {
            strBedsCount = str
        } else if currentIndex == 2 {
            strBathroomCount = str
        } else if currentIndex == 3 {
            strMaxGuest = str
        } else if currentIndex == 4 {
            strRoomType = str
        } else{
            strHomeType = str
        }
        arrValues = [strBedRoomcount,strBedsCount,strBathroomCount,strMaxGuest,strRoomType,strHomeType]
        checkSaveButtonStatus()
        arrValues[currentIndex] = String(describing: arrPickerData[row])
        print(arrValues)
        tblRooms.reloadData()
        checkSaveButtonStatus()
    }
    
    //MARK: - Api Call
    func saveInfo(){
        btnSave.isHidden = true
        animatedLoader.isHidden = false
        setDotLoader(animatedLoader)
        let dicts = NSMutableDictionary()
        dicts.setValue(listModel.room_id, forKey: RoomBed.roomId)
        dicts.setValue(strBathroomCount.replacingOccurrences(of: "+", with: ""), forKey: RoomBed.bathrooms)
        dicts.setValue((strRoomType == "Entire Home") ? "1" : (strRoomType == "Private Room") ? "2" : "3", forKey: RoomBed.roomType)
        if strMaxGuest.characters.count > 0 {
            strMaxGuest = strMaxGuest.replacingOccurrences(of: "+", with: "")
        }
        dicts.setValue(strMaxGuest, forKey: RoomBed.personCapacity)
        if strBedRoomcount.characters.count > 0 {
            strBedRoomcount = strBedRoomcount.replacingOccurrences(of: "+", with: "")
        }
        dicts.setValue(strBedRoomcount, forKey: RoomBed.bedRooms)
        if strBedsCount.characters.count > 0 {
            strBedsCount = strBedsCount.replacingOccurrences(of: "+", with: "")
        }
        dicts.setValue(strBedsCount, forKey: RoomBed.beds)
        var strHomeTypeNum = ""
        for i in 0 ..< arrHomeType.count {
            let str = arrHomeType[i].components(separatedBy: "~~~")
            if str[0] == strHomeType {
                strHomeTypeNum = str[0]
            }
        }
        dicts.setValue(strHomeTypeNum.replacingOccurrences(of: " ", with: "%20"), forKey: RoomBed.propertyType)
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_UPDATE_LONG_TERM_PRICE, params: dicts, isTokenRequired: true, forSuccessionBlock: { (res, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(res != nil){
                        self.updateListModel()
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
    
    
    //MARK: - IBAction Method(s) 
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        vwPicker.isHidden = true
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        saveInfo()
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
