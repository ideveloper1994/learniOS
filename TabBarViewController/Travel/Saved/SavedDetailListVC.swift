//
//  SavedDetailListVC.swift
//  Arheb
//
//  Created on 6/10/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

protocol EditWishList
{
    func wishListEdited()
}


class SavedDetailListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var cvcSavedList: UICollectionView!
    
    @IBOutlet var vwNav: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblNoOfList: UILabel!
    var isLoading = true
    var privacyFlag = "0"
    var listTitle = ""
    
    @IBOutlet var vwInviteHeight: NSLayoutConstraint!
    var wishListDetail: WishListModel = WishListModel()
    var arrExplore = [ExploreModel]()
    var isTitleChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.localization()
        self.listTitle = self.wishListDetail.list_name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewcustomization()
        self.cvcSavedList.reloadData()
        if(!self.wishListDetail.list_id.isEmptyString()){
            self.getWhishListRoomDetail(listId: self.wishListDetail.list_id)
        }
        self.setDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCell(){
        cvcSavedList.register(UINib(nibName: "Explore_CVC", bundle: nil), forCellWithReuseIdentifier: "Explore_CVC")
        cvcSavedList.register(UINib(nibName: "LoaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:   "LoaderCollectionViewCell")
        cvcSavedList.dataSource = self
        cvcSavedList.delegate = self
    }
    
    //MARK: Here Customize the view
    func viewcustomization() {
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        vwNav.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    func setDetails() {
        if(!isLoading){
            let count = self.arrExplore.count
            if(self.arrExplore.count == 0){
                self.lblNoOfList.isHidden = true
            }else{
                self.lblNoOfList.isHidden = false
                self.lblNoOfList.text = String(describing: count) + " " + availableHome
            }
        }
        self.lblTitle.text = self.listTitle
        self.privacyFlag = self.wishListDetail.privacy
        self.vwInviteHeight.constant = 0
    }
    
    //MARK:- Collection view for Wishlist and Explore list
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isLoading){
            return 1
        }
        return arrExplore.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(isLoading){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoaderCollectionViewCell", for: indexPath) as! LoaderCollectionViewCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Explore_CVC", for: indexPath) as! Explore_CVC
        let objExplore = arrExplore[indexPath.row]
        
        let detail = objExplore.currency_symbol + " " + objExplore.room_price + " " + objExplore.room_type
        let textChange = objExplore.currency_symbol + " " + objExplore.room_price
        
        let attributedStr = attributedTextboldText(detail as NSString, boldText: textChange, fontSize: 18)
        cell.lbl_Master_Detail.attributedText = attributedStr
        cell.Main_Img.sd_setImage(with: URL(string: objExplore.room_thumb_image)!, placeholderImage:UIImage(named:""))
        cell.LoveBtn.tag = indexPath.row
        cell.LoveBtn.addTarget(self, action: #selector(btnWishlistClicked), for: .touchUpInside)
        cell.LoveBtn.setImage(#imageLiteral(resourceName: "heart_selected"), for: .normal)
        
        let reviewCount = Int(objExplore.reviews_count)
        if(reviewCount! > 0){
            cell.vwRatingConstant.constant = 30
            cell.lblRating.text = createRatingStar(ratingValue: objExplore.rating_value)
            cell.lbl_Review.text = objExplore.reviews_count + " " + review
            
        }else{
            cell.vwRatingConstant.constant = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeVC = ProductDetail_VC(nibName: "ProductDetail_VC", bundle: nil)
        homeVC.roomId = self.arrExplore[indexPath.row].room_id
        homeVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if(isLoading){
            return CGSize(width: UIScreen.main.bounds.size.width, height: 50)
        }
        let reviews_count = Int(arrExplore[indexPath.row].reviews_count)
        var height = UIScreen.main.bounds.size.width * 0.8
        if(reviews_count! > 0){
            height = height + 30
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: height)
    }
    
    @IBAction func btnEditTitleClicked(_ sender: Any) {
        let alertController = UIAlertController(title: alerTitle, message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: saveChanges, style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                self.lblTitle.text = field.text!
                if(self.wishListDetail.list_name != field.text!.trim()) {
                    self.isTitleChange = true
                    self.listTitle = field.text!.trim()
                    self.editListItem()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = wishListName
            textField.text = self.listTitle
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Remove from list
    func btnWishlistClicked(_ sender: UIButton) {
        let roomList = self.arrExplore[sender.tag]
        let settingsActionSheet: UIAlertController = UIAlertController(title:"Remove Listing", message:String(format:"Are you sure you want to delete \"%@\"?",roomList.room_name), preferredStyle:UIAlertControllerStyle.alert)
        settingsActionSheet.addAction(UIAlertAction(title:"Remove", style:UIAlertActionStyle.destructive, handler:{ action in
            self.removeListItem(roomId: roomList.room_id, index: sender.tag)
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK_- handle action sheet
    @IBAction func btnDisaplayActionClicked(_ sender: Any) {
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        //Make public or Private
        actionSheet.addAction(UIAlertAction.init(title: (self.privacyFlag == "0") ? makePrivate : makePublic, style: UIAlertActionStyle.default, handler: { (action) in
            self.privacyFlag = (self.privacyFlag == "0") ? "1" : "0"
            self.editListItem()
        }))
        
        //delete list
        actionSheet.addAction(UIAlertAction.init(title: deleteThisList, style: UIAlertActionStyle.destructive, handler: { (action) in
            self.removeSavedList()
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: cancel, style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK:- API call get whishlist details
    func getWhishListRoomDetail(listId: String) {
        self.isLoading = true
        let params = NSMutableDictionary()
        params.setValue(listId, forKey: "list_id")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_GET_PARTICULAR_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(response != nil) {
                        let resDic = response as! NSDictionary
                        let dicRes = resDic.value(forKey: "wishlist_details") as! NSArray
                        let roomList = ExploreModel().initiateExploreData(arrRes: dicRes)
                        self.isLoading = false
                        self.arrExplore = roomList
                        self.cvcSavedList.reloadData()
                        self.setDetails()
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
    func removeListItem(roomId: String, index: Int) {
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        params.setValue(roomId, forKey: "room_id")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_DELETE_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else {
                    if(response != nil){
                        let resDic = response as! NSDictionary
                        self.getWhishListRoomDetail(listId: self.wishListDetail.list_id)
                        ExploreVC.isWishListCreated = true
                        self.arrExplore.remove(at: index)
                        self.cvcSavedList.reloadData()
                    }
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    //0 for public
    //1 for private
    func editListItem() {
        ProgressHud.shared.Animation = true
        let roomId = 1
        let params = NSMutableDictionary()
        params.setValue(roomId, forKey: "list_id")
        params.setValue(self.listTitle, forKey: "list_name")
        params.setValue(self.privacyFlag, forKey: "privacy_type")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_CHANGE_PRIVACY_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(response != nil){
                        ExploreVC.isWishListCreated = true
                    }
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    func removeSavedList() {
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        params.setValue(self.wishListDetail.list_id, forKey: "list_id")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_DELETE_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(response != nil){
                        ExploreVC.isWishListCreated = true
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    // MARK:- Localization Method
    func localization() {
    }
    
}
