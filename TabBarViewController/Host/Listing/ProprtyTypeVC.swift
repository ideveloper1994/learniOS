//
//  ProprtyTypeVC.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ProprtyTypeVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    // MARK:- IBOutlet(s)
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblPropertyType: UITableView!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var lblPlaceType: UILabel!
   
    var strRoomType = ""
    let arrHomeName = [apartment,house,bedBreakFast,loft,townhouse,condominium,bungalow,cabin,villa,castle,dorm,treehouse,boat,plane,cameraRv,lgloo,lighthouse,yurt,tipi,cave,island,chalet,earthHouse,hut,train,Tent,other]
    let arrSubName = [yourEntireHome,singleRoom,aCouch]
    let arrIconName = ["apartment.png","entirehome.png","bedcoffee.png"]
    var isMoreTapped : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tblPropertyType.delegate = self
        tblPropertyType.dataSource = self
        tblPropertyType.register(UINib(nibName: "PropertyTypeCell", bundle: nil), forCellReuseIdentifier: "PropertyTypeCell")
        tblPropertyType.register(UINib(nibName: "MoreCell", bundle: nil), forCellReuseIdentifier: "MoreCell")
        var rectHeaderView = vwHeader.frame
        rectHeaderView.size.height = UIScreen.main.bounds.size.height - 325
        vwHeader.frame = rectHeaderView
        tblPropertyType.tableHeaderView = vwHeader
        self.localization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    // MARK:- TableView Method(s)

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isMoreTapped) ? arrHomeName.count : 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(!isMoreTapped && indexPath.row==3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! MoreCell
            cell.btnMore?.addTarget(self, action: #selector(self.onMoreTypeTapped), for: UIControlEvents.touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTypeCell", for: indexPath) as! PropertyTypeCell
            let strRoomName = arrHomeName[indexPath.row]
            cell.lblName.text = strRoomName
            if (indexPath.row<3) {
                cell.imgDetail?.isHidden = false
                cell.imgDetail?.image =  UIImage(named: arrIconName[indexPath.row])
                cell.ConstCellLeading.constant = 57
            } else {
                cell.imgDetail?.isHidden = true
                cell.ConstCellLeading.constant = 30
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = GuestTypeVC(nibName: "GuestTypeVC", bundle: nil)
        vc.strRoomType = strRoomType
        let strRoomName = arrHomeName[indexPath.row]
        vc.strPropertyType = String(indexPath.row + 1)
        for i in 0 ..< arrHomeName.count {
            let str = arrHomeName[i]
            if str == strRoomName {
                vc.strPropertyName = str
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func onMoreTypeTapped(_ sender:UIButton!) {
        isMoreTapped = true
        tblPropertyType.reloadData()
        tblPropertyType.setContentOffset(CGPoint(x: 0, y:220), animated:true)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Localization Method
    
    func localization() {
        self.lblTitle.text = propertyType
        self.lblPlaceType.text = placeType
    }

}
