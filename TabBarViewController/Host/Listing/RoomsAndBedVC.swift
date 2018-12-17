//
//  RoomsAndBedVC.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class RoomsAndBedVC: UIViewController {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var lblRooms: UILabel!
    @IBOutlet var lblCreatedListing: UILabel!
    @IBOutlet var lbllabelBeds: UILabel!
    @IBOutlet var lblBedrooms: UILabel!
    @IBOutlet var lblMaxGuest: UILabel!
    @IBOutlet var lblJustLittle: UILabel!
    @IBOutlet var lblRoomAndBed: UILabel!
    @IBOutlet var btnFinishListing: UIButton!
    @IBOutlet var lblBathrooms: UILabel!
    @IBOutlet var lblBeds: UILabel!
    @IBOutlet var lblGuests: UILabel!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var btnnext: UIButton!
    @IBOutlet var vwFinishListing: UIView!
    @IBOutlet var lblLabelBathrooms: UILabel!
    @IBOutlet var lblMoreSteps: UILabel!
    
    var strRoomType = ""
    var strPropertyType = ""
    var strLat = ""
    var strLong = ""
    var strPropertyName = ""
    var strRoomLocation = ""
    var strRoomID:String = ""
    var guestCount = 1
    var bedRoomCount = 1
    var bedsCount = 1
    var bathroomCount = 1
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblRooms.text = bedrooms
        lblMaxGuest.text = maxguest
        lblJustLittle.text = just_a_little_more_about_your_house
        lblRoomAndBed.text = roomsAndBed
        self.lbllabelBeds.text = beds
        self.lblLabelBathrooms.text = bathrooms
        self.lblCreatedListing.text = createdListing
        self.lblMoreSteps.text = moreSteps
        btnFinishListing.setTitle(finishListing, for: .normal)
        btnnext.setTitle(nxt, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        lbl3.layer.cornerRadius = lbl3.frame.size.width/2
        vwFinishListing.frame = view.frame
        btnFinishListing.layer.cornerRadius = 7
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnAddClicked(_ sender: UIButton) {
        if sender.tag == 1{
            guestCount += 1
            lblGuests.text = String(guestCount)
        } else if sender.tag == 2{
            bedRoomCount += 1
            lblBedrooms.text = String(bedRoomCount)
        } else if sender.tag == 3{
            bedsCount += 1
            lblBeds.text = String(bedsCount)
        } else if sender.tag == 4{
            bathroomCount += 1
            lblBathrooms.text = String(bathroomCount)
        }
    }
    
    @IBAction func btnSubtractClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            if  guestCount == 1 {
                return
            }
            guestCount -= 1
            lblGuests.text = String(guestCount)
        } else if sender.tag == 2 {
            if  bedRoomCount == 1 {
                return
            }
            bedRoomCount -= 1
            lblBedrooms.text = String(bedRoomCount)
        } else if sender.tag == 3 {
            if  bedsCount == 1 {
                return
            }
            bedsCount -= 1
            lblBeds.text = String(bedsCount)
        } else if sender.tag == 4 {
            if  bathroomCount == 1 {
                return
            }
            bathroomCount -= 1
            lblBathrooms.text = String(bathroomCount)
        }
    }
    
    @IBAction func btnnextClicked(_ sender: UIButton) {
        self.callRoomAPI()
    }
    
    @IBAction func btnFinishListingClicked(_ sender: UIButton) {
        let tempModel = ListingModel()
        tempModel.room_type = strRoomType
        tempModel.room_location = strRoomLocation
        tempModel.latitude = strLat
        tempModel.longitude = strLong
        tempModel.max_guest_count = lblGuests.text!
        tempModel.bedroom_count = lblBedrooms.text!
        tempModel.beds_count = lblBeds.text!
        tempModel.bathrooms_count = lblBathrooms.text!
        tempModel.room_id = (strRoomID as NSString) as String
        tempModel.room_thumb_images = []
        tempModel.remaining_steps = "3"
        tempModel.home_type = strPropertyName
        tempModel.policy_type = flexible
        tempModel.isListEnabled = no
        tempModel.currency_code = GETVALUE(USER_CURRENCY_ORG)
        tempModel.currency_symbol = GETVALUE(USER_CURRENCY_SYMBOL_ORG)
        let vc = RoomDetailsVC(nibName: "RoomDetailsVC", bundle: nil)
        vc.listModel = tempModel
        appDelegate?.strRoomID = strRoomID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- API Calling Method(s)
    
    func callRoomAPI() {
        ProgressHud.shared.Animation = true
        let dicts = NSMutableDictionary()
        dicts["room_type"]          = strRoomType
        dicts["property_type"]      = strPropertyType
        dicts["latitude"]           = strLat
        dicts["longitude"]          = strLong
        dicts["max_guest"]          = lblGuests.text
        dicts["bedrooms_count"]     = lblBedrooms.text
        dicts["beds_count"]         = lblBeds.text
        dicts["bathrooms_count"]    = lblBathrooms.text
        dicts["bed_type"]           = "1"
        dicts["guest_categories"]   = "1"
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_ADD_NEW_ROOM, params: dicts, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    let result = response as! NSDictionary
                    if(result.value(forKey: "room_id") != nil){
                        let roomId:Int = result.value(forKey: "room_id") as! Int
                        self.strRoomID = String(roomId)
                    }
                    if(result.value(forKey: "location") != nil){
                        self.strRoomLocation = String(describing: result.value(forKey: "location"))
                    }
                    self.view.addSubview(self.vwFinishListing)
                }
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            OperationQueue.main.addOperation {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    //MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
