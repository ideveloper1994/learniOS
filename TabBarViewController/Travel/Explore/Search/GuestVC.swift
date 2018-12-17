//
//  GuestVC.swift
//  Arheb
//
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

protocol AddGuestDelegate
{
    func onGuestAdded(adults:Int,child:Int)
}

class GuestVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var tblGuest: UITableView!
    
    var nCurrentGuest: Int = 1
    var nMaxGuestCount: Int = 0
    
    var isPetSelected:Bool = false
    var delegate: AddGuestDelegate?
    var arrList = ["Adults","Children"]
    var arrSubtitle = ["","2-12 years old"]
    var adults = 1
    var child = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewcustomization()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tblGuest.reloadData()
    }
    
    //MARK: Here Customize the view
    func viewcustomization(){
        tblGuest.register(UINib(nibName: "GuestFilterCell", bundle: nil), forCellReuseIdentifier: "GuestFilterCell")
        self.navigationController?.navigationBar.isHidden = true
        btnSave.layer.cornerRadius = btnSave.frame.size.height/2
        self.nCurrentGuest = adults + child
    }
    
    //    @IBAction func onAddOrRemoveTapped(_ sender:UIButton!)
    //    {
    //        if sender.tag==11 {
    //            if  nCurrentGuest >= nMaxGuestCount {
    //                return
    //            }
    //            nCurrentGuest += 1
    //        }else {
    //            if  nCurrentGuest == 1 {
    //                return
    //            }
    //            nCurrentGuest -= 1
    //        }
    //       // btnAddGuest.setTitle(String(format: "%d", nCurrentGuest), for:UIControlState.normal)
    //    }
    //
    // MARK: Save Button status
    /*
     
     */
    
    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        delegate?.onGuestAdded(adults: adults, child: child)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestFilterCell", for: indexPath) as! GuestFilterCell
        cell.lbGeusetTitle.text = arrList[indexPath.row]
        cell.lbDesc.text = arrSubtitle[indexPath.row]
        cell.btnAdd.addTarget(self, action: #selector(self.onAddTapped), for: UIControlEvents.touchUpInside)
        cell.btnRemove.addTarget(self, action: #selector(self.onRemoveTapped), for: UIControlEvents.touchUpInside)
        cell.btnAdd.tag = indexPath.row
        cell.btnRemove.tag = indexPath.row
        
        if(indexPath.row == 0){
            cell.Count.setTitle(String(adults), for: .normal)
        }else if(indexPath.row == 1){
            cell.Count.setTitle(String(child), for: .normal)
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddTapped(_ sender:UIButton!)
    {
        if(self.nCurrentGuest < nMaxGuestCount || self.nMaxGuestCount == 0){
            let cell:GuestFilterCell = tblGuest.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! GuestFilterCell
            cell.Count.setTitle(String(Int((cell.Count.titleLabel?.text)!)! + 1), for: .normal)
            tblGuest.reloadData()
            if(sender.tag == 0){
                adults = Int((cell.Count.titleLabel?.text)!)!
            }else if(sender.tag == 1){
                child = Int((cell.Count.titleLabel?.text)!)!
            }
            self.nCurrentGuest = child + adults
        }
    }
    
    @IBAction func onRemoveTapped(_ sender:UIButton!)
    {
        let cell:GuestFilterCell = tblGuest.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! GuestFilterCell
        if(sender.tag == 0) {
            if(cell.Count.titleLabel?.text != "1") {
                cell.Count.setTitle(String(Int((cell.Count.titleLabel?.text)!)! - 1), for: .normal)
                tblGuest.reloadData()
                adults = Int((cell.Count.titleLabel?.text)!)!
            }
        }else{
            if(cell.Count.titleLabel?.text != "0") {
                cell.Count.setTitle(String(Int((cell.Count.titleLabel?.text)!)! - 1), for: .normal)
                tblGuest.reloadData()
                child = Int((cell.Count.titleLabel?.text)!)!
            }
        }
        self.nCurrentGuest = child + adults
    }
    
}
