//
//  CreatedListVC.swift
//  Arheb
//
//  Created on 6/2/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import MessageUI
import Social


protocol createdListDelegate
{
    func onCreateListTapped(index:Int)
}


class CreatedListVC : UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblCreatedList: UITableView!
    var delegate: createdListDelegate?
    var arrRoomList : NSMutableArray = NSMutableArray()
    var selectedRoom_id = ""
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.adjustTableViewFrame(CGFloat(arrRoomList.count))
        self.tblCreatedList.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.tblCreatedList.register(UINib(nibName: "CreatedListCell", bundle: nil), forCellReuseIdentifier: "CreatedListCell")
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.makeTableViewAnimation), userInfo: nil, repeats: false)
    }
    
    func adjustTableViewFrame(_ count:CGFloat )
    {
        let valCount = (count > 6) ? 6 : count
        var rectStartBtn = self.tblCreatedList.frame
        rectStartBtn.size.height = valCount * 70
        self.tblCreatedList.frame = rectStartBtn
    }
    
    /*
     ANIMATING TABLE VIEW
     */
    
    func makeTableViewAnimation()
    {
            UIView.animate(withDuration: 0.5) {
                self.tblCreatedList.transform = CGAffineTransform.identity
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        UIView.animate(withDuration:0.5 , animations: {
            self.tblCreatedList.transform =  CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /*
     Room Detail List View Table Datasource & Delegates
     */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRoomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CreatedListCell = tblCreatedList.dequeueReusableCell(withIdentifier: "CreatedListCell") as! CreatedListCell
        let listModel = arrRoomList[indexPath.row] as? ListingModel
        cell.setRoomDatas(modelListing: listModel!)
        cell.lblTickMark.isHidden = (selectedRoom_id == listModel?.room_id) ? false : true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        delegate?.onCreateListTapped(index: indexPath.row)
        self.onBackTapped(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}




