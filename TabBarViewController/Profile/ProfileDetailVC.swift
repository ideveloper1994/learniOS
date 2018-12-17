//
//  ProfileDetailVC.swift
//  Arheb
//
//  Created on 6/1/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ProfileDetailVC: UIViewController {
    
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblJoinFrom: UILabel!
    static var userDetail = UserModel()
    static var isProfileEdited: Bool = false
    var otherUserId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewCustomization()
        if(ProfileDetailVC.isProfileEdited){
            ProfileDetailVC.isProfileEdited = false
            if(otherUserId.isEmptyString()){
                self.getUserProfile()
            }else{
                self.btnEdit.isHidden = true
                self.getOtherUserProfile()
            }
            
        }else{
            if(otherUserId != "") {
                self.getOtherUserProfile()
                if(otherUserId == getUserDetails()?.user_id){
                    self.btnEdit.isHidden = false
                }else{
                    self.btnEdit.isHidden = true
                }
            }else{
                self.lblJoinFrom.text = memberFrom + " " + ProfileDetailVC.userDetail.member_from
                if(ProfileDetailVC.userDetail.large_image_url != ""){
                    self.imgProfile?.sd_setImage(with: URL(string: ProfileDetailVC.userDetail.large_image_url)!, placeholderImage:UIImage(named:""))
                }
                self.lblUserName.text = ProfileDetailVC.userDetail.first_name + " " + ProfileDetailVC.userDetail.last_name
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Customize the view
    func viewCustomization(){
        self.navigationController?.navigationBar.isHidden = true
        self.btnEdit.layer.cornerRadius = btnEdit.frame.width/2
        self.btnEdit.clipsToBounds = true
        self.btnEdit.layer.borderWidth = 2
        self.btnEdit.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        lblJoinFrom.text = memberFrom
    }
    
    //MARK: - IBAction Method
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditClicked(_ sender: Any) {
        let editProfile = EditProfileVC(nibName: "EditProfileVC", bundle: nil)
        editProfile.hidesBottomBarWhenPushed = true
        EditProfileVC.objUser = ProfileDetailVC.userDetail
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    
    //MARK: Get User details
    func getUserProfile()
    {
        ProgressHud.shared.Animation = true
        let userObj = getUserDetails()
        btnEdit.isEnabled = false
        self.lblUserName.text = (userObj?.first_name)! + " " + (userObj?.last_name)!
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_VIEW_PROFILE, params: NSMutableDictionary(), isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil) {
                    showToastMessage(error!)
                }else{
                    let dictRes = response as! NSDictionary
                    if let userDic = dictRes.value(forKey: "user_details") {
                        let dic = userDic as! NSDictionary
                        ProfileDetailVC.userDetail = UserModel().initiateProfileData(res: dic)
                        ProfileVC.userDetail = ProfileDetailVC.userDetail
                        self.lblUserName.text = ProfileDetailVC.userDetail.first_name + " " + ProfileDetailVC.userDetail.last_name
                        self.lblJoinFrom.text = memberFrom + " " + ProfileDetailVC.userDetail.member_from
                        let objLogin = getUserDetails()
                        objLogin?.first_name = ProfileDetailVC.userDetail.first_name
                        objLogin?.last_name = ProfileDetailVC.userDetail.last_name
                        objLogin?.user_image_small = ProfileDetailVC.userDetail.small_image_url
                        objLogin?.user_image_large = ProfileDetailVC.userDetail.large_image_url
                        setUserDetails(user: objLogin!)
                        self.imgProfile?.sd_setImage(with: URL(string: ProfileDetailVC.userDetail.large_image_url)!, placeholderImage:UIImage(named:""))
                        self.btnEdit.isEnabled = true
                    }
                    ProgressHud.shared.Animation = false
                }
            }
        }) { (error) in
            OperationQueue.main.addOperation {
                ProgressHud.shared.Animation = false
            }
        }
    }
    //MARK: Get Other details
    func getOtherUserProfile()
    {
        ProgressHud.shared.Animation = true
        let param = NSMutableDictionary()
        param.setValue(otherUserId, forKey: "other_user_id")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_VIEW_OTHER_PROFILE, params: param, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    let dictRes = response as! NSDictionary
                    if let userDic = dictRes.value(forKey: "user_details") {
                        let dic = userDic as! NSDictionary
                        let objGuestDetail = GuestUserModel().initiateProfileData(res: dic)
                        self.lblUserName.text = objGuestDetail.first_name + " " + objGuestDetail.last_name
                        self.lblJoinFrom.text = memberFrom + " " + objGuestDetail.member_from
                        self.imgProfile?.sd_setImage(with: URL(string: objGuestDetail.large_image)!, placeholderImage:UIImage(named:""))
                        if(self.otherUserId == getUserDetails()?.user_id){
                            self.btnEdit.isHidden = false
                        }else{
                            self.btnEdit.isHidden = true
                        }
                    }
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            OperationQueue.main.addOperation {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    
}
