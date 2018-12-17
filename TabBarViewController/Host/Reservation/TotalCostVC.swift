//
//  TotalCostVC.swift
//  Arheb
//
//  Created  on 6/1/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class TotalCostVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var lblPaymentBreakdown: UILabel!
    @IBOutlet var lblNightNLocation: UILabel!
    @IBOutlet weak var tblPricelIst:UITableView!
    @IBOutlet weak var vwHeader:UIView!
    
    let arrPrices = NSMutableArray()
    var strPriceDetail:String = ""
    var strServiceFee:String = ""
    var strTotalPrice : NSAttributedString!
    var strLocationName:String = ""
    var strTotalNights:String = ""
    var strNightPrice:String = ""
    var strCurrency : String = ""
    var strPageTitle:String = ""
    var arrPrice = [String]()
    var arrPirceDesc = [String]()
 
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPaymentBreakdown.text = payment_breakdown
        if strTotalNights.characters.count > 0 {
            if strTotalNights == "1" {
                self.lblNightNLocation.text = strTotalNights + " night in " + strLocationName
            } else {
                self.lblNightNLocation.text = strTotalNights + " nights in " + strLocationName
            }
        }
        viewcustomization()
        registerCell()
    }
    
    //MARK: - TableView datasource & delegate method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPrices.count>0 ? 3 : (3 + arrPrices.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = GETVALUE(USER_CURRENCY_SYMBOL)
        let total = Int(strPriceDetail)! * Int(strTotalNights)!
        if indexPath.row == 0 {
            let cell:TotalCostCell = tblPricelIst.dequeueReusableCell(withIdentifier: "TotalCostCell") as! TotalCostCell
            cell.lblDetail.text = "\(currency)\(strPriceDetail) X \(strTotalNights) nights"
            cell.lblPrice.text = "\(currency)\(String(total))"
            return cell
        } else if indexPath.row == 1 {
            let cell:ServicePriceCell = tblPricelIst.dequeueReusableCell(withIdentifier: "ServicePriceCell") as! ServicePriceCell
            cell.lblServicePrice.text = "\(currency)\(strServiceFee)"
            return cell
        } else if arrPrices.count>0 && arrPrices.count == indexPath.row - 2 && indexPath.row>1 {
            let cell:TotalCostCell = tblPricelIst.dequeueReusableCell(withIdentifier: "TotalCostCell") as! TotalCostCell
            return cell
        } else {
            let cell:TotalCostCell = tblPricelIst.dequeueReusableCell(withIdentifier: "TotalCostCell") as! TotalCostCell
            cell.lblDetail.isHidden = true
            cell.lblPrice.attributedText = strTotalPrice
            cell.lblPrice.font = UIFont.boldSystemFont(ofSize: 25.0)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 1){
            return  118
        }
        return 70
    }
    
    //MARK: - IBAction Method
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Memory warning 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Custom Method(s)
   
    func viewcustomization() {
        tblPricelIst.tableHeaderView = vwHeader
        tblPricelIst.separatorColor = UIColor.clear
        if strTotalNights.characters.count > 0 {
            if strTotalNights == "1" {
                self.lblNightNLocation.text = strTotalNights + " night in " + strLocationName
            } else {
                self.lblNightNLocation.text = strTotalNights + " nights in " + strLocationName
            }
        }
    }
    
    func registerCell() {
        tblPricelIst.register(UINib(nibName: "ServicePriceCell", bundle: nil), forCellReuseIdentifier: "ServicePriceCell")
        tblPricelIst.register(UINib(nibName: "TotalCostCell", bundle: nil), forCellReuseIdentifier: "TotalCostCell")
    }
}
