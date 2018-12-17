//
//  AddWishlistVC.swift
//  Arheb
//
//  Created by devloper65 on 6/15/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class AddWishlistVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var Const_whishlist_Inner: NSLayoutConstraint!
    @IBOutlet var VW_whishlist_Outer: UIView!
    @IBOutlet var CV_WhishListSelection: UICollectionView!
    
    var strRoomId:String = ""
    var strRoomName:String = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (appDelegate?.isWishListCreated)!{
            appDelegate?.isWishListCreated = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.addWishlist), object: nil)
            getWhishList()
        }
        CV_WhishListSelection.reloadData()
    }
    
    
    func registerCell(){
        CV_WhishListSelection.register(UINib(nibName: "CVC_Whishlist", bundle: nil), forCellWithReuseIdentifier: "CVC_Whishlist")
    }
    
    //MARK: - Collectionview Delegate & Datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (appDelegate?.arrWishList.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVC_Whishlist", for: indexPath) as! CVC_Whishlist
        let objWishList =  appDelegate!.arrWishList[indexPath.row]
        //self.arrWhishList[indexPath.row]
        if((objWishList.room_thumb_images?.count)! > 0){
            if(objWishList.room_thumb_images?.count == 3 ){
                cell.img_1_1.isHidden = true
                cell.vw_2.isHidden = true
                cell.vw_3.isHidden = false
                if((objWishList.room_thumb_images?.object(at: 0) as! String) != "" ){
                    cell.img_3_1.sd_setImage(with: URL(string: objWishList.room_thumb_images?.object(at: 0) as! String)!, placeholderImage:UIImage(named:""))
                }
                if((objWishList.room_thumb_images?.object(at: 1) as! String) != "" ){
                    cell.img_3_2.sd_setImage(with: URL(string: objWishList.room_thumb_images?.object(at: 1) as! String)!, placeholderImage:UIImage(named:""))
                }
                if((objWishList.room_thumb_images?.object(at: 2) as! String) != "" ){
                    cell.img_3_3.sd_setImage(with: URL(string: objWishList.room_thumb_images?.object(at: 2) as! String)!, placeholderImage:UIImage(named:""))
                }
            }else if(objWishList.room_thumb_images?.count == 2 ){
                cell.img_1_1.isHidden = true
                cell.vw_2.isHidden = false
                cell.vw_3.isHidden = true
                cell.img_2_1.sd_setImage(with: URL(string: objWishList.room_thumb_images?.object(at: 0) as! String)!, placeholderImage:UIImage(named:""))
                cell.img_2_2.sd_setImage(with: URL(string: objWishList.room_thumb_images?.object(at: 1) as! String)!, placeholderImage:UIImage(named:""))
            }else{
                cell.img_1_1.isHidden = false
                cell.vw_2.isHidden = true
                cell.vw_3.isHidden = true
                if((objWishList.room_thumb_images?.object(at: 0) as! String) != "" ){
                    cell.img_1_1.sd_setImage(with: URL(string: objWishList.room_thumb_images?.object(at: 0) as! String)!, placeholderImage:UIImage(named:""))
                }
            }
        }
        let count = String(describing: objWishList.room_thumb_images!.count)
        
        if(count == "0"){
            cell.lblDetail.text = objWishList.list_name  + " " + nothing
        }else{
            cell.lblDetail.text = objWishList.list_name  + " " + count + " " +  listing
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        self.addInExistingList(index: indexPath.row)
    }
    
    
    //MARK: - IBAction Method
    @IBAction func btnBackClicked(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func Btn_Add_New_WhishList(_ sender: UIButton) {
        let createVc = AddWishListItemVC(nibName: "AddWishListItemVC", bundle: nil)
        createVc.roomName = strRoomName
        createVc.roomId = strRoomId
        self.present(UINavigationController(rootViewController: createVc), animated: true, completion: {})
    }
    
    //MARK:- API call add in Existing whishlist details
    func addInExistingList(index: Int) {
        ProgressHud.shared.Animation = true
        let objWishlist = appDelegate!.arrWishList[index]//self.arrWhishList[index]
        let roomId = strRoomId
        let params = NSMutableDictionary()
        params.setValue(objWishlist.list_name, forKey: "list_name")
        params.setValue(roomId, forKey: "room_id")
        params.setValue(objWishlist.privacy, forKey: "privacy_settings")
        params.setValue(objWishlist.list_id, forKey: "list_id")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_ADD_TO_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response,error) in
            DispatchQueue.main.async {
                if(error != nil) {
                    showToastMessage(error!)
                }else{
                    if(response != nil) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.addWishlist), object: nil)
                        self.getWhishList()
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
            }
        }
    }
    func getWhishList() {
        let params = NSMutableDictionary()
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_GET_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(response != nil) {
                        ProgressHud.shared.Animation = false
                        let resDic = response as! NSDictionary
                        let dicRes = resDic.value(forKey: "wishlist_data") as! NSArray
                        appDelegate?.arrWishList.removeAll()
                        appDelegate?.arrWishList = WishListModel().initiateWishListData(arrRes: dicRes)
                        self.CV_WhishListSelection.reloadData()
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
