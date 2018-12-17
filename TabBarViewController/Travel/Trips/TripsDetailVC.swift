//
//  TripsDetailVC.swift
//  Arheb
//
//  Created on 6/9/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

class TripsDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var lbHeaderTitle: UILabel!
    @IBOutlet var lbHeaderSpec: UILabel!
    @IBOutlet var animatingLoader: FLAnimatedImageView!
    @IBOutlet var tblTripsDetails: UITableView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var vwHeader: UIView!
    
    var arrTripDetails: NSMutableArray = NSMutableArray()
    var strTripsType : String = ""
    var strHeaderTitle : String = ""
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDotLoader(animatingLoader)
        tblTripsDetails.tableHeaderView = vwHeader
        tblTripsDetails.register(UINib(nibName: "HostInboxCell", bundle: nil), forCellReuseIdentifier: "HostInboxCell")
        self.lbHeaderTitle.text = strHeaderTitle
        self.getTripsDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.getTripsDetails()
    }
    
    // MARK:- TableView Method(s)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTripDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblTripsDetails.dequeueReusableCell(withIdentifier: "HostInboxCell", for: indexPath) as! HostInboxCell
        let tripModel = arrTripDetails[indexPath.row] as? TripsModel
        cell.btnPreAccept?.setTitle("Book now", for: .normal)
        cell.btnPreAccept?.layer.masksToBounds = true
        cell.btnPreAccept?.layer.cornerRadius  = 3.0
        cell.lblUserName?.text = tripModel?.host_user_name
        cell.lblTripDate?.text = tripModel?.trip_date.replacingOccurrences(of: "to", with: "-")
        cell.btnPreAccept?.isHidden = (tripModel?.booking_status == "Available" && tripModel?.trip_status != "Pending") ? false : true
        cell.btnPreAccept?.addTarget(self, action: #selector(self.onBookNowTapped), for: UIControlEvents.touchUpInside)
        cell.lblDetails?.text = tripModel?.room_name
        cell.lblLocation?.text = tripModel?.room_location
        cell.imgUserThumb?.layer.cornerRadius = (cell.imgUserThumb?.frame.size.height)! / 2
        cell.imgUserThumb?.sd_setImage(with: NSURL(string: (tripModel?.host_thumb_image)!)! as URL, placeholderImage:UIImage(named:""))
        cell.imgUserThumb?.clipsToBounds = true
        cell.lblTripStatus?.text = tripModel?.trip_status
        if tripModel?.trip_status == "Cancelled" || tripModel?.trip_status == "Declined" || tripModel?.trip_status == "Expired" {
            cell.lblTripStatus?.textColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
        } else if tripModel?.trip_status == "Accepted" {
            cell.lblTripStatus?.textColor = UIColor(red: 63.0 / 255.0, green: 179.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
        } else if tripModel?.trip_status == "Pre-Accepted" || tripModel?.trip_status == "Inquiry" {
            cell.lblTripStatus?.textColor = UIColor.darkGray
        } else if tripModel?.trip_status == "Pending" {
            cell.lblTripStatus?.textColor = UIColor(red: 255.0 / 255.0, green: 180.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }
        return cell
    }
    func onBookNowTapped(sender: UIButton)
    {
        let tripModel = arrTripDetails[sender.tag] as? TripsModel
        let viewWeb = LoadWebView(nibName: "LoadWebView", bundle: nil)
        viewWeb.hidesBottomBarWhenPushed = true
        viewWeb.strPageTitle = "Payment"
        let authToken = KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken)
        viewWeb.strWebUrl = String(format:"%@%@?reservation_id=%@&token=%@",baseUrl,API_PAY_NOW,(tripModel?.reservation_id)!,authToken!)
        //        print(viewWeb.strWebUrl)
        self.navigationController?.pushViewController(viewWeb, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ReservationDetailVC(nibName: "ReservationDetailVC", bundle: nil)
        let msgModel = arrTripDetails[indexPath.row] as? TripsModel
        vc.modelTripData = msgModel
        vc.strTripsType = strTripsType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: API call for get trips details
    
    func getTripsDetails() {
        let dicts = NSMutableDictionary()
        dicts["trips_type"] = strTripsType
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_TRIPS_DETAILS, params: dicts, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil) {
                    showToastMessage(error!)
                }else{
                    if response != nil {
                        self.tblTripsDetails.stopPullRefreshEver()
                        let result = response as! NSDictionary
                        let generalModel = GeneralModel().addResponseToModel(res: result)
                        if generalModel.status_code == "1" && result.count > 0 {
                            if self.arrTripDetails.count > 0 {
                                self.arrTripDetails.removeAllObjects()
                            }
                            self.arrTripDetails.addObjects(from: TripsModel().initiateTripsData(jsonData: result, tripType: self.strTripsType))
                            if self.arrTripDetails.count > 0 {
                                self.tblTripsDetails.reloadData()
                                self.tblTripsDetails.isHidden = false
                                self.tblTripsDetails.reloadData()
                                self.animatingLoader?.isHidden = true
                            } else {
                                self.tblTripsDetails.isHidden = true
                            }
                        }
                        if self.arrTripDetails.count>0 {
                            self.lbHeaderSpec.text = String(format: "You have %d %@",self.arrTripDetails.count,self.strHeaderTitle)
                        } else {
                            self.lbHeaderSpec.text = String(format: "You have no %@",self.strHeaderTitle)
                        }
                    }
                }
            }
        }) { (error) in
            OperationQueue.main.addOperation {
                self.animatingLoader?.isHidden = true
                ProgressHud.shared.Animation = false
                self.tblTripsDetails.stopPullRefreshEver()
            }
        }
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
