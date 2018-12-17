
import UIKit
import FLAnimatedImage

class ProductDetail_VC: UIViewController, UIScrollViewDelegate,UICollectionViewDelegate , UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, WWCalendarTimeSelectorProtocol {
    
    @IBOutlet var VW_scr: UIScrollView!
    
    //Navigation
    @IBOutlet var vwTop: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var btnLike: UIButton!
    
    @IBOutlet var vwScrollImg: UIScrollView!
    
    @IBOutlet var lblRoomTitle: UILabel!
    
    @IBOutlet var roomInfo: UILabel!
    @IBOutlet var lbltitleHostedby: UILabel!
    @IBOutlet var lblHostedBy: UILabel!
    @IBOutlet var imgHostProfile: UIImageView!
    
    @IBOutlet var lblNoOfGuest: UILabel!
    @IBOutlet var lblNoOfRoom: UILabel!
    @IBOutlet var lblNoOfBed: UILabel!
    @IBOutlet var lblNoOfBathroom: UILabel!
    
    @IBOutlet var lblTitleAboutHome: UILabel!
    @IBOutlet var lblDetail: UILabel!
    
    @IBOutlet var imgLoader: FLAnimatedImageView!
    
    var objRoomDetail = RoomDetailModel()
    var arrOption = [String]()
    var isLoading = true
    fileprivate var singleDate: Date = Date()
    var multipleDates: [Date] = []
    var roomImages = [String]()
    var strCheckInDate = ""
    var strCheckOutDate = ""
    
    //Amenities
    
    @IBOutlet var lblA1: UILabel!
    @IBOutlet var lblA2: UILabel!
    @IBOutlet var lblA3: UILabel!
    @IBOutlet var lblA4: UILabel!
    
    @IBOutlet var btnAllOther: UIButton!
    
    //Rating Header
    @IBOutlet var vwRatingHeaderView: UIView!
    @IBOutlet var tblOptions: UITableView!
    
    @IBOutlet var imgRatingUser: UIImageView!
    @IBOutlet var lblRatingUserName: UILabel!
    @IBOutlet var lblRatingDate: UILabel!
    @IBOutlet var lblReviewText: UILabel!
    @IBOutlet var lblReviewCounts: UILabel!
    @IBOutlet var lblTotalRatingStart: UILabel!
    
    @IBOutlet var lblTitleSimilerList: UILabel!
    
    @IBOutlet var cvcRooms: UICollectionView!
    @IBOutlet var lblMapTitle: UILabel!
    
    //Map
    @IBOutlet var imgMap: UIImageView!
    
    //Bottom View
    @IBOutlet var vwBottom: UIView!
    @IBOutlet var lblPriceDetail: UILabel!
    @IBOutlet var lblReviewStar: UILabel!
    @IBOutlet var lblReviewCount: UILabel!
    @IBOutlet var btnBook: UIButton!
    
    //Height Constant
    @IBOutlet var vwMainHeight: NSLayoutConstraint!
    @IBOutlet var vSimilarListHeight: NSLayoutConstraint!
    @IBOutlet var vwTableHeight: NSLayoutConstraint!
    
    var lastContentOffset: CGFloat = 0
    var roomId = "0"
    var selectedIndex = 0
    var isMainRoomSelected = false
    
