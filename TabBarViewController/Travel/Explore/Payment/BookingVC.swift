//
//  BookingVC.swift
//  Arheb
//
//  Created on 6/13/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

class BookingVC: UIViewController,UITableViewDelegate,UITableViewDataSource,AddGuestDelegate,WWCalendarTimeSelectorProtocol,AddMessageDelegate,HouseRulesAgreeDelegate {
    
    @IBOutlet weak var tblBooking:UITableView!
    @IBOutlet weak var vwHeader:UIView!
    @IBOutlet weak var vwBottom:UIView!
    @IBOutlet weak var imgLoader:FLAnimatedImageView!
    @IBOutlet weak var lblSepratorOne:UILabel!
    @IBOutlet weak var lblSepratorTwo:UILabel!
    @IBOutlet weak var lblRooms:UILabel!
    @IBOutlet weak var lblDetail:UILabel!
    @IBOutlet weak var lblRoomName:UILabel!
    @IBOutlet weak var lblHosted:UILabel!
    @IBOutlet weak var lblHotelName:UILabel!
    @IBOutlet weak var lblHostName:UIButton!
    @IBOutlet weak var imgHost:UIButton!
    @IBOutlet weak var btnBook:UIButton!
    @IBOutlet weak var heightLblDetail:NSLayoutConstraint!
    @IBOutlet var vwPopup: UIView!
    
    var isFirstTime: Bool = true
    
    var modelPaymentDetails : PrePaymentModel!
    
    var strAboutHome:String = ""
    var strTotalGuest:String = ""
    var house_rules:String = ""
    var strHostUserId:String = ""
    var strLocationName:String = ""
    var strStartDate:String = ""
    var strEndDate:String = ""
    var strInstantBook:String = ""
    var strRoomID:String = ""
    var strRoomName:String = ""
    var strHostMessage:String = ""
    
    var nStepsLeft : Int = 3
    
    var arrPrice = [String]()
    var arrPirceDesc = [String]()
    var arrBlockedDates : NSMutableArray = NSMutableArray()
    
    fileprivate var singleDate: Date = Date()
    var multipleDates: [Date] = []
    var adults = 1
    var child = 0
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNsuserDefaultValue(value: "", key: "paymenttype")
        setNsuserDefaultValue(value: "", key: "hostmessage")
        viewcustomization()
        registerCell()
        
        btnBook?.setTitle((house_rules.characters.count>0) ? threeStepsLeft : twoStepsLeft, for: .normal)
        nStepsLeft = (house_rules.characters.count>0) ? 3 : 2
        
        lblHotelName.text = strRoomName
        
