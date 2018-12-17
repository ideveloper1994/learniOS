//
//  ListSpaceVCViewController.swift
//  Arheb
//
//  Created on 5/31/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ListSpaceVCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK:- IBOutlet(s)
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblDetail: UITableView!
    @IBOutlet var lblYourListSpace: UILabel!
    
    var arrName = [entireHome,privateRoom,sharedRoom]
    var arrDetail = [yourEntireHome,singleRoom,aCouch]
    var arrImages = ["entirehome.png","privateroom.png","sharedroom.png"]
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblDetail.delegate = self
        tblDetail.dataSource = self
        tblDetail.register(UINib(nibName: "ListSpaceCell", bundle: nil), forCellReuseIdentifier: "ListSpaceCell")
        self.localization()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    // MARK:- Table View Method(s)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListSpaceCell", for: indexPath) as! ListSpaceCell
        cell.lblName.text = arrName[indexPath.row]
        cell.lblDetail.text = arrDetail[indexPath.row]
        cell.imgDetail.image = UIImage(named: arrImages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ProprtyTypeVC(nibName: "ProprtyTypeVC", bundle: nil)
        vc.strRoomType = "\(indexPath.row + 1)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Localization Method
    func localization() {
        self.lblTitle.text = listSpace
        self.lblYourListSpace.text = yourListSpace
    }

}