    var topTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewcustomization()
        VW_scr.delegate = self
        self.registerCell()
        NotificationCenter.default.addObserver(self, selector: #selector(self.addedWishList(notification:)), name: NSNotification.Name(rawValue: NotificationName.addWishlist), object: nil)
        self.viewcustomization()
        self.getRoomDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Register cell
    func registerCell(){
        cvcRooms.dataSource = self
        cvcRooms.delegate = self
        cvcRooms.register(UINib(nibName: "Explore_CVC", bundle: nil), forCellWithReuseIdentifier: "Explore_CVC")
        tblOptions.dataSource = self
        tblOptions.delegate = self
        tblOptions.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        
    }
    
    //MARK: Here Customize the view
    func viewcustomization() {
        setDotLoader(imgLoader!)
        self.isLoading = true
        self.navigationController?.isNavigationBarHidden = true
        vwTop.layer.shadowColor = UIColor.lightGray.cgColor
        vwBottom.layer.shadowColor = UIColor.gray.cgColor
        vwBottom.layer.shadowOffset = CGSize(width:0, height:1.0)
        vwBottom.layer.shadowOpacity = 1.5
        vwBottom.layer.shadowRadius = 2.0
        self.manageView()
    }
    
    //Manage view and set details
    func manageView() {
        if(self.isLoading) {
            self.imgLoader.isHidden = false
            self.VW_scr.isHidden = true
            self.vwBottom.isHidden = true
        }else{
            self.imgLoader.isHidden = true
            self.VW_scr.isHidden = false
        }
    }
    
    func setDetails() {
        self.lblRoomTitle.text = self.objRoomDetail.room_name
        self.roomInfo.text = self.objRoomDetail.room_type
        self.lbltitleHostedby.text = hostedBy
        self.lblHostedBy.text = self.objRoomDetail.host_user_name
        self.lblNoOfGuest.text = self.objRoomDetail.no_of_beds + " " + bed
        self.lblNoOfBed.text = self.objRoomDetail.no_of_beds + " " + bed
        self.lblNoOfBed.text = self.objRoomDetail.no_of_beds + " " + bed
        self.lblNoOfBed.text = self.objRoomDetail.no_of_beds + " " + bed
        self.setMapInfo()
        
        if(!objRoomDetail.host_user_image.isEmptyString()) {
            self.imgHostProfile?.sd_setImage(with: URL(string: objRoomDetail.host_user_image)!, placeholderImage:UIImage(named:""))
        }
        self.lblTitleAboutHome.text = aboutHome
        self.lblDetail.text = self.objRoomDetail.room_detail
        self.lblTitleSimilerList.text = similarListing
        
        if(objRoomDetail.is_whishlist == "Yes"){
            btnLike.setTitle("C", for: .normal)
            btnLike.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
            
        }else{
            btnLike.setTitle("B", for: .normal)
            btnLike.setTitleColor(UIColor.white, for: .normal)
        }
        
        var height: CGFloat = 1264
        //similar list
        if(self.objRoomDetail.similar_list_details.count > 0){
            self.cvcRooms.isHidden = false
            self.lblTitleSimilerList.isHidden = false
            self.cvcRooms.reloadData()
        }else{
            self.cvcRooms.isHidden = true
            self.lblTitleSimilerList.isHidden = true
            self.vSimilarListHeight.constant = 0
            height = height - 320
        }
        
        arrOption.removeAll()
        arrOption.append(flexiblePolicy)
        arrOption.append(additionalPrice)
        
        let objUser = getUserDetails()
        if(objUser?.user_id != objRoomDetail.host_user_id) {
            arrOption.append(checkAvailability)
            arrOption.append(contactHost)
        }
        
        self.roomImages.removeAll()
        for img in objRoomDetail.room_images{
            self.roomImages.append(img as! String)
        }
        //Slider
        self.setUpTopScrollView(scrMain: self.vwScrollImg)
        self.VW_scr.contentOffset = CGPoint(x: self.VW_scr.contentOffset.x, y: 1)
        
        var tableHeight: CGFloat = 0
        //Set Ratting view
        if(objRoomDetail.review_count != "" && objRoomDetail.review_count != "0"){
            lblRatingUserName.text = objRoomDetail.review_user_name
            lblRatingDate.text = objRoomDetail.review_date
            lblReviewText.text = objRoomDetail.review_message
            lblReviewCounts.text = readAll + " " + objRoomDetail.review_count + " " + review
            if(!objRoomDetail.review_user_image.isEmptyString()) {
                self.imgRatingUser.sd_setImage(with: URL(string: objRoomDetail.review_user_image)!, placeholderImage:UIImage(named:""))
            }
            lblTotalRatingStart.text = createRatingStar(ratingValue: objRoomDetail.rating_value)
            tblOptions.tableHeaderView = vwRatingHeaderView
            tableHeight += 145
        }
        let count = CGFloat(arrOption.count)
        self.tblOptions.reloadData()
        self.vwTableHeight.constant = 60 * count + tableHeight
        self.vwMainHeight.constant = height + 60 * count + tableHeight
        
        let countAmenities = String(self.objRoomDetail.amenitiesList.count - 4) + "+"
        self.btnAllOther.setTitle(countAmenities, for: .normal)
        
        //Bottom Bar
        self.setBottomBar()
    }
    
    //MARK:- Top Slider
    func setUpTopScrollView(scrMain: UIScrollView) {
        var startIndex: CGFloat = 0
        for i in 0..<self.roomImages.count {
            startIndex = CGFloat(i) * scrMain.frame.size.width
            let thumbImageUrl = URL(string: (self.roomImages[i].addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!))
            let imgView: UIImageView = UIImageView(frame: CGRect(x: startIndex, y: 0, width: Screen.width, height: scrMain.frame.size.height))
            imgView.backgroundColor = UIColor.groupTableViewBackground
            imgView.sd_setImage(with: thumbImageUrl, placeholderImage: UIImage(named: ""))
            imgView.contentMode = .scaleToFill
            imgView.tag = i + 1
            let myButton:UIButton = UIButton()
            myButton.frame =  CGRect(x: startIndex, y:0, width: Screen.width ,height: scrMain.frame.size.height)
            myButton.tag = i
            myButton.addTarget(self, action: #selector(self.onImageTapped), for: UIControlEvents.touchUpInside)
            scrMain.addSubview(imgView)
            scrMain.addSubview(myButton)
        }
        scrMain.contentSize = CGSize(width: Screen.width * CGFloat(self.roomImages.count), height: scrMain.frame.size.height)
        scrMain.delegate = self
        scrMain.isPagingEnabled = true
        topTimer.invalidate()
        topTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.moveToNextPageTop), userInfo: nil, repeats: true)
    }
    
