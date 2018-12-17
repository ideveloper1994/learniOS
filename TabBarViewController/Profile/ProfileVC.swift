//
//  ProfileVC.swift
//  Arheb
//
//  Created on 5/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tblProfile: UITableView!
    var arrOptions: [String] = []
    var arrOptionImage: [UIImage] = []
    static var userDetail = UserModel()
    
    //Switching View
    
    @IBOutlet var vwSwitch: UIView!
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var lblSwitchMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
        self.setDetails()
        self.getUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewcustomization()
        self.tblProfile.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Customize the view
    func viewcustomization(){
        self.navigationController?.navigationBar.isHidden = true
        self.tblProfile.tableFooterView = UIView()
    }
    
    //MARK:- Register Profile table
    func registerTableView() {
        tblProfile.dataSource = self
        tblProfile.delegate = self
        tblProfile.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellReuseIdentifier: "ProfileHeaderCell")
        tblProfile.register(UINib(nibName: "ProfileOptionsCell", bundle: nil), forCellReuseIdentifier: "ProfileOptionsCell")
    }
    
    func setDetails() {
        let host:String = UserDefaults.standard.value(forKey: UserDefaultKey.kHostorTravel) as! String
        let strHostorTravel = (host == HostOrTravel.host) ? switchToTravel  : switchToHost
        arrOptions = [ strHostorTravel, settings, helpNsupport, whyHost]
        arrOptionImage = [#imageLiteral(resourceName: "switch"), #imageLiteral(resourceName: "setting"), #imageLiteral(resourceName: "help"), #imageLiteral(resourceName: "whyhost")]
    }
    
    //MARK:- Profile Option table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOptions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tblProfile.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            if(!ProfileVC.userDetail.first_name.isEmptyString()){
                cell.lblUserName.text = (ProfileVC.userDetail.first_name) + " " + (ProfileVC.userDetail.last_name)
            }
            if(!ProfileVC.userDetail.large_image_url.isEmptyString()){
                cell.imgProfile.sd_setImage(with: URL(string: ProfileVC.userDetail.large_image_url), placeholderImage:UIImage(named:""))
            }
            return cell
        }else{
            let cell = tblProfile.dequeueReusableCell(withIdentifier: "ProfileOptionsCell", for: indexPath) as! ProfileOptionsCell
            cell.lblTitle.text = arrOptions[indexPath.row - 1]
            cell.imgOptions.image = arrOptionImage[indexPath.row - 1]
            cell.imgOptions.setTintColor(color: UIColor.gray)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 150
        }
        return 70
    }
    
    //MARK: Perform all navigation from the options
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            let viewProfile = ProfileDetailVC(nibName: "ProfileDetailVC", bundle: nil)
            ProfileDetailVC.userDetail = ProfileVC.userDetail
            viewProfile.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewProfile, animated: true)
        }else{
            //MARK:- Switching between Host and Travel
            if(arrOptions[indexPath.row-1] == switchToTravel || arrOptions[indexPath.row-1] == switchToHost){
                let hostOrTravel:String = UserDefaults.standard.value(forKey: UserDefaultKey.kHostorTravel) as! String
                //Design the progress view appear when switching
                if(hostOrTravel == HostOrTravel.host){
                    setNsuserDefaultValue(value: HostOrTravel.travel, key: UserDefaultKey.kHostorTravel)
                    self.vwSwitch.backgroundColor = UIColor.white
                    self.lblSwitchMessage.text = switchingToTravel
                    self.lblSwitchMessage.textColor = UIColor.gray
                    self.imgLogo.setTintColor(color: UIColor.gray)
                }else{
                    self.vwSwitch.backgroundColor = UIColor.darkGray
                    self.imgLogo.setTintColor(color: UIColor.white)
                    self.lblSwitchMessage.textColor = UIColor.white
                    self.lblSwitchMessage.text = switchingToHost
                    setNsuserDefaultValue(value: HostOrTravel.host, key: UserDefaultKey.kHostorTravel)
                }
                self.tabBarController?.tabBar.isHidden = true
                self.tblProfile.isHidden = true
                self.vwSwitch.isHidden = false
                let when = DispatchTime.now() + 1
                //MARK:- Set Root view when switch
                DispatchQueue.main.asyncAfter(deadline: when) {
                    let hostVC = ArhebTabbar()
                    appDelegate?.window?.rootViewController = hostVC
                }
            }else if(arrOptions[indexPath.row-1] == settings){
                let settingVC = SettingsVC(nibName: "SettingsVC", bundle: nil)
                self.navigationController?.pushViewController(settingVC, animated: true)
            }else if(arrOptions[indexPath.row-1] == helpNsupport){
                let objLoadWebView = LoadWebView(nibName: "LoadWebView", bundle: nil)
                objLoadWebView.hidesBottomBarWhenPushed = true
                objLoadWebView.strPageTitle = helpNsupport
                objLoadWebView.strWebUrl = webServerUrl + URL_HELPS_SUPPORT
                self.navigationController?.pushViewController(objLoadWebView, animated: true)
            }else if(arrOptions[indexPath.row-1] == whyHost){
                let objLoadWebView = LoadWebView(nibName: "LoadWebView", bundle: nil)
                objLoadWebView.hidesBottomBarWhenPushed = true
                objLoadWebView.strPageTitle = whyHost
                var authToken = ""
                if KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken) != nil{
                    authToken = KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken)!
                }
                let hostUrl = String(format:"%@%@?token=%@",webServerUrl,URL_WHY_HOST,authToken)
                objLoadWebView.strWebUrl = hostUrl
                self.navigationController?.pushViewController(objLoadWebView, animated: true)
            }
        }
    }
    
    
    //MARK: Get User details
    func getUserProfile()
    {
        ProgressHud.shared.Animation = true
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_VIEW_PROFILE, params: NSMutableDictionary(), isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    let dictRes = response as! NSDictionary
                    if let userDic = dictRes.value(forKey: "user_details") {
                        let dic = userDic as! NSDictionary
                        ProfileVC.userDetail = UserModel().initiateProfileData(res: dic)
                        let objLogin = getUserDetails()
                        objLogin?.first_name = ProfileDetailVC.userDetail.first_name
                        objLogin?.last_name = ProfileDetailVC.userDetail.last_name
                        objLogin?.user_image_small = ProfileDetailVC.userDetail.small_image_url
                        objLogin?.user_image_large = ProfileDetailVC.userDetail.large_image_url
                        setUserDetails(user: objLogin!)
                        self.tblProfile.reloadData()
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
