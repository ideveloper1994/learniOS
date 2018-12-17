//
//  Main.swift
//  Makent
//
//  Created on 5/29/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class Main: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    
    @IBOutlet weak var vwCreateAccount: UIView!
    @IBOutlet weak var vwGoogle: UIView!
    @IBOutlet weak var vwFacebook: UIView!
    
    @IBOutlet var lblLogIn: UIButton!
    @IBOutlet var lblWlcomeToApp: UILabel!
    @IBOutlet var lblFb: UILabel!
    @IBOutlet var lblGoogle: UILabel!
    @IBOutlet var lblCreateAcc: UILabel!
    @IBOutlet var lblInfo: UILabel!
    @IBOutlet var btnHelp: UIButton!
    
    var param = NSMutableDictionary()
    var isFacebook = Bool()
    var fbFirstName: String = ""
    var fbLastName: String = ""
    var fbDob: String = ""
    var fbId: String = ""
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        //UIView.appearance().semanticContentAttribute = .forceRightToLeft
    }
    
    func viewcustomization(){
        self.navigationController?.navigationBar.isHidden = true
        vwGoogle.layer.masksToBounds = false
        vwGoogle.layer.cornerRadius = 20
        vwFacebook.layer.masksToBounds = false
        vwFacebook.layer.cornerRadius = 20
        vwCreateAccount.layer.masksToBounds = false
        vwCreateAccount.layer.cornerRadius = 20
        vwCreateAccount.layer.borderWidth = 1.0
        vwCreateAccount.layer.borderColor = UIColor.white.cgColor
    
        lblLogIn.setTitle(logIn, for: .normal)
        btnHelp.setTitle(helpNSupport, for: .normal)
        lblWlcomeToApp.text = welcomeMakent
        lblFb.text = continueFacebook
        lblGoogle.text = continueGoogle
        lblCreateAcc.text = createAccount
        lblInfo.text = termsOfService
        
    }
    
    //MARK: - IBAction Method
    @IBAction func btnCreateAccountClicked(_ sender: Any) {
        
        let signUpVC = SignUpVC(nibName: "SignUpVC", bundle: nil)
        self.navigationController?.pushViewController(signUpVC, animated: true)
        isFacebook = false
        
    }
    
    @IBAction func btnGoogleClicked(_ sender: Any) {
        isFacebook = false
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnFacebookClicked(_ sender: Any) {
        isFacebook = true
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.browser
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email","user_location","user_birthday","user_hometown"], from: self) { (result, error) in
            if(error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil
                {
                    if(fbloginresult.grantedPermissions.contains("public_profile"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        let loginVC = LoginVC(nibName:"LoginVC", bundle: nil)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func btnHelpClicked(_ sender: Any) {
        let objLoadWebView = LoadWebView(nibName: "LoadWebView", bundle: nil)
        objLoadWebView.hidesBottomBarWhenPushed = true
        objLoadWebView.strPageTitle = helpNsupport
        objLoadWebView.strWebUrl = webServerUrl + URL_HELPS_SUPPORT
        self.navigationController?.pushViewController(objLoadWebView, animated: true)
    }
    
    
    //MARK: - Custom Method
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, birthday, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let newresult = result as? NSDictionary
                    let emailId = (newresult?["email"] != nil) ? newresult?["email"] as! String : ""
                    self.fbFirstName = (newresult?["first_name"] != nil) ? newresult?["first_name"] as! String : ""
                    self.fbLastName = (newresult?["last_name"] != nil) ? newresult?["last_name"] as! String : ""
                    self.fbId = newresult?["id"] as! String
                    self.param.setValue(emailId, forKey: Signup.emailId)
                    self.param.setValue("", forKey: Signup.password)
                    self.param.setValue(self.fbFirstName, forKey: Signup.firstName)
                    self.param.setValue(self.fbLastName, forKey: Signup.lastName)
                    self.param.setValue(newresult?["id"], forKey: Signup.facebookId)
                    if (newresult?["birthday"] != nil)
                    {
                        let strDob = newresult?["birthday"] as! NSString
                        let arrDob = strDob.components(separatedBy: "/")
                        if arrDob.count>2 {
                            self.fbDob = (String(format: "%@-%@-%@", arrDob[1],arrDob[0],arrDob[2]) as NSString) as String
                            
                            self.param.setValue(self.fbDob, forKey: Signup.dob)
                        }else{
                            self.fbDob = ""
                            self.param.setValue("", forKey: Signup.dob)
                        }
                    }
                    else {
                        self.fbDob = ""
                        self.param.setValue("", forKey: Signup.dob)
                    }
                    if newresult?.value(forKeyPath:"picture.data.url") != nil
                    {
                        self.param["profile_pic"] = newresult?.value(forKeyPath:"picture.data.url") as! String
                    }
                    self.callSignUp()
                }
            })
        }
    }
    
    //MARK: - Google SignIn delegate Method
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //SHOW LOADING INDICATOR HERE
        print(error)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if(error == nil){
            if GIDSignIn.sharedInstance().currentUser.profile.hasImage {
                let dimension = round(120 * UIScreen.main.scale)
                let imageURL = user.profile.imageURL(withDimension: UInt(dimension))
                param["profile_pic"] = imageURL?.absoluteString //String(format:"%@",imageURL)
            }
            if(user.profile.email != nil){
                param.setValue(user.profile.email, forKey: Signup.emailId)
            }
            if(user.profile.givenName != nil){
                param.setValue(user.profile.givenName, forKey: Signup.firstName)
            }
            if(user.profile.givenName != nil){
                param.setValue(user.profile.familyName, forKey: Signup.lastName)
            }
            if(user.userID != nil){
                param.setValue(user.userID, forKey: Signup.googleId)
            }
            param.setValue("", forKey: Signup.password)
            param.setValue("", forKey: Signup.dob)
            
            callSignUp()
            
        }else{
            
        }
    }
    
    //MARK: - Api calling Method
    func callSignUp(){
        ProgressHud.shared.Animation = true
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_SIGNUP, params: param, isTokenRequired: false, forSuccessionBlock: { (res, error) in
            OperationQueue.main.addOperation {
                let dictRes:NSDictionary = res as! NSDictionary;
                var objLoginModel = LoginModel()
                objLoginModel =  objLoginModel.addResponseToLogin(res: dictRes)
                if(error != nil) {
                    if self.isFacebook
                    {
                        if objLoginModel.success_message == "Please Update Your Email Id"
                        {
                            let fbVC = FacebookSignUpVC(nibName: "FacebookSignUpVC", bundle: nil)
                            fbVC.firstName = self.fbFirstName
                            fbVC.lastName = self.fbLastName
                            fbVC.dob = self.fbDob
                            fbVC.fbId = self.fbId
                            self.navigationController?.pushViewController(fbVC, animated: true)
                        }
                        else {
                            showToastMessage(error!)
                        }
                    }else {
                        showToastMessage(error!)
                    }
                }else {
                    setUserDetails(user: objLoginModel)
                    self.dismiss(animated: true, completion: nil)
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            print(error)
            ProgressHud.shared.Animation = false
        }
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
