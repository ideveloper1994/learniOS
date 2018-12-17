//
//  FilterVC.swift
//  Arheb
//
//  Created on 07/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

protocol ApplyFilterDelegate
{
    func onFilterApply(dic: NSMutableDictionary, noOfFilterApplied: Int)
}

class FilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate  {
    
    @IBOutlet var viewTopHolder: UIView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var tableFilter: UITableView!
    @IBOutlet var lblPriceRange: UILabel!
    
    @IBOutlet var priceRange: RangeSlider!
    
    @IBOutlet var btnSwitch: UIButton!
    @IBOutlet var btnBedsAdd: UIButton!
    @IBOutlet var btnBedRoomsAdd: UIButton!
    @IBOutlet var btnBathRoomsAdd: UIButton!
    
    @IBOutlet var btnBedsRemove: UIButton!
    @IBOutlet var btnBedRoomsRemove: UIButton!
    @IBOutlet var btnBathRoomsRemove: UIButton!
    
    @IBOutlet var lblBeds: UILabel!
    @IBOutlet var lblBedRooms: UILabel!
    @IBOutlet var lblBathRooms: UILabel!
    
    @IBOutlet var viewInstantBookHolder: UIView!
    @IBOutlet var btnInstantBook: UIButton!
    
    @IBOutlet var roomType1: CheckBoxButton!
    
    @IBOutlet var roomType2: CheckBoxButton!
    
    @IBOutlet var roomType3: CheckBoxButton!
    
    var delegate: ApplyFilterDelegate?
    
    var minPrice : Int = 0
    var maxPrice : Int = 0
    var isPriceRangeChanged : Bool = false
    var arrSection = ["Amenities","See all amenities"]
    var arrAmenities = ["Wifi", "Pool", "Kitchen"]
    
    var nBedsCount : Int = 0
    var nBedRoomsCount : Int = 0
    var nBathroomsCount : Double = 0
    var instantBookSelected:Bool = false
    var selecredMinPrice = 0
    var selectedMaxPrice = 700
    var noOfFilterApplied = 0
    
    var dictParams = NSMutableDictionary()
    static var arrSelectedAmenities = NSMutableArray()
    var arrAminities = [AminitiesModel]()
    
