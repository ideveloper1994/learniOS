//
//  HostListingVC.swift
//  Arheb
//
//  Created on 5/31/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

class HostListingVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var lblYourListing: UILabel!
    @IBOutlet var vwFooter: UIView!
    @IBOutlet var tblhostlisting: UITableView!
    @IBOutlet var animatedLoader: FLAnimatedImageView!
    @IBOutlet var vwAddList: UIView!
    
    var nPageNumber: Int = 1
    var arrListing: NSMutableArray = NSMutableArray()
    var isApiCalling: Bool = false
    var arrListedRooms: NSMutableArray = NSMutableArray()
    var arrUnListedRooms: NSMutableArray = NSMutableArray()
    var nSectionCount: Int = 0
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblhostlisting.delegate = self
        self.tblhostlisting.dataSource = self
        self.tblhostlisting.register(UINib(nibName: "HostListingCell", bundle: nil), forCellReuseIdentifier: "HostListingCell")
        self.tblhostlisting.tableFooterView = vwFooter
        isApiCalling = true
        self.getRoomsAPI(pageNumber: nPageNumber, isDelete: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getNewListing), name: NSNotification.Name(rawValue: "NewRoomAdded"), object: nil)
        setDotLoader(animatedLoader)
        tblhostlisting.addPullRefresh { [weak self] in
            self?.getNewListing()
        }
        self.localization()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    // MARK:- TableView Methos(s)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        if arrUnListedRooms.count > 0{
            count += 1
        }
        if arrListedRooms.count > 0{
            count += 1
        }
        //        if (arrListedRooms.count == 0 && arrUnListedRooms.count == 0) {
        print("total count\(count)")
        return count
        //        }
        //        return nSectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if arrUnListedRooms.count == 0 && arrListedRooms.count == 0 {
        //            return 1
        //        }
        if section == 0 {
            if(arrListedRooms.count > 0){
                return arrListedRooms.count
            }else if(arrUnListedRooms.count > 0){
                 return arrUnListedRooms.count
            }
        } else {
            return arrUnListedRooms.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostListingCell", for: indexPath) as! HostListingCell
        if indexPath.section == 0 {
            if(arrListedRooms.count > 0){
                let listModel = arrListedRooms[indexPath.row] as? ListingModel
                cell.setRoomDatas(modelListing: listModel!)
            }else if(arrUnListedRooms.count>0){
                let listModel = arrUnListedRooms[indexPath.row] as? ListingModel
                cell.setRoomDatas(modelListing: listModel!)
            }            
        } else {
            let listModel = arrUnListedRooms[indexPath.row] as? ListingModel
            cell.setRoomDatas(modelListing: listModel!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if arrUnListedRooms.count == 0 && arrListedRooms.count == 0 {
            return nil
        }
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblhostlisting.frame.size.width) ,height: 40)
        let lblRoomName:UILabel = UILabel()
        lblRoomName.frame =  CGRect(x: 10, y:10, width: viewHolder.frame.size.width-10 ,height: 40)
        if section == 0 {
            lblRoomName.text = (arrListedRooms.count > 0) ? listed : unlisted
        } else if section == 1 {
            lblRoomName.text = unlisted
        }
        viewHolder.backgroundColor = UIColor.white
        lblRoomName.textAlignment = NSTextAlignment.left
        lblRoomName.textColor = UIColor.darkGray
        lblRoomName.font = UIFont (name: "CircularAirPro-Light", size: 17)!
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if arrUnListedRooms.count == 0 && arrListedRooms.count == 0 {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = RoomDetailsVC(nibName: "RoomDetailsVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = false
        if indexPath.section == 0 {
            if nSectionCount == 1 && arrListedRooms.count > 0 {
                vc.listModel = arrListedRooms[indexPath.row] as! ListingModel
                vc.strRemaingSteps = String(format:"%@",(vc.listModel.remaining_steps))
            } else if (arrListedRooms.count > 0) {
                vc.listModel = arrListedRooms[indexPath.row] as! ListingModel
                vc.strRemaingSteps = String(format:"%@",(vc.listModel.remaining_steps))
            } else {
                vc.listModel = arrUnListedRooms[indexPath.row] as! ListingModel
                vc.strRemaingSteps = String(format:"%@",(vc.listModel.remaining_steps))
            }
        } else {
            vc.listModel = arrUnListedRooms[indexPath.row] as! ListingModel
            vc.strRemaingSteps = String(format:"%@",(vc.listModel.remaining_steps))
        }
        vc.isStepsCompleted = (indexPath.section == 0) ? true : false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnDetailsClicked(_ sender: UIButton) {
        let vc = ListSpaceVCViewController(nibName: "ListSpaceVCViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- API Calling Method(s)
    
    func getRoomsAPI(pageNumber: Int, isDelete: Bool) {
        self.animatedLoader.isHidden = false
        self.vwAddList.isHidden = true
        self.setTableProperties()
        let dict = NSMutableDictionary()
        dict["page"] = pageNumber
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_GET_LISTING, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    let result = response as! NSDictionary
                    if isDelete && self.arrListedRooms.count > 0 {
                        self.arrListedRooms = NSMutableArray()
                    }
                    if isDelete && self.arrUnListedRooms.count > 0 {
                        self.arrUnListedRooms = NSMutableArray()
                    }
                    if result["listed"] != nil {
                        let arrListedData = result["listed"] as! NSArray
                        if arrListedData.count > 0{
                            self.arrListedRooms = ListingModel().initiateListingData(jsonData: arrListedData) as! NSMutableArray
                        }
                    }
                    if result["unlisted"] != nil {
                        let arrUnListedData = result["unlisted"] as! NSArray
                        if arrUnListedData.count > 0{
                            self.arrUnListedRooms = ListingModel().initiateListingData(jsonData: arrUnListedData) as! NSMutableArray
                        }
                    } else {
                    }
                    self.tblhostlisting.reloadData()
                }
                self.isApiCalling = false
                self.tblhostlisting.reloadData()
                self.tblhostlisting.stopPullRefreshEver()
                self.vwAddList.isHidden = false
                self.animatedLoader.isHidden = true
            }
        }) { (Error) in
            OperationQueue.main.addOperation {
                self.tblhostlisting.stopPullRefreshEver()
                self.vwAddList.isHidden = false
                self.animatedLoader.isHidden = true
            }
        }
    }
    
    // MARK:- Custom Method(s)
    
    func setTableProperties() {
        nSectionCount = 0
        if arrListedRooms.count > 0 {
            nSectionCount += 1
        }
        if arrUnListedRooms.count > 0 {
            nSectionCount += 1
        }
    }
    
    func getNewListing() {
        nPageNumber = 1
        isApiCalling = true
        if arrListing.count > 0 {
            arrListing.removeAllObjects()
        }
        self.getRoomsAPI(pageNumber: nPageNumber, isDelete: true)
    }
    
    // MARK:- Localization Method
    func localization() {
        self.lblYourListing.text = yourListings
    }
}
