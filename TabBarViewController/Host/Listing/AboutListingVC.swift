//
//  AboutListingVC.swift
//  Arheb
//
//  Created on 03/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class AboutListingVC: UIViewController, UITableViewDataSource, UITableViewDelegate, EditTitleDelegate {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var lbDetails: UILabel!
    @IBOutlet var tblDetails: UITableView!
    
    let arrDetails = [the_space,guest_access,interaction_with_guests]
    let arrDetailsDesc = [you_can_add_more_information,let_travelers_know,tell_guests_if_youll_be_available]
    let arrNeighbour = [overview,getting_around]
    let arrNeighbourDesc = [show_people_looking_at_your_listing_page,you_can_let_travelers_know]
    let arrExtra = [other_things_to_note,house_rules]
    var selectedRow : Int = 0
    var abtDescModel: AboutTitleModel!
    var strSpace = "" , strGuestAccess = "" , strInteraction = "" , strOverView = "" , strGetting = "" , strOtherThing = "" , strHouseRules = "", strRoomId = ""
    var arrPlaceHoders = [String]()
    var arrValues = [String]()
    let arrExtraDesc = [let_travelers_know_if_there_are_other_details,how_do_you_expect_your_guests_to_behave]
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        tblDetails.delegate = self
        tblDetails.dataSource = self
        tblDetails.register(UINib(nibName: "RoomDetailCell", bundle: nil), forCellReuseIdentifier: "RoomDetailCell")
        self.navigationController?.isNavigationBarHidden = true
        tblDetails.tableFooterView = UIView()
        tblDetails.rowHeight = UITableViewAutomaticDimension
        tblDetails.estimatedRowHeight = 60
        self.getListing()
        lbDetails.text = details_l
    }
    
    // MARK:- TableView Method(s)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return abtDescModel == nil ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrDetails.count
        } else if section == 1 {
            return arrNeighbour.count
        } else {
            return arrExtra.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (tblDetails.frame.size.width) ,height: 40)
        let lblRoomName:UILabel = UILabel()
        lblRoomName.frame =  CGRect(x: 0, y:30, width: viewHolder.frame.size.width ,height: 40)
        
        if section == 0 {
            lblRoomName.text=details
        } else if section == 1 {
            lblRoomName.text=the_neighborhood
        } else {
            lblRoomName.text=extra_details
        }
        viewHolder.backgroundColor = self.view.backgroundColor
        lblRoomName.textAlignment = NSTextAlignment.center
        lblRoomName.textColor = UIColor.darkGray
        viewHolder.addSubview(lblRoomName)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row >= arrExtra.count && indexPath.section == 2 {
            return 50
        }
        if indexPath.row == 1 && indexPath.section == 1 {
            return 100
        }
        if indexPath.row == 1 && indexPath.section == 2{
            return 70
        }
        return 87
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomDetailCell", for: indexPath) as! RoomDetailCell
        if indexPath.section == 0 {
            cell.lblTitle.text = arrDetails[indexPath.row]
            cell.lblDesc.text = indexPath.row == 0 ? strSpace : indexPath.row == 1 ? strGuestAccess : strInteraction
        } else if indexPath.section == 1 {
            cell.lblTitle.text = arrNeighbour[indexPath.row]
            cell.lblDesc.text = indexPath.row == 0 ? strOverView : strGetting
        } else {
            if indexPath.row >= arrExtra.count {
                cell.backgroundColor = UIColor.clear
                cell.textLabel?.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
                cell.lblTitle?.text = ""
                cell.lblDesc?.text = ""
                cell.accessoryType = UITableViewCellAccessoryType.none
                return cell
            }
            cell.lblTitle.text = arrExtra[indexPath.row]
            cell.lblDesc.text = indexPath.row == 0 ? strOtherThing : strHouseRules
        }
        cell.lblTitle.textColor = UIColor.darkGray
        cell.lblTitle?.backgroundColor = UIColor.white
        cell.ConstImgWidth.constant = 0
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row>=arrExtra.count && indexPath.section == 2 {
            return
        }
        if indexPath.section == 0 {
            selectedRow = indexPath.row
        } else if indexPath.section == 1 {
            selectedRow = indexPath.row + 3
        } else {
            selectedRow = indexPath.row + 5
        }
        let selectedCell = tableView.cellForRow(at: indexPath) as! RoomDetailCell
        let vc = EditTitleAndSummaryVC(nibName: "EditTitleAndSummaryVC", bundle: nil)
        vc.delegate = self
        vc.strRoomId = strRoomId
        vc.strAboutMe = arrValues[selectedRow]
        vc.strPlaceHolder = arrPlaceHoders[selectedRow]
        vc.strTitle = (selectedCell.lblTitle?.text)!
        vc.isFromRoomDesc = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- Edit Title Delegate method(s)
    
    func editTitleTapped(strDescription: String) {
        var abtModel = AboutTitleModel()
        abtModel = abtDescModel
        if selectedRow == 0 {
            abtModel.space_msg = strDescription
        } else if selectedRow == 1 {
            abtModel.guest_access_msg = strDescription
        } else if selectedRow == 2 {
            abtModel.interaction_with_guest_msg = strDescription
        } else if selectedRow == 3 {
            abtModel.overview_msg = strDescription
        } else if selectedRow == 4 {
            abtModel.getting_arround_msg = strDescription
        } else if selectedRow == 5 {
            abtModel.other_things_to_note_msg = strDescription
        } else if selectedRow == 6 {
            abtModel.house_rules_msg = strDescription
        }
        abtModel = abtDescModel
        setDescription()
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK:- Custom Method(s)
    
    func setDescription() {
        strSpace        = (abtDescModel.space_msg != "") ? abtDescModel.space_msg as String : "You can add more information about what makes your space unique."
        strGuestAccess  = (abtDescModel.guest_access_msg != "") ? abtDescModel.guest_access_msg as String : "Let travelers know what parts of the space they’ll be able to access."
        strInteraction  = (abtDescModel.interaction_with_guest_msg != "") ? abtDescModel.interaction_with_guest_msg as String : "Tell guests if you’ll be available to offer help throughout their stay."
        strOverView     = (abtDescModel.overview_msg != "") ? abtDescModel.overview_msg as String : "Show people looking at your listing page what makes your neighborhood unique."
        strGetting      = (abtDescModel.getting_arround_msg != "") ? abtDescModel.getting_arround_msg as String : "You can let travelers know if your listing is close to public transportation (or far from it). You can also mention nearby parking options."
        strOtherThing   = (abtDescModel.other_things_to_note_msg != "") ? abtDescModel.other_things_to_note_msg as String : "Let travelers know if there are other details that will impact their stay."
        strHouseRules   = (abtDescModel.house_rules_msg != "") ? abtDescModel.house_rules_msg as String : "How do you expect your guests to behave?"
        arrPlaceHoders = ["You can add more information about what makes your space unique.","Let travelers know what parts of the space they’ll be able to access.","Tell guests if you’ll be available to offer help throughout their stay.","Show people looking at your listing page what makes your neighborhood unique.","You can let travelers know if your listing is close to public transportation (or far from it). You can also mention nearby parking options.","Let travelers know if there are other details that will impact their stay.","How do you expect your guests to behave?"]
        arrValues = [abtDescModel.space_msg as String,abtDescModel.guest_access_msg as String,abtDescModel.interaction_with_guest_msg as String,abtDescModel.overview_msg as String,abtDescModel.getting_arround_msg as String,abtDescModel.other_things_to_note_msg as String,abtDescModel.house_rules_msg as String]
        tblDetails.reloadData()
    }
    
    // MARK:- API Calling Method(s)
    
    func getListing() {
        ProgressHud.shared.Animation = true
        let dict = NSMutableDictionary()
        dict["room_id"] = strRoomId
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_UPDATE_ROOM_DESC, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    let result = response as! NSDictionary
                    let abtModel = AboutTitleModel().initiateTitleData(responseDict: result)
                    self.abtDescModel = abtModel
                    self.setDescription()
                }
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
}
