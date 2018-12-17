//
//  SavedVC.swift
//  Arheb
//
//  Created on 5/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FLAnimatedImage

class SavedVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var cvcSavedList: UICollectionView!
    @IBOutlet var lblSaved: UILabel!
    @IBOutlet var vwNoList: UIView!
    var isLoading = true
    @IBOutlet var imgLoader: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.localization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isLoading = true
        self.viewcustomization()
        self.manageView()
        self.getWhishList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCell(){
        cvcSavedList.register(UINib(nibName: "Explore_CVC", bundle: nil), forCellWithReuseIdentifier: "Explore_CVC")
        cvcSavedList.dataSource = self
        cvcSavedList.delegate = self
    }
    
    func manageView() {
        setDotLoader(imgLoader!)
        if(isLoading){
            self.vwNoList.isHidden = true
            self.imgLoader.isHidden = false
            self.cvcSavedList.isHidden = true
        }else{
            self.imgLoader.isHidden = true
            if(appDelegate?.arrWishList.count == 0){
                self.vwNoList.isHidden = false
                self.cvcSavedList.isHidden = true
            }else{
                self.vwNoList.isHidden = true
                self.cvcSavedList.isHidden = false
            }
        }
    }
    
    //MARK: Here Customize the view
    func viewcustomization() {
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    //MARK:- Collection view for Wishlist and Explore list
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (appDelegate?.arrWishList.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Explore_CVC", for: indexPath) as! Explore_CVC
        let objWishList = appDelegate?.arrWishList[indexPath.row]
        cell.LoveBtn.isHidden = true
        cell.vwRatingConstant.constant = 0
        if((objWishList?.room_thumb_images?.count)! > 0){
            if((objWishList?.room_thumb_images?.object(at: 0) as! String) != "" ) {
                cell.Main_Img.sd_setImage(with: URL(string: objWishList?.room_thumb_images?.object(at: 0) as! String)!, placeholderImage:UIImage(named:""))
            }
        }
        let count = String(describing: objWishList!.room_thumb_images!.count)
        cell.lbl_Master_Detail.text = (objWishList?.list_name)!  + " - " + count + " " +  listing
        if(count == "0"){
            cell.lbl_Master_Detail.text = (objWishList?.list_name)! + " " + nothing
        }else{
            cell.lbl_Master_Detail.text = (objWishList?.list_name)!  + " - " + count + " " +  listing
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = SavedDetailListVC(nibName: "SavedDetailListVC", bundle: nil)
        detailVC.wishListDetail = (appDelegate?.arrWishList[indexPath.row])!
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 0.8)
    }
    
    @IBAction func btnFindHomeClicked(_ sender: Any) {
        let tabbar:ArhebTabbar =  appDelegate?.window?.rootViewController as! ArhebTabbar
        tabbar.selectedIndex = 0
    }
    //MARK:- API call get whishlist details
    func getWhishList() {
        self.isLoading = true
        let params = NSMutableDictionary()
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_GET_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    //showToastMessage(error!, isSuccess: false)
                    appDelegate?.arrWishList.removeAll()
                    self.cvcSavedList.reloadData()
                    self.isLoading = false
                    self.manageView()
                }else{
                    let resDic = response as! NSDictionary
                    let dicRes = resDic.value(forKey: "wishlist_data") as! NSArray
                    appDelegate?.arrWishList.removeAll()
                    appDelegate?.arrWishList = WishListModel().initiateWishListData(arrRes: dicRes)
                    self.cvcSavedList.reloadData()
                    self.isLoading = false
                    self.manageView()
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                
            }
        }
    }
    
    // MARK:- Localization Method
    func localization() {
        self.lblSaved.text = saved
    }
    
}