        imgLoader.isHidden = false
        setDotLoader(imgLoader)
        getPaymentInfo()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onPaymentTypeSelected()
    }
    func viewcustomization(){
        let height = onGetStringHeight(lblDetail.frame.size.width, strContent: strAboutHome as NSString, font: (lblDetail.font)!)
        heightLblDetail.constant = height
        tblBooking.tableFooterView = vwBottom
        tblBooking.tableHeaderView = vwHeader
        imgHost.layer.masksToBounds = true
        imgHost.layer.cornerRadius = 25
    }
    func registerCell(){
        tblBooking.register(UINib(nibName: "BookingCell", bundle: nil), forCellReuseIdentifier: "BookingCell")
    }
    
    //MARK: - Tabelview Delegate & Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelPaymentDetails == nil ? 0 : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BookingCell = tblBooking.dequeueReusableCell(withIdentifier: "BookingCell") as! BookingCell
        cell.btnGuest.addTarget(self, action: #selector(self.btnGuestClicked), for: .touchUpInside)
        cell.btnPrice.addTarget(self, action: #selector(self.btnPriceClicked), for: .touchUpInside)
        cell.btnWeek.addTarget(self, action: #selector(self.btnCalendarClicked), for: .touchUpInside)
        cell.btnNight.addTarget(self, action: #selector(self.btnCalendarClicked), for: .touchUpInside)
        cell.btnPayment.addTarget(self, action: #selector(self.btnPaymentClicked), for: .touchUpInside)
        cell.btnMessage.addTarget(self, action: #selector(self.btnMessageClicked), for: .touchUpInside)
        cell.btnHouseRule.addTarget(self, action: #selector(self.btnHouseRulesClicked), for: .touchUpInside)
        cell.setPaymentDetail(objPayment: modelPaymentDetails)
        cell.lblGuestCount.text = strTotalGuest
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return house_rules.isEmptyString() ? 510 : 571
    }
    
    //MARK: - IBAction Method
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnProfileClicked(_ sender: Any) {
        let vc = ProfileDetailVC(nibName: "ProfileDetailVC", bundle: nil)
        ProfileDetailVC.isProfileEdited = true
        vc.otherUserId = strHostUserId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBookClicked(_ sender: Any) {
        if nStepsLeft == 0
        {
            self.vwPopup.frame = self.view.frame
            self.view.addSubview(self.vwPopup)
        }
        
    }
    func btnGuestClicked(){
        let viewGuest = GuestVC(nibName: "GuestVC", bundle: nil)
        viewGuest.adults = self.adults
        viewGuest.child = self.child
        viewGuest.nMaxGuestCount = Int(self.modelPaymentDetails.rooms_total_guest)!
        viewGuest.delegate = self
        self.present(viewGuest, animated: true, completion: {})
    }
    func btnPriceClicked(){
        let guestView = TotalCostVC(nibName: "TotalCostVC", bundle: nil)
        guestView.arrPrice = arrPrice
        guestView.arrPirceDesc = arrPirceDesc
        guestView.strLocationName = strLocationName
        guestView.strServiceFee =  modelPaymentDetails.service_fee
        guestView.strTotalNights = modelPaymentDetails.nights_count
        guestView.strPageTitle = customer_receipt
        let currencySymbol = GETVALUE(USER_CURRENCY_SYMBOL)
        guestView.strTotalPrice = attributedTextboldText(String(format:"%@ %@",currencySymbol, modelPaymentDetails.total_price as String) as NSString, boldText: String(format:"%@ %@",currencySymbol, modelPaymentDetails.total_price as String) as String, fontSize: 22.0)
        guestView.strPriceDetail = modelPaymentDetails.per_night_price
        guestView.strCurrency = currencySymbol
        present(guestView, animated: true, completion: nil)
    }
    func btnCalendarClicked(){
        let selector = WWCalendarTimeSelector(nibName:"WWCalendarTimeSelector", bundle: nil)
        selector.room_Id = strRoomID
        selector.delegate = self
        selector.callAPI = true
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates)
        
        if arrBlockedDates.count > 0
        {
            selector.arrBlockedDates = arrBlockedDates
        }
        
        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
        selector.optionSelectionType = WWCalendarTimeSelectorSelection.range
        present(selector, animated: true, completion: nil)
    }
    func btnPaymentClicked(){
        let selectPaymentVC = SelectPaymentVC(nibName: "SelectPaymentVC", bundle: nil)
        self.navigationController?.pushViewController(selectPaymentVC, animated: true)
    }
    func btnMessageClicked(){
        let addMsgVC = AddMessageVC(nibName: "AddMessageVC", bundle: nil)
        addMsgVC.delegate = self
        self.present(addMsgVC, animated: true, completion: nil)
    }
    func btnHouseRulesClicked(){
        let viewHouseRule = HouseRulesVC(nibName: "HouseRulesVC", bundle: nil)
        viewHouseRule.hidesBottomBarWhenPushed = true
        viewHouseRule.delegate = self
        viewHouseRule.strHouseRules = house_rules
        viewHouseRule.strHostUserName = modelPaymentDetails.host_user_name as String
        present(viewHouseRule, animated: true, completion: nil)
    }
    
    //MARK: - Delegate Methods
    internal func onGuestAdded(adults:Int,child:Int) {
        self.adults = adults
        self.child = child
        strTotalGuest = String(format: "%d", adults+child)
        getPaymentInfo()
    }
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        multipleDates = dates
        
        let formalDates = dates
        let startDay = formalDates[0]
        //        let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
        let lastDay = formalDates.last
        //        let last = Calendar.current.date(byAdding: .day, value: 1, to: lastDay!)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyy"
        
        strStartDate = dateFormatter.string(from: startDay)
        strEndDate = dateFormatter.string(from: lastDay!)
        self.getPaymentInfo()
    }
    
    func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        /*
         appDelegate.makentTabBarCtrler.hidesBottomBarWhenPushed = false
         appDelegate.makentTabBarCtrler.view.isHidden = false
         */
    }
    internal func onMessageAdded(messsage:String)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let selectedCell = tblBooking.cellForRow(at: indexPath) as! BookingCell
        strHostMessage = messsage
        
        if selectedCell.lblHost.text == add
        {
            selectedCell.lblHost.text = done
            checkRemainingSteps()
        }
    }
    internal func onAgreeTapped() {
        let indexPath = IndexPath(row: 0, section: 0)
        let selectedCell = tblBooking.cellForRow(at: indexPath) as! BookingCell
        
        if selectedCell.lblHouseRules.text == read
        {
            selectedCell.lblHouseRules.text = agreed
            checkRemainingSteps()
        }
        
    }
    
    
    //MARK: - Api Call
    func getPaymentInfo(){
        let param = NSMutableDictionary()
        param.setValue(strRoomID, forKey: "room_id")
        param.setValue(strTotalGuest, forKey: "total_guest")
        param.setValue(strStartDate, forKey: "start_date")
        param.setValue(strEndDate, forKey: "end_date")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_PRE_PAYMENT, params: param, isTokenRequired: true, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    self.imgLoader.isHidden = true
                    if(res != nil){
                        let resDic = res as! NSDictionary
                        let objPrePayment = PrePaymentModel()
                        self.modelPaymentDetails = objPrePayment.addResponseToPayment(res: resDic)
                        if(self.isFirstTime){
                            self.manageHeader()
                            self.isFirstTime = false
                            self.vwBottom.isHidden = false
                        }
                        self.tblBooking.reloadData()
                    }
                }
            }
        }) { (error) in
            self.imgLoader.isHidden = true
            print(error)
            
        }
    }
    
    //MARK: - Custom Method
    func manageHeader(){
        lblSepratorOne.isHidden = false
        lblSepratorTwo.isHidden = false
        lblHosted.isHidden = false
        var bedRooms = ""
        var bathRooms = ""
        
        lblRoomName.text = modelPaymentDetails.room_type
        lblHotelName.text = modelPaymentDetails.room_name
        
        bedRooms = String(format: (modelPaymentDetails.no_of_bedrooms == "0" || modelPaymentDetails.no_of_bedrooms == "1") ? "%@ bedroom" : "%@ bedrooms",modelPaymentDetails.no_of_bedrooms)
        
        bathRooms = String(format: (modelPaymentDetails.no_of_bathrooms == "0" || modelPaymentDetails.no_of_bathrooms == "1") ? "%@ bathroom" : "%@ bathrooms",modelPaymentDetails.no_of_bathrooms)
        
        lblRooms.text = String(format: "%@ . %@",bedRooms,bathRooms)
        lblDetail.text = modelPaymentDetails.description_details as String
        imgHost.sd_setImage(with: URL(string: modelPaymentDetails.host_user_image), for: .normal)
        lblHostName.setTitle(modelPaymentDetails.host_user_name, for: .normal)
    }
    func makeSpecialPrices()
    {
        let currencySymbol = (modelPaymentDetails.currency_symbol as String).stringByDecodingHTMLEntities
        let strAdditionalGuest = String(format:"%@ %@",currencySymbol,modelPaymentDetails.addition_guest_fee)
        let strsecurity_deposit = String(format:"%@ %@",currencySymbol,modelPaymentDetails.security_fee)
        let strcleaning_fee = String(format:"%@ %@",currencySymbol,modelPaymentDetails.cleaning_fee)
        
        arrPrice = [String]()
        arrPirceDesc = [String]()
        if modelPaymentDetails.addition_guest_fee != "0" && modelPaymentDetails.addition_guest_fee != ""
        {
            arrPrice.append(strAdditionalGuest)
            arrPirceDesc.append(additional_guest_fee)
        }
        
        if modelPaymentDetails.security_fee != "0" && modelPaymentDetails.security_fee != ""
        {
            arrPrice.append(strsecurity_deposit)
            arrPirceDesc.append(security_fee)
        }
        
        if modelPaymentDetails.cleaning_fee != "0" && modelPaymentDetails.cleaning_fee != ""
        {
            arrPrice.append(strcleaning_fee)
            arrPirceDesc.append(cleaning_fee)
        }
    }
    func onPaymentTypeSelected()
    {
        let username:String = GETVALUE("paymenttype")
        if (!username.isEmptyString())
        {
            let indexPath = IndexPath(row: 0, section: 0)
            let selectedCell = tblBooking.cellForRow(at: indexPath) as! BookingCell
            
            if selectedCell.lblPaymentType.text == other
            {
                checkRemainingSteps()
            }
            
            selectedCell.lblPaymentType.text = username
        }
    }
    func checkRemainingSteps()
    {
        if nStepsLeft == 0
        {
            return
        }
        nStepsLeft = nStepsLeft - 1
        if nStepsLeft == 0
        {
            btnBook?.setTitle(String(format:(strInstantBook == "Yes") ? book_now : continueTxt,nStepsLeft), for: .normal)
        }
        else
        {
            btnBook?.setTitle(String(format:"%d %@",nStepsLeft,stepsLeft), for: .normal)
        }
    }
    
    //MARK: Popup view
    
    @IBAction func btnAceept(_ sender: Any) {
        self.vwPopup.removeFromSuperview()
        let viewWeb = LoadWebView(nibName: "LoadWebView", bundle: nil)
        viewWeb.hidesBottomBarWhenPushed = true
        viewWeb.strPageTitle = payment
        var strPaytype =  GETVALUE("paymenttype")
        //            strPaytype = strPaytype.replacingOccurrences(of: " ", with: "%20")
        let authToken = KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken)
        if (strInstantBook == "Yes")
        {
            viewWeb.strWebUrl = String(format:"%@%@?room_id=%@&card_type=%@&check_in=%@&check_out=%@&number_of_guests=%@&country=india&token=%@&payment_booking_type=instant_book&message=%@",baseUrl,API_BOOK_NOW,strRoomID,strPaytype,strStartDate,strEndDate,strTotalGuest,authToken!,strHostMessage)
        }
        else
        {
            viewWeb.strWebUrl = String(format:"%@%@?room_id=%@&card_type=%@&check_in=%@&check_out=%@&number_of_guests=%@&country=india&token=%@&message=%@",baseUrl,API_BOOK_NOW,strRoomID,strPaytype,strStartDate,strEndDate,strTotalGuest,authToken!,strHostMessage)
        }
        print(viewWeb.strWebUrl)
        self.navigationController?.pushViewController(viewWeb, animated: true)
    }
    
    @IBAction func btnClosePopup(_ sender: Any) {
        self.vwPopup.removeFromSuperview()
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