    func onImageTapped(sender:UIButton)
    {
        let photoBrowser = SYPhotoBrowser(imageSourceArray: self.roomImages, caption: "", delegate: self)
        photoBrowser?.initialPageIndex = UInt(sender.tag)
        photoBrowser?.pageControlStyle = SYPhotoBrowserPageControlStyle.label
        photoBrowser?.enableStatusBarHidden = true
        self.present((photoBrowser)!, animated: true, completion: nil)
    }
    
    func moveToNextPageTop() {
        let x = self.vwScrollImg.bounds.origin.x
        let width = self.vwScrollImg.contentSize.width
        if x+Screen.width == width{
            let point = CGPoint(x: 0, y: self.vwScrollImg.bounds.origin.y)
            self.vwScrollImg.setContentOffset(point, animated: false)
        }else{
            let point = CGPoint(x: x + Screen.width, y: self.vwScrollImg.bounds.origin.y)
            self.vwScrollImg.setContentOffset(point, animated: true)
        }
    }
    
    //MARK:- Manage Bottom Bar
    func setBottomBar() {
        self.vwBottom.isHidden = false
        if(objRoomDetail.review_count == "" || objRoomDetail.review_count == "0"){
            lblReviewCount.text = ""
            lblReviewStar.isHidden = true
        }else{
            lblReviewCount.text = String(format:(objRoomDetail.review_count == "1") ? "%@ " + review : "%@ " + reviews, objRoomDetail.review_count)
            lblReviewStar.isHidden = false
            lblReviewStar.text = createRatingStar(ratingValue: objRoomDetail.rating_value)
        }
        
        let objUser = getUserDetails()
        if(objUser?.user_id == objRoomDetail.host_user_id) {
            btnBook.isHidden = true
        }else{
            btnBook.setTitle((multipleDates.count > 0) ? requestToBook : checkAvailability, for: UIControlState.normal)
            if objRoomDetail.instant_book == "Yes" {
                btnBook.setTitle(instanceBook, for: UIControlState.normal)
            }
        }
        
        let symbol = GETVALUE(USER_CURRENCY_SYMBOL)
        lblPriceDetail.attributedText = getBigAndNormalString(originalText: String(format: "%@ %@ per night",symbol, objRoomDetail.room_price as String) as NSString, normalText: perNight as NSString, attributeText: objRoomDetail.room_price as NSString, font: (lblPriceDetail?.font)!)
    }
    
