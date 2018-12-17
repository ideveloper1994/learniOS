//
//  DescribePlaceVC.swift
//  Arheb
//
//  Created on 02/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

protocol DescribePlaceDelegate {
    func roomDescriptionChanged(strDescription: String, isTitle: Bool)
}

class DescribePlaceVC: UIViewController, UITableViewDataSource, UITableViewDelegate, EditTitleDelegate {
    
    // MARK:- IBOutlet(s)
   
    @IBOutlet var tblDescribePlace: UITableView!

    @IBOutlet var lblDescribeYourPlace: UILabel!
    
    var arrTitle = [add_a_title,write_a_summary]
    var arrDisc = [be_clear_and_descriptive,tell_travelers_what_you]
    var strRoomId = ""
    var strTitle = ""
    var strRoomDesc = ""
    var delegate: DescribePlaceDelegate?
    
    //MARK:- View Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblDescribeYourPlace.text = "Describe your place"
        tblDescribePlace.delegate = self
        tblDescribePlace.dataSource = self
        tblDescribePlace.register(UINib(nibName: "RoomDetailCell", bundle: nil), forCellReuseIdentifier: "RoomDetailCell")
        self.navigationController?.isNavigationBarHidden = true
        tblDescribePlace.tableFooterView = UIView()
        tblDescribePlace.rowHeight = UITableViewAutomaticDimension
        tblDescribePlace.estimatedRowHeight = 60
    }
    
    // MARK:- TableView Method(s)

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomDetailCell", for: indexPath) as! RoomDetailCell
        cell.lblTitle.text = arrTitle[indexPath.row]
        cell.lblTitle.textColor = UIColor.darkGray
        cell.ConstImgWidth.constant = 0
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        if indexPath.row == 0 {
            cell.lblDesc.text = strTitle.characters.count > 0 ? strTitle : arrDisc[indexPath.row]
        } else {
            cell.lblDesc.text = strRoomDesc.characters.count > 0 ? strRoomDesc :arrDisc[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditTitleAndSummaryVC(nibName: "EditTitleAndSummaryVC", bundle: nil)
        vc.strPlaceHolder = indexPath.row == 0 ? "Be clear and descriptive." : "Tell travelers what you love about the space. You can include details about the decor, the amenities it includes, and the neighborhood."
        vc.delegate = self
        vc.strRoomId = strRoomId
        vc.strAboutMe = indexPath.row == 0 ? strTitle : strRoomDesc
        appDelegate?.nSelectedIndex = indexPath.row == 0 ? 0 : 1
        vc.maxLength = indexPath.row == 0 ? 35 : 500
        vc.strTitle = indexPath.row == 0 ? "Edit Title": "Edit Summary"
        if indexPath.row == 0 {
            vc.maxLength = 35
            vc.strTitle = edit_title
            vc.descriptionText = be_clear_and_descriptive
        }else{
            vc.maxLength = 500
            vc.strTitle = edit_summary
            vc.descriptionText = tell_travelers_what_you
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //
    
    func editTitleTapped(strDescription:String) {
        delegate?.roomDescriptionChanged(strDescription: strDescription, isTitle: (appDelegate?.nSelectedIndex == 0) ? true : false)
        if appDelegate?.nSelectedIndex == 0 {
            strTitle = strDescription
        } else {
            strRoomDesc = strDescription as String
        }
        tblDescribePlace.reloadData()
    }

    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