    // MARK: - UIViewController method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.getAminities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewcustomization()
        self.setValues()
        if(self.arrAminities.count == 0){
            self.getAminities()
        }
    }
    
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Here Customize the view
    func viewcustomization() {
        self.navigationController?.isNavigationBarHidden = true
        self.makeBorderLayer(btnLayer:btnBedsAdd)
        self.makeBorderLayer(btnLayer:btnBedRoomsAdd)
        self.makeBorderLayer(btnLayer:btnBathRoomsAdd)
        self.makeBorderLayer(btnLayer:btnBedsRemove)
        self.makeBorderLayer(btnLayer:btnBedRoomsRemove)
        self.makeBorderLayer(btnLayer:btnBathRoomsRemove)
        
        priceRange.addTarget(self, action: #selector(self.priceRangeChange), for: .valueChanged)
        
        self.tableFilter.tableHeaderView = tblHeaderView
        self.tableFilter.separatorStyle = .none;
        viewTopHolder.layer.shadowColor = UIColor.lightGray.cgColor
        
        btnInstantBook.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0).cgColor
        btnInstantBook.layer.borderWidth = 1.5
        btnInstantBook.layer.cornerRadius = btnInstantBook.frame.size.height/2
        
        viewInstantBookHolder.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0).cgColor
        viewInstantBookHolder.layer.borderWidth = 1.5
        viewInstantBookHolder.layer.cornerRadius = viewInstantBookHolder.frame.size.height/2
        
    }
    
    //MARK:- register cell
    func registerCell() {
        self.tableFilter.delegate = self
        self.tableFilter.dataSource = self
        let nib = UINib(nibName: "FilterCell", bundle: nil)
        self.tableFilter.register(nib, forCellReuseIdentifier: "cell")
    }
    
    func setValues() {
        minPrice = (appDelegate?.mimimumPrice)!
        maxPrice = (appDelegate?.maximumPrice)!
        selecredMinPrice = minPrice
        selectedMaxPrice = maxPrice
        priceRange.maximumValue = Double(maxPrice)
        priceRange.minimumValue = Double(minPrice)
        priceRange.lowerValue = Double(minPrice)
        priceRange.upperValue = Double(maxPrice)
        
        if(noOfFilterApplied > 0){
            if(self.dictParams.value(forKey: "beds") != nil){
                self.lblBeds?.text = String(describing: self.dictParams.value(forKey: "beds")!) + " beds"
            }
            if(self.dictParams.value(forKey: "bedrooms") != nil){
                self.lblBeds?.text = String(describing: self.dictParams.value(forKey: "bedrooms")!) + " bedrooms"
            }
            if(self.dictParams.value(forKey: "bathrooms") != nil){
                self.lblBeds?.text = String(describing: self.dictParams.value(forKey: "bathrooms")!) + " bathrooms"
            }
            if(self.dictParams.value(forKey: "room_type") != nil){
                let strParam = self.dictParams.value(forKey: "room_type") as! String
                let roomTypes = strParam.components(separatedBy: ",")
                for i in roomTypes{
                    if(i == "1") {
                        self.roomType1.sendActions(for: .touchUpInside)
                    }else if(i == "2") {
                        self.roomType2.sendActions(for: .touchUpInside)
                    }else {
                        self.roomType3.sendActions(for: .touchUpInside)
                    }
                }
            }
            if(self.dictParams.value(forKey: "instant_book") != nil){
                self.btnSwitch.sendActions(for: .touchUpInside)
            }
            if(self.dictParams.value(forKey: "min_price") != nil){
                self.selecredMinPrice = Int(self.dictParams.value(forKey: "min_price") as! String)!
                priceRange.lowerValue = Double(self.selecredMinPrice)
            }
            if(self.dictParams.value(forKey: "max_price") != nil){
                self.selectedMaxPrice = Int(self.dictParams.value(forKey: "max_price") as! String)!
                priceRange.upperValue = Double(self.selectedMaxPrice)
            }
        }
        self.setPriceText()
    }
    
    //MARK:-Price change
    func priceRangeChange(_ sender: RangeSlider){
        self.selecredMinPrice = Int(sender.lowerValue)
        self.selectedMaxPrice = Int(sender.upperValue)
        priceRange.lowerValue = sender.lowerValue
        priceRange.upperValue = sender.upperValue
        self.setPriceText()
    }
    
    func setPriceText() {
        let strCurrency = GETVALUE(USER_CURRENCY_SYMBOL)
        lblPriceRange?.text = String(format:"%@%d - %@%d",strCurrency,self.selecredMinPrice,strCurrency,self.selectedMaxPrice)
    }
    
    // MARK: - UITableViewController's Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.arrAmenities.count > 0 {
                return self.arrAmenities.count
            }
        } else {
            return 0
        }
        return 0
    }
    
    //MARK:- Amenities header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vwHeaderSec = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: UIScreen.main.bounds.size.width, height: 30)))
        vwHeaderSec.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        let lblHeader = UILabel(frame: CGRect(origin: CGPoint(x: 20,y :2), size: CGSize(width: UIScreen.main.bounds.size.width, height: 30)))
        lblHeader.backgroundColor = UIColor.clear
        if section == 0 {
            lblHeader.textColor = UIColor.lightGray
        } else {
            lblHeader.textColor = UIColor(red: 0.0/255.0, green: 166.0/255.0, blue: 153.0/255.0, alpha: 1.0)
            let tap = UITapGestureRecognizer(target: self, action: #selector(allAmenities(_:)))
            tap.delegate = self
            vwHeaderSec.addGestureRecognizer(tap)
        }
        lblHeader.font = UIFont(name: "CircularAirPro-Book", size: 17)
        lblHeader.text = self.arrSection[section]
        vwHeaderSec.addSubview(lblHeader)
        return vwHeaderSec;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FilterCell = self.tableFilter.dequeueReusableCell(withIdentifier: "cell") as! FilterCell
        cell.lblAmenities.text = self.arrAmenities[indexPath.row]
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.accessibilityHint = String(indexPath.section)
        cell.btnCheck.addTarget(self, action: #selector(self.onAmenitiesSelect), for: .touchUpInside)
        return cell
    }
    
    // MARK: - Handle tap gesture Method
    func allAmenities(_ gestureRecognizer: UIGestureRecognizer) {
        if(arrAminities.count > 0){
            let amenityVC = FilterAmenities()
            amenityVC.arrAminities = self.arrAminities
            self.present(amenityVC, animated: true, completion: nil)
        }
    }
    
    func makeBorderLayer(btnLayer:UIButton) {
        btnLayer.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0).cgColor
        btnLayer.layer.borderWidth = 1.0
        btnLayer.layer.cornerRadius = btnLayer.frame.size.height/2
    }
    
    internal func onFilterRoomBedsCount(tag : Int) {
        if tag == 111 && nBedsCount == 16 {
            return
        } else if tag == 222 && nBedRoomsCount == 10 {
            return
        } else if tag == 333 && nBathroomsCount == 8 {
            return
        }
        if tag == 11 && nBedsCount == 0 {
            return
        }else if tag == 22 && nBedRoomsCount == 0 {
            return
        }else if tag == 33 && nBathroomsCount == 0 {
            return
        }
        if tag == 11 {
            nBedsCount = nBedsCount - 1
        } else if tag == 22 {
            nBedRoomsCount = nBedRoomsCount - 1
        } else if tag == 33 {
            nBathroomsCount = nBathroomsCount - 0.5
        }
        
        if tag == 111 {
            nBedsCount = nBedsCount + 1
        }else if tag == 222 {
            nBedRoomsCount = nBedRoomsCount + 1
        }else if tag == 333 {
            nBathroomsCount = nBathroomsCount + 0.5
        }
        
        self.lblBeds?.text = String(format: "%d beds", nBedsCount)
        self.lblBedRooms?.text = String(format: "%d bedrooms", nBedRoomsCount)
        self.lblBathRooms?.text = nBathroomsCount.truncatingRemainder(dividingBy: 1) == 0 ?  String(format: "%.0f bathrooms", nBathroomsCount) :  String(format: "%.1f bathrooms", nBathroomsCount)
        
    }
    
    // MARK: - UIBtton Click(s)
    @IBAction func changeBedsAndBathRoomsCount(_ sender: UIButton) {
        self.onFilterRoomBedsCount(tag : sender.tag)
    }
    
    @IBAction func onInstantBookSwitch(_ sender: UIButton) {
        if !instantBookSelected {
            makeProgressAnimaiton(percentage:16)
            instantBookSelected = true
            //            btnInstantBook.titleLabel?.font = UIFont (name: "CircularAirPro-Book", size: 10)!
            btnInstantBook.setTitle("9", for: .normal)
            btnInstantBook.backgroundColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
            btnInstantBook.titleLabel?.text = "9"
            btnInstantBook.setTitleColor(UIColor.white, for: .normal)
        }else {
            //            btnPets.setImage(UIImage(named:"beds.png"), for: UIControlState.normal)
            makeProgressAnimaiton(percentage:2)
            instantBookSelected = false
            btnInstantBook.backgroundColor = UIColor.clear
            btnInstantBook.titleLabel?.text = ""
            btnInstantBook.setTitle("", for: .selected)
        }
    }
    
    // MARK: Setting Progress value and Animation
    func makeProgressAnimaiton(percentage:Int)
    {
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions(), animations: { () -> Void in
            var rectEmailView = self.btnInstantBook.frame
            if percentage == 2  {
                rectEmailView.origin.x = 2
            }else {
                rectEmailView.origin.x =  16
            }
            self.btnInstantBook.frame = rectEmailView
            
        }, completion: { (finished: Bool) -> Void in
            if percentage == 2 {
                self.btnInstantBook.backgroundColor = UIColor.clear
            }else {
                self.btnInstantBook.backgroundColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
            }
        })
    }
    
    
    @IBAction func btnCancleClicked(_ sender: Any) {
        appDelegate?.isFromMap = false
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Create filter dictionary
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.dictParams.removeAllObjects()
        self.noOfFilterApplied = 0
        if(instantBookSelected){
            dictParams["instant_book"]  = 1
            self.noOfFilterApplied += 1
        }
        
        if(self.maxPrice == self.selectedMaxPrice && self.minPrice == self.selecredMinPrice){
            self.isPriceRangeChanged = false
        }else{
            self.isPriceRangeChanged = true
            self.noOfFilterApplied += 1
            dictParams["min_price"] =  String(format: "%d",selecredMinPrice)
            dictParams["max_price"] =  String(format: "%d",selectedMaxPrice)
        }
        
        
        let arrRoomType = NSMutableArray()
        
        if(roomType1.is_Selected()){
            arrRoomType.add(1)
        }
        if(roomType2.is_Selected()){
            arrRoomType.add(2)
        }
        if(roomType3.is_Selected()){
            arrRoomType.add(3)
        }
        
        if arrRoomType.count > 0
        {
            dictParams["room_type"] = arrRoomType.componentsJoined(by: ",")
            self.noOfFilterApplied += 1
        }
        
        
        if(nBedsCount != 0 || nBedRoomsCount != 0 || nBathroomsCount != 0){
            if(nBedsCount != 0){
                dictParams["beds"] = String(format: "%d",nBedsCount)
            }
            if(nBedRoomsCount != 0){
                dictParams["bedrooms"] = String(format: "%d",nBedRoomsCount)
            }
            if(nBathroomsCount != 0){
                dictParams["bathrooms"] = String(format: "%d",nBathroomsCount)
            }
            self.noOfFilterApplied += 1
        }
        
        //Amenities
        if(FilterVC.arrSelectedAmenities.count > 0){
            dictParams["amenities"] = FilterVC.arrSelectedAmenities.componentsJoined(by: ",")
            self.noOfFilterApplied += 1
        }
        if(dictParams.count == 0){
            self.noOfFilterApplied = 0
        }
        delegate?.onFilterApply(dic: dictParams, noOfFilterApplied: noOfFilterApplied)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Reset all values in filter
    @IBAction func btnResetClicked(_ sender: Any) {
        self.noOfFilterApplied = 0
        FilterVC.arrSelectedAmenities.removeAllObjects()
        self.nBedsCount = 0
        self.nBathroomsCount = 0
        self.nBedRoomsCount = 0
        if(roomType1.is_Selected()){
            roomType1.sendActions(for: .touchUpInside)
        }
        if(roomType2.is_Selected()){
            roomType2.sendActions(for: .touchUpInside)
        }
        if(roomType3.is_Selected()){
            roomType3.sendActions(for: .touchUpInside)
        }
        if(instantBookSelected){
            btnSwitch.sendActions(for: .touchUpInside)
        }
        self.lblBeds?.text = String(format: "%d beds", nBedsCount)
        self.lblBedRooms?.text = String(format: "%d bedrooms", nBedRoomsCount)
        self.lblBathRooms?.text = String(format: "%d bathrooms", nBathroomsCount)
        self.dictParams.removeAllObjects()
        self.setValues()
    }
    
    func onAmenitiesSelect(_ sender: UIButton) {
        let row = sender.tag
        let section = Int(sender.accessibilityHint!)
        let cell = tableFilter.cellForRow(at: IndexPath(row: row, section: section!)) as! FilterCell
        onAmenitiesAdded(selectedValue :(cell.btnCheck.is_Selected()) ? 1 : 0, tag : row)
    }
    
    func onAmenitiesAdded(selectedValue : Int, tag : Int) {
        if tag == 0 {
            if selectedValue == 0 {
                FilterVC.arrSelectedAmenities.remove(String(format:"%d", 8))
            }else {
                FilterVC.arrSelectedAmenities.add(String(format:"%d", 8))
            }
        }else if tag == 1 {
            if selectedValue == 0 {
                FilterVC.arrSelectedAmenities.remove(String(format:"%d", 11))
            }
            else {
                FilterVC.arrSelectedAmenities.add(String(format:"%d", 11))
            }
        }else if tag == 2 {
            if selectedValue == 0 {
                FilterVC.arrSelectedAmenities.remove(String(format:"%d", 6))
            }else {
                FilterVC.arrSelectedAmenities.add(String(format:"%d", 6))
            }
        }
    }
    
    //MARK: - Api Call Get Aminities
    func getAminities() {
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_AMENITIES_LIST, params: NSMutableDictionary(), isTokenRequired: true, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(res != nil) {
                        let resDic = res as! NSDictionary
                        let objAminity:AminitiesModel = AminitiesModel()
                        if(resDic.value(forKey: "data") != nil){
                            let arrData:NSArray = resDic.value(forKey: "data") as! NSArray
                            self.arrAminities = objAminity.initiateAminityData(arrRes: arrData)
                        }
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
}
