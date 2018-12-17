//
//  TravelAdditionalPriceVC.swift
//  Arheb
//
//  Created on 13/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class TravelAdditionalPriceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var tblAdditionalPrice: UITableView!
    
    var arrSpecialPrices = [String]()
    var arrPrices = [String]()
    
    // MARK:- View Method(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        tblAdditionalPrice.tableHeaderView = vwHeader
        self.tabBarController?.tabBar.isHidden = true
        self.tblAdditionalPrice.dataSource = self
        self.tblAdditionalPrice.delegate = self
        self.tblAdditionalPrice.register(UINib(nibName: "AdditionalPriceCell", bundle: nil), forCellReuseIdentifier: "additionalPriceCell")
        self.tblAdditionalPrice.tableFooterView = UIView()
    }
    
    // MARK:- Memory Warning(s)

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:- IBOutlet Method(s)
    
    @IBAction func handleBtnClose(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK:- TableView Method(s)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSpecialPrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "additionalPriceCell", for: indexPath) as! AdditionalPriceCell
        cell.lblTitle?.text = arrSpecialPrices[indexPath.row]
        cell.lblSubTitle?.text = arrPrices[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
