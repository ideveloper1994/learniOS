
import UIKit

class AddWishListItemVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblVisibleToFriends: UILabel!
    @IBOutlet var lblVisibleToEveryone: UILabel!
    @IBOutlet var lblPublic: UILabel!
    @IBOutlet var lblPrivacy: UILabel!
    @IBOutlet var imgPrivacy: UIImageView?
    @IBOutlet var imgPrivacy2: UIImageView?
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var lblPrivate: UILabel!
    
    var privacyFlag = 0
    var roomId = "0"
    var roomName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.set_Navigation_Bar()
        self.setPublicOrNot()
        self.localization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: Here Customize the view
    func set_Navigation_Bar() {
        self.navigationController?.isNavigationBarHidden = true
        self.txtTitle.delegate = self
        self.txtTitle.text = roomName
    }
    
    //0 for public
    //1 for private
    func setPublicOrNot(flag: Int = 0) {
        self.privacyFlag = flag
        if(flag == 0){
            self.imgPrivacy?.backgroundColor = UIColor(red: 41.0 / 255.0, green: 151.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
            self.imgPrivacy2?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            self.imgPrivacy?.image = UIImage(named:"small_tick")
            self.imgPrivacy2?.image = UIImage(named:"")
        }else {
            self.imgPrivacy2?.backgroundColor = UIColor(red: 41.0 / 255.0, green: 151.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
            self.imgPrivacy?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            self.imgPrivacy2?.image = UIImage(named:"small_tick")
            self.imgPrivacy?.image = UIImage(named:"")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Close the create view
    @IBAction func Btn_Close_VC(_ sender: UIButton) {
        self.dismiss(animated: true) { }
    }
    
    @IBAction func btnPublicClicked(_ sender: Any) {
        self.setPublicOrNot()
    }
    
    @IBAction func btnPrivateClicked(_ sender: Any) {
        self.setPublicOrNot(flag: 1)
    }
    
    @IBAction func btnCreateClicked(_ sender: Any) {
        if(!(self.txtTitle.text?.isEmptyString())!){
            self.roomName = (self.txtTitle.text?.trim())!
            self.addInWhishList()
        }
    }
    
    //MARK:- API call get whishlist details
    func addInWhishList() {
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        params.setValue(self.roomName, forKey: "list_name")
        params.setValue(self.roomId, forKey: "room_id")
        params.setValue(privacyFlag, forKey: "privacy_settings")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_ADD_TO_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!, isSuccess: false)
                }else{
                    ExploreVC.isWishListCreated = true
                    appDelegate?.isWishListCreated = true
                    self.dismiss(animated: true) { }
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            OperationQueue.main.addOperation {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    // MARK:- Localization Method
    func localization() {
        self.lblTitle.text = createList
        self.lblPrivacy.text = privacy
        self.lblVisibleToEveryone.text = visibleToEveryone
        self.lblPublic.text = Public
        self.lblVisibleToFriends.text = visibleToFriends
        self.lblPrivate.text = Private
        self.lblSubTitle.text = title
        self.btnCreate.setTitle(create, for: .normal)
    }
    
}
