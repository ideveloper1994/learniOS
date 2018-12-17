//
//  ContactHostVC.swift
//  Arheb
//
//  Created on 13/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ContactHostVC: UIViewController, UITableViewDataSource, UITableViewDelegate, WWCalendarTimeSelectorProtocol, AddGuestDelegate, AddMessageDelegate {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var vwBottom: UIView!
    @IBOutlet var tblContactHost: UITableView!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var btnHostThumb: UIButton!
    @IBOutlet var txtRoomType: UITextView!
    
    var strHostThumbUrl = ""
    var strRoomType = ""
    var strHostUserName = ""
    var strAdult = "1 Guests"
    var strMessage = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var strHostUserId:String = ""
    var strCheckInDate = ""
    var strCheckOutDate = ""
    var strRoomId = ""
    var strTotalGuest = ""
    var modelRoomDetails : RoomDetailModel!
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
   
    // MARK:- View Method(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblContactHost.dataSource = self
        self.tblContactHost.delegate = self
        self.tblContactHost.register(UINib(nibName: "ContactHostCell", bundle: nil), forCellReuseIdentifier: "contactHostCell")
        self.tblContactHost.tableFooterView = UIView()
        self.tblContactHost.tableHeaderView = vwHeader
        btnHostThumb?.layer.cornerRadius = (btnHostThumb?.frame.size.width)!/2
        btnHostThumb?.clipsToBounds = true
        let imgHost = UIImageView()
        imgHost.sd_setImage(with: URL(string: strHostThumbUrl), placeholderImage:UIImage(named:""))
        btnHostThumb.setImage(imgHost.image, for: .normal)
        txtRoomType?.text = String(format:"%@ hosted by %@",strRoomType,strHostUserName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func handleBtnClose(_ sender: UIButton!) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func handleBtnSend(_ sender: Any) {
        self.saveContact()
    }
    
    @IBAction func handleHostThumb(_ sender: Any) {
        let vc = ProfileDetailVC(nibName: "ProfileDetailVC", bundle: nil)
        vc.otherUserId = strHostUserId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- API Calling Method(s)
    
    func saveContact() {
        ProgressHud.shared.Animation = true
        let dict = NSMutableDictionary()
        dict["room_id"] = strRoomId
        dict["check_in_date"] = strCheckInDate
        dict["check_out_date"] = strCheckOutDate
        dict["no_of_guest"] = strAdult.replacingOccurrences(of: " Guests", with: "")
        dict["message_to_host"] = strMessage
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_CONTACT_HOST, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    self.handleBtnClose(nil)
                }
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    // MARK:- Custom Method(s)
    
    func onTapDate() {
        let vc = WWCalendarTimeSelector(nibName: "WWCalendarTimeSelector", bundle: nil)
        vc.delegate = self
        vc.optionCurrentDate = singleDate
        vc.optionCurrentDates = Set(multipleDates)
        vc.isFromExplorePage = true
        if modelRoomDetails.blocked_dates != nil {
            if modelRoomDetails.blocked_dates.count > 0 {
                vc.arrBlockedDates = modelRoomDetails.blocked_dates as! NSMutableArray
            }
        }
        vc.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        vc.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
        vc.optionSelectionType = WWCalendarTimeSelectorSelection.range
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func onTapGuest() {
        let vc = GuestVC(nibName: "GuestVC", bundle: nil)
        vc.delegate = self
        vc.nCurrentGuest = (strAdult.characters.count > 0) ? Int(strAdult.replacingOccurrences(of: " Guests", with: "") as String)! : 1
        vc.nMaxGuestCount = Int(strTotalGuest)!
        present(vc, animated: true, completion: nil)
    }
    
    func onTapAddMessage() {
        let vc = AddMessageVC(nibName: "AddMessageVC", bundle: nil)
        vc.urlHostImg = strHostThumbUrl
        vc.strHostUserId = strHostUserId
        vc.strMessage = strMessage
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func checkSaveButtonStatus() {
        if multipleDates.count > 0 && strAdult.replacingOccurrences(of: " Guests", with: "").characters.count > 0 {
            btnSend.isUserInteractionEnabled = true
            btnSend.alpha = 1.0
        } else {
            btnSend.isUserInteractionEnabled = false
            btnSend.alpha = 0.7
        }
    }
    
    // MARK:- TableView Method(s)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblContactHost.dequeueReusableCell(withIdentifier: "contactHostCell")! as! ContactHostCell
        cell.lblTitle?.text = (indexPath.row == 0) ? "Date" : (indexPath.row == 1) ? "Guests" : "Your Message"
        cell.lblSubTitle?.text = (indexPath.row == 0) ? "" : (indexPath.row == 1) ? (strAdult.characters.count > 0 ? strAdult : "1 Guests") : strMessage.characters.count > 0 ? strMessage : "Hosts appreciate a thoughtful hello"
        cell.lblDescription?.text = (indexPath.row == 0) ? multipleDates.count > 0 ? "Done" : "Add" : (indexPath.row == 1) ? (strAdult.characters.count > 0 ? "Done" : "Change")  : strMessage.characters.count > 0 ? "Done" : "Add"
        var rectViewRule = cell.vwHolder?.frame
        rectViewRule?.origin.y = (indexPath.row == 0) ? 20 : 12
        cell.vwHolder?.frame = rectViewRule!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.onTapDate()
        case 1:
            self.onTapGuest()
        default:
            self.onTapAddMessage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  indexPath.row == 0 ? 70 : indexPath.row == 1 ? 85 : 85
    }
    
    // MARK:- Guest Delegste Method(s)
    
    func onGuestAdded(adults:Int,child:Int) {
        strAdult = String(format: "%d Guests", adults+child)
        tblContactHost.reloadData()
        checkSaveButtonStatus()
    }
    
    // MARK:- Calendar Delegate Method(s)
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        multipleDates = dates
        let formalDates = dates
        let startDay = formalDates[0]
        let lastDay = formalDates.last
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyy"
        strCheckInDate = dateFormatter.string(from: startDay)
        if formalDates.count == 1 {
            let startDay = formalDates[0]
            let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
            strCheckOutDate = dateFormatter.string(from: (start)!)
        } else {
            strCheckOutDate = dateFormatter.string(from: lastDay!)
        }
        checkSaveButtonStatus()
        tblContactHost.reloadData()
    }
    
    // MARK:- Add Message Delegate Method(s)
    
    func onMessageAdded(messsage: String) {
        strMessage = messsage
        tblContactHost.reloadData()
        checkSaveButtonStatus()
    }
}
