//
//  HostInboxVC.swift
//  Makent
//
//  Created on 30/05/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FLAnimatedImage

class HostInboxVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- IBOutlets
    
    @IBOutlet var vwNoReservation: UIView!
    @IBOutlet var tblHostInbox: UITableView!
    @IBOutlet var vwTableHeader: UIView!
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet var lblUnreaderStatus: UILabel!
    
    var arrReservationMsgs: NSMutableArray = NSMutableArray()
    
    
    let baseUrl = "http://makent.trioangle.com/api/"
    let WebServerUrl = "http://makent.trioangle.com/"
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tblHostInbox.register(UINib(nibName: "HostInboxCell", bundle: nil), forCellReuseIdentifier: "HostInboxCell")
        self.tblHostInbox.tableHeaderView = self.vwTableHeader
        self.tblHostInbox.tableFooterView = UIView()
        
        self.animatedLoader?.isHidden = false
        setDotLoader(animatedLoader)
        self.getInboxMessages()
        NotificationCenter.default.addObserver(self, selector: #selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "preacceptchanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "CancelReservation"), object: nil)
        
        tblHostInbox.addPullRefresh { [weak self] in
            self?.getInboxMessages()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- TableView Method(s)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReservationMsgs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostInboxCell", for: indexPath) as! HostInboxCell
        cell.imgUserThumb?.layer.cornerRadius = (cell.imgUserThumb?.frame.size.height)! / 2
        let msgModel = arrReservationMsgs[indexPath.row] as? ReservationModel
        cell.setReservationDetails(msgModel!)
        cell.btnPreAccept?.tag = indexPath.row
        cell.btnPreAccept?.addTarget(self, action: #selector(self.onPreAcceptTapped), for: UIControlEvents.touchUpInside)
        cell.imgUserThumb?.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = ReservationDetailVC(nibName: "ReservationDetailVC", bundle: nil)
        detailVC.hidesBottomBarWhenPushed = true
        let msgModel = arrReservationMsgs[indexPath.row] as? ReservationModel
        detailVC.modelReservationData = msgModel
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK:- API calling Method(s)
    
    func getInboxMessages() {
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_GET_RESERVATION, params: NSMutableDictionary(), isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    let result = response as! NSDictionary
                    if self.arrReservationMsgs.count > 0 {
                        self.arrReservationMsgs.removeAllObjects()
                    }
                    self.arrReservationMsgs.addObjects(from: ReservationModel().initiateReservationData(jsonData: result))
                    if self.arrReservationMsgs.count > 0 {
                        self.updateReadHeaderStatus(unreadCount: self.arrReservationMsgs.count)
                        self.tblHostInbox.reloadData()
                        self.vwNoReservation.isHidden = true
                        self.tblHostInbox.isHidden = false
                        self.tblHostInbox.reloadData()
                    } else {
                        self.vwNoReservation.isHidden = false
                        self.tblHostInbox.isHidden = true
                    }
                    self.tblHostInbox.stopPullRefreshEver()
                }
            }
        }) { (error) in
            OperationQueue.main.addOperation {
                self.animatedLoader?.isHidden = true
                ProgressHud.shared.Animation = false
                self.tblHostInbox.stopPullRefreshEver()
            }
        }
    }
    
    // MARK:- Custom Method(s)
    
    func onPreAcceptTapped(sender: UIButton) {
        let msgModel = arrReservationMsgs[sender.tag] as? ReservationModel
        let preView = PreAcceptVC(nibName: "PreAcceptVC", bundle: nil)
        preView.strReservationId = (msgModel?.reservation_id)!
        preView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(preView, animated: true)
    }
    
    func PreAcceptChanged() {
        getInboxMessages()
        if arrReservationMsgs.count > 0 {
            self.arrReservationMsgs.removeAllObjects()
            self.tblHostInbox.reloadData()
        }
    }
    
    func updateReadHeaderStatus(unreadCount: Int) {
        if unreadCount != 0 {
            self.lblUnreaderStatus.text = String(format: (unreadCount == 1) ? "\(you_have) \(unreadCount) \(reservation)" : "\(you_have) \(unreadCount) \(reservations)")
            self.vwNoReservation.isHidden = true
        } else {
            self.lblUnreaderStatus.text = you_have_no_reservation
            self.vwNoReservation.isHidden = false
        }
    }
    
}
