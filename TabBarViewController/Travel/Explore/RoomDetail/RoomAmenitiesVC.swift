//
//  RoomAmenitiesVC.swift
//  Arheb
//
//  Created on 6/17/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class RoomAmenitiesVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tblAmenity: UITableView!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var lblAmenity: UILabel!
    var amenityList = [AminitiesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewcustomization()
        self.tblAmenity.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewcustomization(){
        tblAmenity.estimatedRowHeight = 100
        tblAmenity.rowHeight = UITableViewAutomaticDimension
        tblAmenity.tableFooterView = UIView()
        self.automaticallyAdjustsScrollViewInsets = true
        self.tblAmenity.tableHeaderView = self.vwHeader
    }
    
    func registerCell(){
        tblAmenity.dataSource = self
        tblAmenity.delegate = self
        tblAmenity.register(UINib(nibName: "RoomAmenityCell", bundle: nil), forCellReuseIdentifier: "RoomAmenityCell")
    }
    
    //MARK: - Tableview delegate & datasource method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amenityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomAmenityCell", for: indexPath) as! RoomAmenityCell
        let obj = amenityList[indexPath.row]
        cell.lblAmenityName.text = obj.aminity_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
