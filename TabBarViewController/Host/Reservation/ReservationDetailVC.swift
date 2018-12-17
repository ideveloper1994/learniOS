//
//  ReservationDetailVC.swift
//  Arheb
//
//  Created on 30/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ReservationDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- IBOutlet(s)

    @IBOutlet var imgUserThumb: UIImageView!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblMemberFrom: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var lblRoomName: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var tblReservationDetails: UITableView!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var vwTopBar: UIView!
    @IBOutlet var btnPreAccept: UIButton?

    var arrTitle = [String]()
    var arrPlaceHolderTitle = [String]()
    var arrPrice = [String]()
    var arrPirceDesc = [String]()
    var modelReservationData : ReservationModel!
    var nTotalRow:Int = 0
    var isFromGuestInbox : Bool = false
    var modelTripData : TripsModel!
    var strTripsType : String = ""
    
    // MARK: - UIView Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTable()
        btnPreAccept?.setTitle(pre_accept, for: .normal)
        self.setReservationInfo()
        imgUserThumb?.layer.cornerRadius = (imgUserThumb?.frame.size.height)! / 2
        imgUserThumb?.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "preacceptchanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reservationCancelled), name: NSNotification.Name(rawValue: "CancelReservation"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - TableView Method(s)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nTotalRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationDetailsRoomCell") as! ReservationDetailsRoomCell
            if modelReservationData != nil {
                cell.imgRoomThumb?.sd_setImage(with: NSURL(string: modelReservationData.room_image as String)! as URL, placeholderImage:UIImage(named:""))
                cell.lblRoomname?.text = modelReservationData.room_name as String
            } else {
                cell.imgRoomThumb?.sd_setImage(with: NSURL(string: modelTripData.room_image as String)! as URL, placeholderImage:UIImage(named:""))
                cell.lblRoomname?.text = modelTripData.room_name as String
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationDetailsCell") as! ReservationDetailsCell
            cell.lblTitleName?.text = arrTitle[indexPath.row]
            cell.lblDetails?.text = arrPlaceHolderTitle[indexPath.row]
            if modelReservationData != nil {
                cell.imghAccessory?.isHidden = (indexPath.row == 4 && modelReservationData.can_view_receipt == yes) ? false : true
            } else {
                cell.imghAccessory?.isHidden = (indexPath.row == 4 && modelTripData.can_view_receipt == yes) ? false : true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return  289
        } else {
            return 77
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if modelReservationData != nil {
            if isFromGuestInbox {
                if indexPath.row == 3 {
                    gotoRoomDetailPage()
                } else if arrTitle[indexPath.row] as String == decline {
                    gotoCancelRequestPage(index: indexPath.row)
                }
                if arrTitle[indexPath.row] as String == discuss {
                    gotoMessageHistory()
                }
            } else {
                if indexPath.row == 3 {
                    self.gotoRoomDetailPage()
                } else if (indexPath.row == 4 && modelReservationData.can_view_receipt == yes) {
                    gotoReceiptPage()
                } else if (modelReservationData.trip_status == pending || modelReservationData.trip_status == accepted) {
                    if indexPath.row == 5 {
                        self.gotoCancelRequestPage(index: indexPath.row)
                    } else if indexPath.row == 6 {
                        self.gotoMessageHistory()
                    }
                } else {
                    if indexPath.row == 5 {
                        self.gotoMessageHistory()
                    }
                }
            }
        } else {
            if (strTripsType == "pending_trips" || strTripsType == "current_trips" || (strTripsType == "upcoming_trips" && modelTripData.trip_status as String != "Expired")) {
                if indexPath.row == 5 {
                    self.gotoCancelRequestPage(index: indexPath.row)
                } else if indexPath.row == 6 {
                    gotoMessageHistory()
                }
            } else {
                if indexPath.row == 5 {
                    self.gotoMessageHistory()
                }
            }
            if indexPath.row == 3 {
                gotoRoomDetailPage()
            } else if (indexPath.row == 4 && modelTripData.can_view_receipt == "Yes") {
                gotoReceiptPageTrip()
            }
        }
    }
    
    // MARK: - Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - IBOutlet Method(s)
    
    @IBAction func onPreAcceptTapped(sender: UIButton) {
        if modelReservationData != nil {
            let preView = PreAcceptVC(nibName: "PreAcceptVC", bundle: nil)
            preView.strReservationId = modelReservationData.reservation_id as String
            preView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(preView, animated: true)
        }else{
            let tripModel = modelTripData
            let viewWeb = LoadWebView(nibName: "LoadWebView", bundle: nil)
            viewWeb.hidesBottomBarWhenPushed = true
            viewWeb.strPageTitle = "Payment"
            let authToken = KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken)
            viewWeb.strWebUrl = String(format:"%@%@?reservation_id=%@&token=%@",baseUrl,API_PAY_NOW,(tripModel?.reservation_id)!,authToken!)
            self.navigationController?.pushViewController(viewWeb, animated: true)
        }
        
    }
    
    @IBAction func onHostProfileTapped(_ sender: Any) {
        let vc = ProfileDetailVC(nibName: "ProfileDetailVC", bundle: nil)
        vc.otherUserId = modelReservationData.guest_users_id 
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK:- Custom Method(s)
    
    func makeSpecialPricesTrips() {
        let currencySymbol = GETVALUE(USER_CURRENCY_SYMBOL) as String
        let strAdditionalGuest = String(format:"%@ %@",currencySymbol,modelTripData.addition_guest_fee)
        let strsecurity_deposit = String(format:"%@ %@",currencySymbol,modelTripData.security_fee)
        let strcleaning_fee = String(format:"%@ %@",currencySymbol,modelTripData.cleaning_fee)
        arrPrice = [String]()
        arrPirceDesc = [String]()
        if modelTripData.addition_guest_fee != "0" && modelTripData.addition_guest_fee != "" {
            arrPrice.append(strAdditionalGuest)
            arrPirceDesc.append(additional_guest_fee)
        }
        if modelTripData.security_fee != "0" && modelTripData.security_fee != "" {
            arrPrice.append(strsecurity_deposit)
            arrPirceDesc.append(security_fee)
        }
        if modelTripData.cleaning_fee != "0" && modelTripData.cleaning_fee != "" {
            arrPrice.append(strcleaning_fee)
            arrPirceDesc.append(cleaning_fee)
        }
    }
    
    func setUpTable() {
        self.tblReservationDetails.dataSource = self
        self.tblReservationDetails.delegate = self
        self.tblReservationDetails.register(UINib(nibName: "ReservationDetailsCell", bundle: nil), forCellReuseIdentifier: "ReservationDetailsCell")
        self.tblReservationDetails.register(UINib(nibName: "ReservationDetailsRoomCell", bundle: nil), forCellReuseIdentifier: "ReservationDetailsRoomCell")
    }
    
    func handlebackButton(){
        
    }
    
    func setReservationInfo() {
        if modelReservationData != nil {
            btnPreAccept?.isHidden = (self.modelReservationData.trip_status == pending) ? false : true
            let strCurrency = GETVALUE(USER_CURRENCY_SYMBOL) as String
            lblStatus.text = modelReservationData.trip_status as String
            lblDetail.text = String(format:"%@ guests · %@ nights · %@ %@",modelReservationData.guest_count,modelReservationData.total_nights,strCurrency,modelReservationData.total_cost)
            lblRoomName?.text = modelReservationData.room_name as String
            lblUserName.text = modelReservationData.guest_user_name as String
            lblLocation.text = modelReservationData.guest_user_location as String
            lblMemberFrom.text = modelReservationData.member_from as String
            lblRoomName?.text = modelReservationData.room_name as String
            tblReservationDetails.tableHeaderView = vwHeader
            imgUserThumb?.sd_setImage(with: NSURL(string: modelReservationData.guest_thumb_image as String)! as URL, placeholderImage:UIImage(named:""))
            nTotalRow = 7
            if modelReservationData.trip_status == pending {
                arrPlaceHolderTitle = [modelReservationData.check_in as String,modelReservationData.check_out as String,modelReservationData.guest_count as String," ",String(format:(modelReservationData.can_view_receipt == yes) ? "%@%@  ." :"%@%@",strCurrency,modelReservationData.total_cost),"",""]
                arrTitle = [checkin,checkout,guests_n1_guest,"",totalcost,decline,discuss]
            } else if modelReservationData.trip_status == accepted {
                arrPlaceHolderTitle = [modelReservationData.check_in as String,modelReservationData.check_out as String,modelReservationData.guest_count as String," ",String(format:(modelReservationData.can_view_receipt == yes) ? "%@%@  ." :"%@%@",strCurrency,modelReservationData.total_cost),"",""]
                arrTitle = [checkin,checkout,guests_n1_guest,"",totalcost,cancel,(isFromGuestInbox) ? discuss : message_history]
            } else {
                nTotalRow = 6
                arrPlaceHolderTitle = [modelReservationData.check_in as String,modelReservationData.check_out as String,modelReservationData.guest_count as String," ",String(format:(modelReservationData.can_view_receipt == "Yes") ? "%@%@  ." :"%@%@",strCurrency,modelReservationData.total_cost),""]
                arrTitle = [checkin,checkout,guests_n1_guest,"",totalcost,(isFromGuestInbox) ? discuss : message_history]
            }
            tblReservationDetails.reloadData()
        } else if modelTripData != nil {
            btnPreAccept?.isHidden = (modelTripData?.booking_status == "Available" && modelTripData?.trip_status != "Pending") ? false : true
            btnPreAccept?.setTitle(book_now, for: .normal)
            let strCurrency = GETVALUE(USER_CURRENCY_SYMBOL) as String
            lblStatus.text = String(format:"%@ nights in %@",modelTripData.total_nights,modelTripData.room_location)
            lblLocation.text = String(format:"Hosted by %@", modelTripData.host_user_name)
            lblMemberFrom.text = modelTripData.room_type as String
            lblDetail?.text = modelTripData.room_name as String
            tblReservationDetails.tableHeaderView = vwHeader
            imgUserThumb?.sd_setImage(with: NSURL(string: modelTripData.host_thumb_image as String) as URL?, placeholderImage:UIImage(named:""))
            imgUserThumb?.sd_setImage(with: NSURL(string: modelTripData.host_thumb_image as String) as URL?, placeholderImage:UIImage(named:""))
            nTotalRow = 7
            if modelTripData.trip_status != "Cancelled" && modelTripData.trip_status as String != "Expired" {
                if strTripsType == "pending_trips" {
                    arrPlaceHolderTitle = [modelTripData.check_in as String,modelTripData.check_out as String,modelTripData.guest_count as String," ",String(format:(modelTripData.can_view_receipt == "Yes") ? "%@%@  ." :"%@%@",strCurrency,modelTripData.total_cost),""," "]
                    arrTitle = ["Check-in","Checkout","Guests\n1 guest","","TotalCost","Cancel Request","Message History"]
                } else if (strTripsType == "current_trips") {
                    arrPlaceHolderTitle = [modelTripData.check_in as String,modelTripData.check_out as String,modelTripData.guest_count as String," ",String(format:(modelTripData.can_view_receipt == "Yes") ? "%@%@  ." :"%@%@",strCurrency,modelTripData.total_cost),""," "]
                    arrTitle = ["Check-in","Checkout","Guests\n1 guest","","TotalCost","Cancel","Message History"]
                } else if (strTripsType == "upcoming_trips") {
                    arrPlaceHolderTitle = [modelTripData.check_in as String,modelTripData.check_out as String,modelTripData.guest_count as String," ",String(format:(modelTripData.can_view_receipt == "Yes") ? "%@%@  ." :"%@%@",strCurrency,modelTripData.total_cost),""," "]
                    arrTitle = ["Check-in","Checkout","Guests\n1 guest","","TotalCost","Cancel","Message History"]
                } else if strTripsType == "previous_trips" {
                    nTotalRow = 6
                    arrPlaceHolderTitle = [modelTripData.check_in as String,modelTripData.check_out as String,modelTripData.guest_count as String," ",String(format:(modelTripData.can_view_receipt == "Yes") ? "%@%@  ." :"%@%@",strCurrency,modelTripData.total_cost)," "]
                    arrTitle = ["Check-in","Checkout","Guests\n1 guest","","TotalCost","Message History"]
                }
            } else {
                nTotalRow = 6
                arrPlaceHolderTitle = [modelTripData.check_in as String,modelTripData.check_out as String,modelTripData.guest_count as String," ",String(format:(modelTripData.can_view_receipt == "Yes") ? "%@%@  ." :"%@%@",strCurrency,modelTripData.total_cost)," "]
                arrTitle = ["Check-in","Checkout","Guests\n1 guest","","TotalCost","Help"]
            }
        }
    }

    func reservationCancelled() {
        var tempModel = ReservationModel()
        tempModel = modelReservationData
        tempModel.trip_status = (arrTitle[5] as String == decline) ? declined : cancelled
        modelReservationData = tempModel
        self.setReservationInfo()
    }
    
    func PreAcceptChanged() {
        btnPreAccept?.isHidden = true
        var tempModel = ReservationModel()
        tempModel = modelReservationData
        tempModel.trip_status = pre_accepted
        modelReservationData = tempModel
        self.setReservationInfo()
    }

    func gotoCancelRequestPage(index: Int) {
        let viewWeb = CancelReservationVC(nibName: "CancelReservationVC", bundle: nil)
        var fromTrip = false
        if modelReservationData != nil{
            viewWeb.strReservationId = modelReservationData.reservation_id as String
        }else{
            viewWeb.strReservationId = modelTripData.reservation_id as String
            fromTrip = true
        }
        var arrCancelTitle = [String]()
        viewWeb.strButtonTitle = cancel_reservation
        if (fromTrip ? modelTripData.trip_status : modelReservationData.trip_status) == accepted{
            viewWeb.strMethodName = API_CANCEL_RESERVATION
            arrCancelTitle = [why_are_you_cancelling,my_place_is_longer_available,i_want_to_offer,my_place_needs_maintenance,i_have_an_extenuating_circumstance,my_guest_needs_to_cancel,other]
        } else {
            if arrTitle[index] as String == decline {
                viewWeb.strMethodName = API_DECLINE_RESERVATION
                arrCancelTitle = [why_are_you_declining,dates_are_not_available,i_do_not_feel_comfortable,my_listing_is_not_good,waiting_for_more_attractive_reservation,guest_is_asking_for_different_dates,this_message_is_spam,other]
            } else {
                viewWeb.strMethodName = API_CANCEL_RESERVATION
                arrCancelTitle = [why_are_you_declining,no_longer_need_accommodations,my_travel_dates_changed,i_made_the_reservation_by_accident,i_have_an_extenuating_circumstance,my_host_needs_to_cancel,i_m_uncomfortable_with_the_host,the_place_isnt_what_i_was_expecting,other]
            }
        }
        viewWeb.arrCancelTitles = arrCancelTitle
        viewWeb.hidesBottomBarWhenPushed = true
        present(viewWeb, animated: true, completion: nil)
    }
    
    func gotoMessageHistory() {
        let viewEditProfile = ReservationHistoryVC(nibName: "ReservationHistoryVC", bundle: nil)
        viewEditProfile.hidesBottomBarWhenPushed = true
        if modelReservationData != nil {
            viewEditProfile.modelInboxData = modelReservationData
        } else {
            viewEditProfile.modelTripsInboxData = modelTripData
        }
        viewEditProfile.isInbox = false
        self.navigationController?.pushViewController(viewEditProfile, animated: true)
    }
    
    func gotoReceiptPageTrip() {
        makeSpecialPricesTrips()
        let guestView = TotalCostVC(nibName: "TotalCostVC", bundle: nil)
        guestView.arrPrice = arrPrice
        guestView.arrPirceDesc = arrPirceDesc
        guestView.strLocationName = modelTripData.room_location as String
        guestView.strServiceFee =  modelTripData.service_fee as String
        guestView.strTotalNights = modelTripData.total_nights as String
        guestView.strPageTitle = customer_receipt
        let currencySymbol = GETVALUE(USER_CURRENCY_SYMBOL) as String
        guestView.strTotalPrice = attributedTextboldText(String(format:"%@ %@",currencySymbol, modelTripData.total_cost as String) as NSString, boldText: String(format:"%@ %@",currencySymbol, modelTripData.total_cost as String) as String, fontSize: 22.0)
        guestView.strPriceDetail = modelTripData.per_night_price as String
        guestView.strCurrency = GETVALUE(USER_CURRENCY_SYMBOL) as String
        present(guestView, animated: true, completion: nil)
    }
    
    func gotoRoomDetailPage() {
        let vc = ProductDetail_VC(nibName: "ProductDetail_VC", bundle: nil)
        vc.roomId = modelReservationData != nil ? modelReservationData.room_id : modelTripData.room_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoReceiptPage() {
        makeSpecialPrices()
        let guestView = TotalCostVC(nibName: "TotalCostVC", bundle: nil)
        guestView.arrPrice = arrPrice
        guestView.arrPirceDesc = arrPirceDesc
        guestView.strLocationName = modelReservationData.room_location
        guestView.strServiceFee =  modelReservationData.service_fee
        guestView.strTotalNights = modelReservationData.total_nights
        guestView.strPageTitle = customer_receipt
        let currencySymbol = GETVALUE(USER_CURRENCY_SYMBOL)
        guestView.strTotalPrice = attributedTextboldText(String(format:"%@ %@",currencySymbol, modelReservationData.total_cost as String) as NSString, boldText: String(format:"%@ %@",currencySymbol, modelReservationData.total_cost as String) as String, fontSize: 22.0)
        guestView.strPriceDetail = modelReservationData.per_night_price
        guestView.strCurrency = GETVALUE(USER_CURRENCY_SYMBOL)
        present(guestView, animated: true, completion: nil)
    }
    
    func makeSpecialPrices() {
        let currencySymbol = GETVALUE(USER_CURRENCY_SYMBOL) as String
        let strAdditionalGuest = String(format:"%@ %@",currencySymbol,modelReservationData.additional_guest_fee)
        let strsecurity_deposit = String(format:"%@ %@",currencySymbol,modelReservationData.security_deposit)
        let strcleaning_fee = String(format:"%@ %@",currencySymbol,modelReservationData.cleaning_fee)
        arrPrice = [String]()
        arrPirceDesc = [String]()
        if modelReservationData.additional_guest_fee != "0" && modelReservationData.additional_guest_fee != "" {
            arrPrice.append(strAdditionalGuest)
            arrPirceDesc.append(additional_guest_fee)
        }
        if modelReservationData.security_deposit != "0" && modelReservationData.security_deposit != "" {
            arrPrice.append(strsecurity_deposit)
            arrPirceDesc.append(security_fee)
        }
        if modelReservationData.cleaning_fee != "0" && modelReservationData.cleaning_fee != "" {
            arrPrice.append(strcleaning_fee)
            arrPirceDesc.append(cleaning_fee)
        }
    }
}
