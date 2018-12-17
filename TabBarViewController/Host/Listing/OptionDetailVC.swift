//
//  OptionDetailVC.swift
//  Arheb
//
//  Created on 03/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
protocol OptionalDetailDelegate
{
    func RoomCurrencyChanged(listModel: ListingModel)
}

class OptionDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource, CurrencyChangedDelegate {

    @IBOutlet var lblOptionDetails: UILabel!
    @IBOutlet var btnListed: UIButton!
    @IBOutlet var vwFooter: UIView!
    @IBOutlet var tblOptionDetail: UITableView!
    var listModel : ListingModel!
    var delegate: OptionalDetailDelegate?
    let arrPrice = [long_Term_additional_prices,currency]
    let arrDetails = [about_this_listing,amenities,rooms_beds,policy]


    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true

        lblOptionDetails.text = option_details
        btnListed.setTitle(unlisted, for: .normal)
        tblOptionDetail.dataSource = self
        tblOptionDetail.delegate = self
        tblOptionDetail.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")

        if listModel.remaining_steps == "0"
        {
            btnListed.setTitle((listModel.isListEnabled == "Yes") ? "Unlisted" : "Listed", for: .normal)
            tblOptionDetail.tableFooterView = vwFooter
        }
        
        btnListed.layer.borderColor = UIColor.black.cgColor
        btnListed.layer.borderWidth = 1

    }
    
    // MARK:- TableView Method(s)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblOptionDetail.frame.size.width) ,height: 40)
        let lblRoomName:UILabel = UILabel()
        lblRoomName.frame =  CGRect(x: 0, y:20, width: viewHolder.frame.size.width ,height: 40)

        if section == 0 {
            lblRoomName.text=price
        }else {
            lblRoomName.text=details_l

        }
        viewHolder.backgroundColor = self.view.backgroundColor
        lblRoomName.textAlignment = NSTextAlignment.center
        lblRoomName.textColor = UIColor.darkGray
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return arrPrice.count
        }
        else
        {
            return arrDetails.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        cell.lblCurrency.textColor = UIColor.darkGray
        cell.lblCurrency.font = cell.lblCurrency.font.withSize(15)
        cell.accessoryType = .disclosureIndicator
        if indexPath.section == 0 {
            cell.lblCurrency?.text = arrPrice[indexPath.row]
            if indexPath.row == 1{
                cell.lblCurrencySign.isHidden = false
                cell.lblCurrencySign.text = listModel.currency_code
                cell.lblCurrencySign.textColor = UIColor.black
                cell.lblCurrencySign.isUserInteractionEnabled = false
            }
        } else {
            cell.lblCurrency?.text = arrDetails[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.additionalPriceTapped()
            } else if indexPath.row == 1 {
                self.currencyTapped()
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.aboutListingsTapped()
            } else if indexPath.row == 1 {
                self.amenitiesTapped()
            } else if indexPath.row == 2 {
                self.roomsAndBedsTapped()
            } else if indexPath.row == 3 {
                self.bookingTypeTapped()
            }
        }
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Custom Method(s)
    
    func additionalPriceTapped() {
        let vc = AdditionalPriceVC(nibName: "AdditionalPriceVC", bundle: nil)
        vc.listModel = self.listModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func currencyTapped() {
        let vc = CurrencyVC(nibName: "CurrencyVC", bundle: nil)
        vc.delegate = self
        vc.strTitle = "Currency"
        vc.strApiMethodName = API_UPDATE_ROOM_CURRENCY
        vc.strCurrentCurrency = listModel.currency_code as String
        vc.listModel = listModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func aboutListingsTapped() {
        let vc = AboutListingVC(nibName: "AboutListingVC", bundle: nil)
        vc.strRoomId = (appDelegate?.strRoomID)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func amenitiesTapped() {
        let vc = AmenitiesVC(nibName: "AmenitiesVC", bundle: nil)
        if listModel.selected_amenities_id.characters.count > 0 {
            let arr = (listModel.selected_amenities_id as String).components(separatedBy: ",")
            vc.arrSelectedItems =  NSMutableArray(array: arr)
        }
        vc.listModel = self.listModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func roomsAndBedsTapped() {
        let vc = RoomsAndBedsVC(nibName: "RoomsAndBedsVC", bundle: nil)
        vc.listModel = self.listModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func bookingTypeTapped() {
        let vc = BookingTypeVC(nibName: "BookingTypeVC", bundle: nil)
        vc.arrListing = ["Flexible","Moderate","Strict"]
        vc.strCurrentPolicy = listModel.policy_type
        vc.listModel = self.listModel
        vc.txtTitle = "Policy"
        vc.isBooking = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func changeButtonStatus()
    {
        self.btnListed.isUserInteractionEnabled = true
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.isListEnabled = listModel.isListEnabled == "Yes" ? "No" : "Yes"
        self.listModel = tempModel
        btnListed.setTitle((listModel.isListEnabled == "Yes") ? "Unlisted" : "Listed", for: .normal)
        delegate?.RoomCurrencyChanged(listModel: listModel)
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnListedClicked(_ sender: UIButton) {
        self.listUnlistRoom()
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK:- Currency Change Delegate Method(s)
    
    func updateBookTypeOrPolicy(_ strDescription: String) {
        var tempModel = ListingModel()
        tempModel = self.listModel
        tempModel.policy_type = strDescription
        self.listModel = tempModel
    }
    
    func roomCurrencyChanged(_ strCurrencyCode: String, strCurrencySymbol: String) {
        var tempModel = ListingModel()
        tempModel = self.listModel
        tempModel.currency_code = strCurrencyCode
        tempModel.currency_symbol = strCurrencySymbol
        self.listModel = tempModel
        tblOptionDetail.reloadData()
    }
    
    func updateRoomPrice(_ modelList : ListingModel) {
        self.listModel = modelList
    }
    
    // MARK:- Api calling
    func listUnlistRoom(){
        let dict = NSMutableDictionary()
        ProgressHud.shared.Animation = true
        dict["room_id"] = appDelegate?.strRoomID
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_DISABLE_LISTING, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    self.changeButtonStatus()
                }
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            ProgressHud.shared.Animation = false
        }
    }
    
}