    //MARK:- Set MapView
    func setMapInfo(){
        lblMapTitle.text = self.objRoomDetail.locaiton_name as String
        lblMapTitle?.layer.shadowColor = UIColor.black.cgColor
        lblMapTitle?.layer.shadowOffset = CGSize(width:0, height:1.0)
        lblMapTitle?.layer.shadowOpacity = 0.5
        lblMapTitle?.layer.shadowRadius = 1.0
        lblMapTitle?.layer.cornerRadius = 5
        lblMapTitle?.clipsToBounds = true
        
        let Width = 640
        let Height = 620
        
        let mapImageUrl = "https://maps.googleapis.com/maps/api/staticmap?center="
        let latlong = String(format:"%@ , %@",self.objRoomDetail.loc_latidude,self.objRoomDetail.loc_longidude)
        let mapUrl  = mapImageUrl + latlong
        
        let size = "&size=" +  "\(Int(Width))" + "x" +  "\(Int(Height))"
        let positionOnMap = "&markers=size:mid|color:red|" + latlong + "&zoom=5"
        let staticImageUrl = mapUrl + size + positionOnMap
        
        if let urlStr = staticImageUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! as NSString? {
            imgMap.sd_setImage(with: NSURL(string: urlStr as String) as? URL, placeholderImage:UIImage(named:""))
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == VW_scr){
            let y = -scrollView.contentOffset.y as CGFloat
            if (y > 0){
            }else {
                let offsetY = scrollView.contentOffset.y as CGFloat
                //                let alpha = min(1, 1 - ((15 + 150 - offsetY) / 84))
                if (offsetY > 230) {
                    vwTop.backgroundColor = UIColor.white
                    vwTop.layer.shadowColor = UIColor.lightGray.cgColor
                    btnBack.titleLabel?.textColor = UIColor.gray
                    btnShare.titleLabel?.textColor = UIColor.gray
                    if(objRoomDetail.is_whishlist == "Yes"){
                        btnLike.setTitle("C", for: .normal)
                        btnLike.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
                    }else{
                        btnLike.titleLabel?.textColor = UIColor.gray
                    }
                } else  {
                    vwTop.backgroundColor = UIColor.clear
                    vwTop.layer.shadowColor = UIColor.clear.cgColor
                    btnBack.titleLabel?.textColor = UIColor.white
                    btnShare.titleLabel?.textColor = UIColor.white
                    if(objRoomDetail.is_whishlist == "Yes"){
                        btnLike.setTitle("C", for: .normal)
                        btnLike.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
                    }else{
                        btnLike.titleLabel?.textColor = UIColor.white
                    }
                }
            }
        }
    }
    
    
    //MARK: Table View methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOptions.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.lblTitle.text = self.arrOption[indexPath.row]
        cell.imgOptions.isHidden = false
        cell.lblRightTitle.isHidden = true
        return cell
    }
    
    //MARK: Perform all navigation from the options
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = self.arrOption[indexPath.row]
        if(option == flexiblePolicy) {
            self.showPolicy()
        }else if(option == additionalPrice) {
            self.showAdditionalPrice()
        }else if(option == checkAvailability) {
            self.showCalander()
        }else if(option == contactToHost) {
            self.showContactHost()
        }
    }
    
    //MARK:- Collection view for Wishlist and Explore list
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objRoomDetail.similar_list_details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Explore_CVC", for: indexPath) as! Explore_CVC
        let objExplore = self.objRoomDetail.similar_list_details[indexPath.row]
        
        let detail = objExplore.currency_symbol + " " + objExplore.room_price + " " + objExplore.room_name
        let textChange = objExplore.currency_symbol + " " + objExplore.room_price
        
        let attributedStr = attributedTextboldText(detail as NSString, boldText: textChange, fontSize: 18)
        cell.lbl_Master_Detail.attributedText = attributedStr
        cell.Main_Img.sd_setImage(with: URL(string: objExplore.room_thumb_image)!, placeholderImage:UIImage(named:""))
        cell.LoveBtn.tag = indexPath.row
        cell.LoveBtn.addTarget(self, action: #selector(btnWishlistClicked), for: .touchUpInside)
        if(objExplore.is_whishlist == "Yes"){
            cell.LoveBtn.setImage(#imageLiteral(resourceName: "heart_selected"), for: .normal)
        }else{
            cell.LoveBtn.setImage(#imageLiteral(resourceName: "heart_normal"), for: .normal)
        }
        let reviewCount = Int(objExplore.reviews_value)
        if(reviewCount! > 0) {
            cell.vwRatingConstant.constant = 30
            cell.lblRating.text = createRatingStar(ratingValue: objExplore.rating_value)
            cell.lbl_Review.text = String(format:(objExplore.reviews_value == "1") ? "%@ " + review : "%@ " + reviews, objRoomDetail.review_count)
        }else {
            cell.vwRatingConstant.constant = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeVC = ProductDetail_VC(nibName: "ProductDetail_VC", bundle: nil)
        homeVC.roomId = self.objRoomDetail.similar_list_details[indexPath.row].room_id
        homeVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 282)
    }
    
    //MARK:- Outlet Actions
    
    @IBAction func btnOtherAmenitiesClicked(_ sender: Any) {
        if objRoomDetail.amenitiesList.count  > 0 {
            let amenityVC = RoomAmenitiesVC(nibName: "RoomAmenitiesVC", bundle: nil)
            amenityVC.amenityList = objRoomDetail.amenitiesList
            present(amenityVC, animated: true, completion: {})
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.topTimer.invalidate()
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShareClicked(_ sender: Any) {
        if objRoomDetail.room_share_url != "" {
            let activityViewController = UIActivityViewController(activityItems: [self.getDefaultShareContent()], applicationActivities: nil)
            present(activityViewController, animated: true, completion: {})
        }
    }
    
    @IBAction func btnLikeClicked(_ sender: Any) {
        if(self.objRoomDetail.room_id != "0" || self.objRoomDetail.room_id != "") {
            self.isMainRoomSelected = true
            if(objRoomDetail.is_whishlist == "Yes") {
                removeFromWishList()
            }else{
                let count = (appDelegate?.arrWishList.count)!
                if(count > 0){
                    let vc = AddWishlistVC(nibName: "AddWishlistVC", bundle: nil)
                    vc.strRoomId = objRoomDetail.room_id
                    vc.strRoomName = objRoomDetail.room_name
                    vc.view.backgroundColor = UIColor.clear
                    vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }else{
                    //Create new wishlist
                    let createVc = AddWishListItemVC(nibName: "AddWishListItemVC", bundle: nil)
                    createVc.roomName = objRoomDetail.room_name
                    createVc.roomId = objRoomDetail.room_id
                    self.present(UINavigationController(rootViewController: createVc), animated: true, completion: {})
                }
            }
        }
    }
    
    func btnWishlistClicked(_ sender: UIButton) {
        self.selectedIndex = sender.tag
        self.isMainRoomSelected = false
        let objRoom = self.objRoomDetail.similar_list_details[self.selectedIndex]
        if(objRoom.is_whishlist == "Yes"){
            self.removeFromWishList()
        }else{
            let count = (appDelegate?.arrWishList.count)!
            if(count > 0){
                let vc = AddWishlistVC(nibName: "AddWishlistVC", bundle: nil)
                vc.strRoomId = objRoom.room_id
                vc.strRoomName = objRoom.room_name
                vc.view.backgroundColor = UIColor.clear
                vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                self.present(vc, animated: false, completion: nil)
            }else{
                //Create new wishlist
                let createVc = AddWishListItemVC(nibName: "AddWishListItemVC", bundle: nil)
                createVc.roomName = objRoom.room_name
                createVc.roomId = objRoom.room_id
                self.present(UINavigationController(rootViewController: createVc), animated: true, completion: {})
            }
        }
    }
    
    
    @IBAction func btnReviewClicked(_ sender: Any) {
        let reviewVC = ReviewDetailVC(nibName: "ReviewDetailVC", bundle: nil)
        reviewVC.roomId = objRoomDetail.room_id
        self.present(reviewVC, animated: true, completion: nil)
    }
    
    @IBAction func btnProfileClicked(_ sender: Any) {
        if(objRoomDetail.host_user_id != ""){
            let profileVc = ProfileDetailVC(nibName: "ProfileDetailVC", bundle: nil)
            profileVc.otherUserId = objRoomDetail.host_user_id
            self.navigationController?.pushViewController(profileVc, animated: true)
        }
    }
    
    @IBAction func btnAboutDetailClicked(_ sender: Any) {
        let houseRulesVC = HouseRulesVC(nibName: "HouseRulesVC", bundle: nil)
        houseRulesVC.isFromRoomDetails = true
        houseRulesVC.isFromRoomAboutHome = true
        houseRulesVC.strHouseRules = objRoomDetail.room_detail
        houseRulesVC.strHostUserName = aboutHome
        present(houseRulesVC, animated: true, completion: nil)
    }
    
    @IBAction func btnBookClicked(_ sender: Any) {
        if (multipleDates.count > 0 || btnBook?.titleLabel?.text == requestToBook)
        {
            
            self.gotoBookPage()
        }
        else if btnBook?.titleLabel?.text == checkAvailability || btnBook?.titleLabel?.text == instanceBook
        {
            self.showCalander()
        }
    }
    
    //MARK: - Go To Book Page
    func gotoBookPage()
    {
        let contactView = BookingVC(nibName: "BookingVC", bundle: nil)
        contactView.strAboutHome = objRoomDetail.room_detail as String
        contactView.strStartDate = strCheckInDate
        contactView.strEndDate = strCheckOutDate
        contactView.strInstantBook = objRoomDetail.instant_book as String
        contactView.strRoomID = objRoomDetail.room_id as String
        contactView.strTotalGuest = "1"
        contactView.strLocationName = objRoomDetail.locaiton_name as String
        contactView.multipleDates = multipleDates
        contactView.house_rules = objRoomDetail.house_rules as String
        contactView.strRoomName = objRoomDetail.room_name as String
        contactView.strHostUserId = objRoomDetail.host_user_id as String
        
        if objRoomDetail.blocked_dates != nil
        {
            if objRoomDetail.blocked_dates.count > 0
            {
                contactView.arrBlockedDates = objRoomDetail.blocked_dates as! NSMutableArray
            }
        }
        
        contactView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(contactView, animated: true)
        
    }
    
    //MARK:- API call get room details
    func getRoomDetail() {
        self.isLoading = true
        let params = NSMutableDictionary()
        params.setValue(self.roomId, forKey: "room_id")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_ROOM_DETAIL, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil) {
                    showToastMessage(error!)
                }else{
                    let resDic = response as! NSDictionary
                    self.isLoading = false
                    self.manageView()
                    self.objRoomDetail = RoomDetailModel().initiateRoomData(res: resDic)
                    self.setDetails()
                    self.isLoading = false
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    //MARK: - Notification Method
    func addedWishList(notification:Notification){
        if(self.isMainRoomSelected){
            self.isMainRoomSelected = false
            self.objRoomDetail.is_whishlist = "Yes"
            self.btnLike.setTitle("C", for: .normal)
            self.btnLike.setTitleColor(UIColor(red: 255.0 / 255.0, green: 114.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0), for: .normal)
        }else{
            self.objRoomDetail.similar_list_details[self.selectedIndex].is_whishlist = "Yes"
            let indexPath = IndexPath(row: self.selectedIndex, section: 0)
            self.cvcRooms.reloadItems(at: [indexPath])
        }
    }
    
    // MARK:-  Custom Method(s)
    
    func getDefaultShareContent() -> String {
        let shareContent = String(format:"Check out this awesome House on Makent: %@\n%@",objRoomDetail.room_name,objRoomDetail.room_share_url)
        return shareContent
    }
    
    func showPolicy() {
        let objLoadWebView = LoadWebView(nibName: "LoadWebView", bundle: nil)
        objLoadWebView.hidesBottomBarWhenPushed = true
        objLoadWebView.strPageTitle = cancelationPolicy
        //        objLoadWebView.strWebUrl = webServerUrl + URL_TERMS_OF_SERVICE
        objLoadWebView.strCancellationFlexible = (objRoomDetail.cancellation_policy == "Flexible") ? CACELATION_POLICY_FLEXIBLE : (objRoomDetail.cancellation_policy == "Moderate") ? CACELATION_POLICY_MODERATE : CACELATION_POLICY_STRICT
        self.navigationController?.pushViewController(objLoadWebView, animated: true)
    }
    
    func showCalander() {
        let vc =  WWCalendarTimeSelector(nibName: "WWCalendarTimeSelector", bundle: nil)
        vc.room_Id = objRoomDetail.room_id
        vc.callAPI = true
        vc.delegate = self
        vc.optionCurrentDate = singleDate
        vc.optionCurrentDates = Set(multipleDates)
        if objRoomDetail.blocked_dates != nil {
            if objRoomDetail.blocked_dates.count > 0 {
                vc.arrBlockedDates = objRoomDetail.blocked_dates as! NSMutableArray
            }
        }
        vc.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        vc.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
        vc.optionSelectionType = WWCalendarTimeSelectorSelection.range
        present(vc, animated: true, completion: nil)
    }
    
    func showContactHost() {
        let vc = ContactHostVC(nibName: "ContactHostVC", bundle: nil)
        vc.strRoomType = objRoomDetail.room_type as String
        vc.strHostUserName = objRoomDetail.host_user_name as String
        vc.strHostThumbUrl = objRoomDetail.host_user_image as String
        vc.strHostUserId = objRoomDetail.host_user_id as String
        vc.modelRoomDetails = objRoomDetail
        vc.strTotalGuest = objRoomDetail.no_of_guest as String
        vc.strRoomId = objRoomDetail.room_id as String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAdditionalPrice() {
        let vc = TravelAdditionalPriceVC(nibName: "TravelAdditionalPriceVC", bundle: nil)
        let currencySymbol = (objRoomDetail.currency_symbol as String).stringByDecodingHTMLEntities
        let strAdditionalGuest = String(format:"%@ %@",currencySymbol,objRoomDetail.additional_guest)
        let strweekly_price = String(format:"%@ %@",currencySymbol,objRoomDetail.weekly_price)
        let strmonthly_price = String(format:"%@ %@",currencySymbol,objRoomDetail.monthly_price)
        let strsecurity_deposit = String(format:"%@ %@",currencySymbol,objRoomDetail.security)
        let strcleaning_fee = String(format:"%@ %@",currencySymbol,objRoomDetail.cleaning_fee)
        var arrTemp = [String]()
        var arrTempTitle = [String]()
        if objRoomDetail.additional_guest != "0" && objRoomDetail.additional_guest != "" {
            arrTemp.append(strAdditionalGuest)
            arrTempTitle.append(extraPeople)
        }
        if objRoomDetail.weekly_price != "0" && objRoomDetail.weekly_price != "" {
            arrTemp.append(strweekly_price)
            arrTempTitle.append(weeklyPrice)
        }
        if objRoomDetail.monthly_price != "0" && objRoomDetail.monthly_price != "" {
            arrTemp.append(strmonthly_price)
            arrTempTitle.append(monthlyPrice)
        }
        if objRoomDetail.security != "0" && objRoomDetail.security != "" {
            arrTemp.append(strsecurity_deposit)
            arrTempTitle.append(securityDeposit)
        }
        if objRoomDetail.cleaning_fee != "0" && objRoomDetail.cleaning_fee != "" {
            arrTemp.append(strcleaning_fee)
            arrTempTitle.append(cleaningFree)
        }
        vc.arrSpecialPrices = arrTempTitle
        vc.arrPrices = arrTemp
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    internal func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date])
    {
        multipleDates = dates
        //        self.btnBookRoom?.setTitle(“”, for: UIControlState.normal)
        let formalDates = dates
        let startDay = formalDates[0]
        //        let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
        let lastDay = formalDates.last
        //        let last = Calendar.current.date(byAdding: .day, value: 1, to: lastDay!)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd-MM-yyy"
        
        strCheckInDate = dateFormatter.string(from: startDay)
        strCheckOutDate = dateFormatter.string(from: lastDay!)
        
        if objRoomDetail.instant_book == "Yes"
        {
             self.gotoBookPage()
        }
        else
        {
             self.btnBook?.setTitle(requestToBook, for: UIControlState.normal)
        }
    }
    
    //MARK:- API call add in Existing whishlist details
    func removeFromWishList() {
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        var roomId = ""
        if(isMainRoomSelected){
            roomId = objRoomDetail.room_id
        }else{
            roomId = self.objRoomDetail.similar_list_details[self.selectedIndex].room_id
        }
        params.setValue(roomId, forKey: "room_id")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_DELETE_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(response != nil){
                        if(self.isMainRoomSelected){
                            self.isMainRoomSelected = false
                            self.objRoomDetail.is_whishlist = "No"
                            self.btnLike.setTitle("B", for: .normal)
                            self.btnLike.setTitleColor(UIColor.white, for: .normal)
                        }else{
                            self.objRoomDetail.similar_list_details[self.selectedIndex].is_whishlist = "No"
                            let indexPath = IndexPath(row: self.selectedIndex, section: 0)
                            self.cvcRooms.reloadItems(at: [indexPath])
                        }
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
    
    //MARK:- API call get whishlist details
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
                    }
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
    
}
