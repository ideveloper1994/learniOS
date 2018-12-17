//
//  RoomDetailsVC.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import AFNetworking

class RoomDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, EditPriceDelegate, DescribePlaceDelegate, HostRoomLocationDelegate, EditTitleDelegate,RoomImageAddedDelegate {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var lbOpenDetails: UILabel!
    @IBOutlet var imgRoom: UIImageView!
    @IBOutlet var tblRoomDetail: UITableView!
    @IBOutlet var vwAddPhoto: UIView!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var vwFooter: UIView!
    @IBOutlet weak var vwProgress:UIView!
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var btnPreview: UIButton!
    @IBOutlet var lbStepsToList: UILabel!
    @IBOutlet var btnOpenDetails: UIButton!
    @IBOutlet var btnListSpace: UIButton!
    @IBOutlet var imgCheckImage: UIButton!
    
    var stretchableTableHeaderView : HFStretchableTableHeaderView! = nil
    var listModel = ListingModel()
    var arrTitles = [describe_your_place,set_price,set_address,set_house_rules,set_book_type]
    var arrDisc = [summarize_the_highlights,try_our_suggested_price_to_start,unnamed_road,kerlapal,chhatisgarh,india,guests_agree_to_rules_before_booking,how_guests_can_book]
    var imagePicker = UIImagePickerController()
    var strRemaingSteps = ""
    var isStepsCompleted : Bool = false
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate?.strRoomID = listModel.room_id
        lbOpenDetails.text = option_details
        btnPreview.setTitle(preview, for: .normal)
        if strRemaingSteps.characters.count > 0 && strRemaingSteps != "0" {
            lbStepsToList.text = strRemaingSteps + steps_to_list
        } else if strRemaingSteps == "0" {
            lbStepsToList.text = listModel.isListEnabled == "Yes" ? "Listed" : "Unlisted"
        }
        viewcustomization()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        checkHeader()
        tblRoomDetail.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkRemaingSteps()
    }
    
    override func viewDidLayoutSubviews() {
        stretchableTableHeaderView.resize()
    }
    
    //MARK: - Tableview Delegate & Datasource Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomDetailCell", for: indexPath) as! RoomDetailCell
        cell.lblTitle.text = arrTitles[indexPath.row]
        switch indexPath.row {
        case 0:
            if listModel.room_description.characters.count > 0 {
                cell.lblDesc.text = listModel.room_description
                cell.imgCheckBox.image = UIImage(named: "check_red_active")
            } else {
                cell.lblDesc.text = arrDisc[indexPath.row]
            }
        case 1:
            if listModel.room_price.characters.count > 0 && listModel.room_price != "0" {
                cell.lblDesc.text = String(format:"%@%@ per night",(listModel.currency_symbol).stringByDecodingHTMLEntities, listModel.room_price as String)
                cell.imgCheckBox.image = UIImage(named: "check_red_active")
            } else {
                cell.lblDesc.text = arrDisc[indexPath.row]
            }
        case 2:
            if listModel.room_location.characters.count > 0 {
                if listModel.street_name.characters.count > 0 && listModel.street_address.characters.count > 0 && listModel.city_name.characters.count > 0 && listModel.state_name.characters.count > 0 && listModel.country_name.characters.count > 0 && listModel.zipcode.characters.count > 0 {
                    cell.lblDesc.text = String(format:"%@,%@,%@,%@,%@,%@",listModel.street_name,listModel.street_address,listModel.city_name,listModel.state_name,listModel.country_name,listModel.zipcode)
                } else {
                    cell.lblDesc.text = listModel.room_location as String
                }
                cell.imgCheckBox.image = UIImage(named: "check_red_active")
            } else {
                cell.lblDesc.text = arrDisc[indexPath.row]
            }
        case 3:
            if listModel.additional_rules_msg.characters.count > 0 {
                cell.lblDesc.text = listModel.additional_rules_msg
                cell.imgCheckBox.image = UIImage(named: "check_red_active")
            } else {
                cell.lblDesc.text = arrDisc[indexPath.row]
            }
        case 4:
            if listModel.booking_type.characters.count > 0 {
                cell.lblDesc.text = listModel.booking_type
            } else {
                cell.lblDesc.text = arrDisc[indexPath.row]
            }
        default:
            cell.lblDesc.text = arrDisc[indexPath.row]
        }
        if indexPath.row < 3{
            cell.imgCheckBox.isHidden = false
            cell.imgCheckBox.layer.borderWidth = 2.0
            cell.imgCheckBox.layer.borderColor = UIColor.red.cgColor
            cell.imgCheckBox.layer.cornerRadius = 2.0
        } else {
            cell.imgCheckBox.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.setDescibePlace()
        } else if indexPath.row == 1{
            self.setPriceTapped()
        } else if indexPath.row == 2{
            self.addressTapped()
        } else if indexPath.row == 3{
            self.setHouseRulesTapped()
        } else if indexPath.row == 4{
            self.bookTypeTapped()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stretchableTableHeaderView.scrollViewDidScroll(scrollView)
    }
    
    // MARK: Edit Price Delegate Method(s)
    
    func currencyChangedInEditPrice(strCurrencyCode: String, strCurrencySymbol: String) {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.currency_symbol = strCurrencySymbol
        tempModel.currency_code = strCurrencyCode
        listModel = tempModel
        tblRoomDetail.reloadData()
    }
    
    func PriceEditted(strDescription: String) {
        if strDescription.characters.count > 0 {
            var tempModel = ListingModel()
            tempModel = listModel
            tempModel.room_price = strDescription
            listModel = tempModel
            tblRoomDetail.reloadData()
        }
    }
    
    func updateAllRoomPrice(modelList : ListingModel) {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.additionGuestFee = modelList.additionGuestFee
        tempModel.cleaningFee = modelList.cleaningFee
        tempModel.monthly_price = modelList.monthly_price
        tempModel.room_price = modelList.room_price
        tempModel.securityDeposit = modelList.securityDeposit
        tempModel.weekendPrice = modelList.weekendPrice
        tempModel.weekly_price = modelList.weekly_price
        listModel = tempModel
        tblRoomDetail.reloadData()
    }
    
    //MARK: - Image Delegate Method
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let settingsActionSheet: UIAlertController = UIAlertController(title:error, message:device_has_no_camera, preferredStyle:UIAlertControllerStyle.alert)
            settingsActionSheet.addAction(UIAlertAction(title:ok, style:UIAlertActionStyle.cancel, handler:nil))
            present(settingsActionSheet, animated:true, completion:nil)
        }
    }
    
    func choosePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            let pickedImageEdited: UIImage? = (info[UIImagePickerControllerOriginalImage] as? UIImage)
            let vc = AddPhotoVC(nibName: "AddPhotoVC", bundle: nil)
            vc.image = pickedImageEdited!
            vc.listModel = self.listModel
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        dismiss(animated: false, completion: nil)
    }
    
    //MARK: - Custom Method
    
    func checkRemaingSteps() {
        var nTotalSteps = 5
        if (listModel.room_thumb_images.count) > 0 {
            nTotalSteps -= 1
        }
        if(listModel.room_description as String).characters.count > 0 && (listModel.room_title as String).characters.count > 0 {
            nTotalSteps -= 1
        }
        if(listModel.room_price as String).characters.count > 0 && (listModel.room_price as String) != "0" {
            nTotalSteps -= 1
        }
        if(listModel.room_location as String).characters.count > 0 {
            nTotalSteps -= 1
        }
        if(listModel.beds_count as String).characters.count > 0 {
            nTotalSteps -= 1
        }
        self.showRemainStepsProgress(remaingSteps: String(format:"%d",nTotalSteps))
        if nTotalSteps == 0 && !isStepsCompleted && listModel.isListEnabled == "No" {
            btnListSpace.isHidden = false
            lbStepsToList.text = listModel.isListEnabled == "Yes" ? "Listed" : "Ready to List"
            tblRoomDetail.tableFooterView = vwFooter
            btnListSpace.setTitle((listModel.isListEnabled == "Yes") ? "Unlist your space" : "List your space", for: .normal)
        } else {
            lbStepsToList.text = listModel.isListEnabled == "Yes" ? "Listed" : "Unlisted"
            lbStepsToList.text = (nTotalSteps == 0) ? (listModel.isListEnabled == "Yes" ? "Listed" : "Unlisted") : String(format:"%d steps to list",nTotalSteps)
            btnListSpace.isHidden = true
        }
    }
    
    func showRemainStepsProgress(remaingSteps: String) {
        vwProgress.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions(), animations: { () -> Void in
            let rect = UIScreen.main.bounds as CGRect
            let nRemaining = rect.size.width / 6
            var rectViewProgress = self.vwProgress.frame
            let remainingsteps = 6 - Int(remaingSteps)!
            rectViewProgress.size.width = CGFloat(remainingsteps) * nRemaining
            self.vwProgress.frame = rectViewProgress
        }, completion: { (finished: Bool) -> Void in
        })
    }
    
    func viewcustomization(){
        self.navigationController?.isNavigationBarHidden = true
        vwHeader.frame.size.height = 240
        vwFooter.frame.size.height = 100
        imgCheckImage.layer.borderWidth = 2.0
        imgCheckImage.layer.borderColor = UIColor.red.cgColor
        imgCheckImage.layer.cornerRadius = 2.0
    }
    
    func registerCell(){
        tblRoomDetail.delegate = self
        tblRoomDetail.dataSource = self
        tblRoomDetail.register(UINib(nibName: "RoomDetailCell", bundle: nil), forCellReuseIdentifier: "RoomDetailCell")
        
        tblRoomDetail.tableHeaderView = vwHeader
        tblRoomDetail.tableFooterView = vwFooter
        stretchableTableHeaderView = HFStretchableTableHeaderView()
        stretchableTableHeaderView.stretchHeader(for: tblRoomDetail, with: vwHeader)
    }
    
    func setPriceTapped() {
        let priceEditView = EditPriceVC(nibName: "EditPriceVC", bundle: nil)
        priceEditView.delegate = self
        priceEditView.isFromCalendar = false
        priceEditView.delegate = self
        priceEditView.room_currency_code = listModel.currency_code as String
        priceEditView.room_currency_symbol = listModel.currency_symbol as String
        priceEditView.strPrice = listModel.room_price as String
        priceEditView.strRoomId = listModel.room_id as String
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(priceEditView, animated: true)
    }
    
    func addressTapped() {
        let vc = LocationVC(nibName: "LocationVC", bundle: nil)
        vc.delegateHost = self
        if ((listModel.street_name as String).characters.count)>0 && ((listModel.street_address as String).characters.count)>0 && ((listModel.city_name as String).characters.count)>0 && ((listModel.state_name as String).characters.count)>0 && ((listModel.country_name as String).characters.count)>0 && ((listModel.zipcode as String).characters.count)>0 {
            vc.strRoomLocation = String(format:"%@,%@,%@,%@,%@,%@",listModel.street_name,listModel.street_address,listModel.city_name,listModel.state_name,listModel.country_name,listModel.zipcode)
        } else {
            vc.strRoomLocation = listModel.room_location as String
        }
        vc.strLongitude = listModel.longitude
        vc.strLatitude = listModel.latitude
        vc.listModel = listModel
        vc.isFromAddRoomDetail = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setHouseRulesTapped() {
        let vc = EditTitleAndSummaryVC(nibName: "EditTitleAndSummaryVC", bundle: nil)
        vc.strPlaceHolder = "How do you expect guests to behave?"
        vc.strTitle = "House Rules"
        vc.delegate = self
        vc.isFromRoomDesc = true
        vc.strAboutMe = listModel.additional_rules_msg as String
        vc.strRoomId = listModel.room_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setDescibePlace() {
        let vc = DescribePlaceVC(nibName: "DescribePlaceVC", bundle: nil)
        vc.delegate = self
        vc.strTitle = (listModel.room_title).characters.count > 0 ? listModel.room_title : ""
        vc.strRoomDesc = (listModel.room_description).characters.count > 0 ? listModel.room_description : ""
        vc.strRoomId = listModel.room_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func bookTypeTapped() {
        let vc = BookingTypeVC(nibName: "BookingTypeVC", bundle: nil)
        vc.arrListing = [instant_book,request_to_book]
        vc.txtTitle = "Booking Type"
        vc.strCurrentPolicy = listModel.booking_type
        vc.isBooking = true
        vc.listModel = self.listModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeRoomStatus() {
        lbStepsToList.text = listModel.isListEnabled == "Yes" ? "Listed" : "Ready to List"
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.isListEnabled = listModel.isListEnabled == "Yes" ? "No" : "Yes"
        lbStepsToList.text = listModel.isListEnabled == "Yes" ? "Listed" : "Ready to List"
        tblRoomDetail.tableFooterView = nil
        btnListSpace.isHidden = true
        self.listModel = tempModel
    }
    func checkHeader(){
        if listModel.room_thumb_images.count > 0 {
            imgRoom.sd_setImage(with: NSURL(string: listModel.room_thumb_images[0] as! String) as URL?, placeholderImage:UIImage(named:"addphoto_bg.png"))
            imgCheckImage.setTitle("9", for: .normal)
            vwAddPhoto.isHidden = true
        }else{
            self.imgRoom.image = UIImage(named: "addphoto_bg.png")
            self.vwAddPhoto.isHidden = false
        }
    }
    
    
    
    // MARK:- IBAction Method(s)
    
    @IBAction func btnPreviewClicked(_ sender: UIButton) {
        let homeVC = ProductDetail_VC(nibName: "ProductDetail_VC", bundle: nil)
        homeVC.roomId = listModel.room_id
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func btnOptionDetailsClicked(_ sender: UIButton) {
        let vc = OptionDetailVC(nibName: "OptionDetailVC", bundle: nil)
        vc.listModel = self.listModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnAddPhotoClicked(_ sender: UIButton) {
        if (listModel.room_thumb_images.count) > 0{
            let vc = AddPhotoVC(nibName: "AddPhotoVC", bundle: nil)
            vc.arrImages = listModel.room_thumb_images
            vc.arrRoomImageIds = listModel.room_thumb_image_ids
            vc.listModel = self.listModel
            self.navigationController?.pushViewController(vc, animated: true
            )
        } else {
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelActionButton = UIAlertAction(title: take_photo, style: .default) { _ in
                self.takePhoto()
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            let saveActionButton = UIAlertAction(title: choose_photo, style: .default) { _ in
                self.choosePhoto()
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            let deleteActionButton = UIAlertAction(title: cancel_s, style: .cancel) { _ in
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleBtnListSpace(_ sender: Any) {
        let dict = NSMutableDictionary()
        ProgressHud.shared.Animation = true
        dict["room_id"] = appDelegate?.strRoomID
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_DISABLE_LISTING, params: dict, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAdded"), object: self, userInfo: nil)
                    self.changeRoomStatus()
                }
                ProgressHud.shared.Animation = false
            }
        }) { (Error) in
            ProgressHud.shared.Animation = false
        }
    }
    
    
    // MARK:- Mempry Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Describe Place Delegate Method(s)
    
    func roomDescriptionChanged(strDescription: String, isTitle: Bool) {
        var tempModel = ListingModel()
        tempModel = listModel
        if isTitle {
            tempModel.room_title = strDescription
        } else {
            tempModel.room_description = strDescription
        }
        listModel = tempModel
        tblRoomDetail.reloadData()
    }
    
    // MARK: - ROOM IMAGE ADDED DELEGATE
    internal func RoomImageAdded(arrImgs:NSArray,arrImgIds:NSArray)
    {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.room_thumb_images = arrImgs as! NSMutableArray
        tempModel.room_thumb_image_ids = arrImgIds as! NSMutableArray
        listModel = tempModel
        self.checkHeader()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRoomAdded"), object: self, userInfo: nil)
    }
    
    // MARK:- Edit Title Delegate Method(s)
    
    func editTitleTapped(strDescription: String) {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.additional_rules_msg = strDescription
        listModel = tempModel
        tblRoomDetail.reloadData()
    }
    
    // MARK:- Location Delegate Method(s)
    
    func onHostRoomLocaitonChanged(modelList: ListingModel) {
        listModel = modelList
        tblRoomDetail.reloadData()
    }
    
}
