//
//  InboxVC.swift
//  Arheb
//
//  Created on 5/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FLAnimatedImage

class InboxVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblInbox:UITableView!
    @IBOutlet weak var vwTop:UIView!
    @IBOutlet weak var vwHeader:UIView!
    @IBOutlet weak var animationLoader:FLAnimatedImageView!
    @IBOutlet weak var btnExplore:UIButton!
    
    @IBOutlet var lblNoMessage: UILabel!
    
    var lastContentOffset: CGFloat = 0
    var arrInboxData = [InboxModel]()
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        registerCell()
        
        animationLoader.isHidden = false
        setDotLoader(animationLoader)
        getMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "preacceptchanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.declined), name: NSNotification.Name(rawValue: "CancelReservation"), object: nil)
    }
    
    func viewcustomization(){
        self.automaticallyAdjustsScrollViewInsets = false
        tblInbox.separatorColor = UIColor.clear
        self.navigationController?.navigationBar.isHidden = true
        tblInbox.tableHeaderView = vwHeader
        lblNoMessage.text = noMessageFount
        lblNoMessage.isHidden = true
    }
    
    func registerCell(){
        tblInbox.register(UINib(nibName: "InboxCell", bundle: nil), forCellReuseIdentifier: "InboxCell")
        tblInbox.addPullRefresh { [weak self] in
            self?.getMessages()
        }
    }
    
    //MARK: - UITableview Delegate & Datasource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInboxData.count>0 ? arrInboxData.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:InboxCell = tblInbox.dequeueReusableCell(withIdentifier: "InboxCell") as! InboxCell
        let objInbox:InboxModel = arrInboxData[indexPath.row]
        cell.configureCell(objInbox: objInbox)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objInbox = arrInboxData[indexPath.row]
        if objInbox.message_status == "Pending"{
            let objInbox = arrInboxData[indexPath.row]
            gotoReservationDetails(objInbox)
        }else{
            let viewEditProfile = ReservationHistoryVC(nibName: "ReservationHistoryVC", bundle: nil)
            viewEditProfile.hidesBottomBarWhenPushed = true
            
            viewEditProfile.inboxData = arrInboxData[indexPath.row]
            viewEditProfile.isInbox = true
            self.navigationController?.pushViewController(viewEditProfile, animated: true)
        }
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset < scrollView.contentOffset.y{
            if scrollView.contentOffset.y  >= 100{
                vwTop.isHidden = false
            }
            
        }else if self.lastContentOffset > scrollView.contentOffset.y{
            if scrollView.contentOffset.y  <= 100{
                vwTop.isHidden = true
            }
        }
    }
    
    //Notification Method
    func PreAcceptChanged()
    {
        getMessages()
    }
    func declined()
    {
        getMessages()
    }
    //MARK: - Custom Method
    func gotoReservationDetails(_ modelInboxData : InboxModel)
    {
        let  userDefaults = UserDefaults.standard
        
        let msgModel = ReservationModel()
        msgModel.trip_status = modelInboxData.message_status
        msgModel.guest_user_name = modelInboxData.host_user_name
        msgModel.check_in = modelInboxData.check_in_time
        msgModel.check_out = modelInboxData.check_out_time
        msgModel.room_name = modelInboxData.room_name
        msgModel.room_id = modelInboxData.room_id
        msgModel.guest_thumb_image = modelInboxData.host_thumb_image
        msgModel.guest_users_id = modelInboxData.host_user_id
        msgModel.reservation_id = modelInboxData.reservation_id
        msgModel.total_cost = modelInboxData.total_cost
        msgModel.reservation_id = modelInboxData.reservation_id
        msgModel.reservation_id = modelInboxData.reservation_id
        msgModel.room_image = modelInboxData.room_thumb_image
        msgModel.guest_count = modelInboxData.total_guest
        msgModel.total_nights = modelInboxData.total_nights
        msgModel.member_from = modelInboxData.host_member_since_from
        
        msgModel.currency_symbol = (userDefaults.object(forKey: USER_CURRENCY_SYMBOL_ORG) as! String)
        let viewEditProfile = ReservationDetailVC(nibName: "ReservationDetailVC", bundle: nil)
        viewEditProfile.hidesBottomBarWhenPushed = true
        viewEditProfile.isFromGuestInbox = true
        viewEditProfile.modelReservationData = msgModel
        self.navigationController?.pushViewController(viewEditProfile, animated: true)
    }
    
    //MARK: - IBAction Method
    @IBAction func btnExploreClicked(_ sender:Any){
        let tabbar:ArhebTabbar =  appDelegate?.window?.rootViewController as! ArhebTabbar
        tabbar.selectedIndex = 0
    }
    
    //MARK: - Api Calling
    func getMessages(){
        
        let param = NSMutableDictionary()
        param.setValue("inbox", forKey: "type")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_INBOX_RESERVATION, params: param, isTokenRequired: true, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else {
                    if(res != nil){
                        let resDic = res as! NSDictionary
                        if resDic.value(forKey: "data") != nil{
                            let arrData:NSArray = resDic.value(forKey: "data") as! NSArray
                            let objInbox = InboxModel()
                            if(self.arrInboxData.count>0){
                                self.arrInboxData.removeAll()
                            }
                            self.arrInboxData = objInbox.initiateInboxData(arrRes: arrData)
                            if(self.arrInboxData.count>0){
                                self.btnExplore.isHidden = true
                                self.tblInbox.reloadData()
                            }else{
                                self.btnExplore.isHidden = false
                                //                                self.tblInbox.isHidden = true
                            }
                        }
                    }
                }
                self.animationLoader.isHidden = true
                self.tblInbox.stopPullRefreshEver()
                if(self.arrInboxData.count == 0){
                    self.lblNoMessage.isHidden = false
                }else{
                    self.lblNoMessage.isHidden = true
                }
                
            }
        }) { (error) in
            self.tblInbox.stopPullRefreshEver()
            self.animationLoader.isHidden = true
            print(error)
            
        }
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
