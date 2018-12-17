
import UIKit

class ExploreVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UIScrollViewDelegate, WWCalendarTimeSelectorProtocol, AddGuestDelegate , AddressPickerDelegate, ApplyFilterDelegate {
    
    @IBOutlet var VW_Top_3: UIView!
    @IBOutlet var VW_Map_Filter: UIView!
    @IBOutlet var CV_Explore: UICollectionView!
    @IBOutlet var vwFilterNMap: UIView!
    @IBOutlet var btnTopSearchTitle: UIButton!
    @IBOutlet var lblNoOfFilterCount: UILabel!
    @IBOutlet var lblFilterImg: UILabel!
    
    var arrExplore = [ExploreModel]()
    var selectedIndex = 0
    var totalPages = 0
    var minPrice = 0
    var maxPrice = 0
    var pageNo = 1
    var noOfFilter = 0
    var isFilterApplied = false
    var indexpath = IndexPath(row: 0, section: 0)
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    var strStartDate : String = ""
    var strEndDate : String = ""
    var strTotalGuest : String = "1"
    var stradult: String = "1"
    var strchild: String = "0"
    var isLogin = false
    static var isWishListCreated = false
    static var isCurrencyChange = false
    var isLoading = false
    var isEmpty = false
    var strLatitude : String = ""
    var strLocationName : String = ""
    var strFullLocName : String = ""
    var strLongitude : String = ""
    var strSearchedLocName : String = ""
    var dictSearch = NSMutableDictionary()
    var dictFilter = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let phoneVC = PhoneNumberVC(nibName: "PhoneNumberVC", bundle: nil)
//        phoneVC.isVerification = true
//        phoneVC.isSkip = true
//        self.navigationController?.pushViewController(phoneVC, animated: true)
        self.setMainPage()
        NotificationCenter.default.addObserver(self, selector: #selector(self.addedWishList(notification:)), name: NSNotification.Name(rawValue: NotificationName.addWishlist), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(ExploreVC.isCurrencyChange) {
            self.registerCell()
            self.viewcustomization()
            self.isLogin = true
            self.arrExplore.removeAll()
            self.pageNo = 1
            self.CV_Explore.reloadData()
            self.getExplore(dicts: NSMutableDictionary())
            ExploreVC.isCurrencyChange = false
        }else{
            if(!isLogin && UserDefaults.standard.bool(forKey: UserDefaultKey.kLoggedIn)) {
                self.registerCell()
                self.viewcustomization()
                self.getWhishList()
                self.getExplore(dicts: NSMutableDictionary())
                self.isLogin = true
            }
            if(ExploreVC.isWishListCreated) {
                pageNo = 1
                self.getExplore(dicts: NSMutableDictionary())
                self.getWhishList()
                ExploreVC.isWishListCreated = false
            }
        }
        
    }
    
    //MARK:- Set the initial view
    func setMainPage() {
        if(!UserDefaults.standard.bool(forKey: UserDefaultKey.kLoggedIn)) {
            let vc = Main(nibName: "Main", bundle: nil)
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }else{
            self.isLogin = true
            self.registerCell()
            self.viewcustomization()
            self.getWhishList()
            self.getExplore(dicts: NSMutableDictionary())
        }
    }
    
    //MARK:- Register cell
    func registerCell(){
        CV_Explore.register(UINib(nibName: "Explore_CVC", bundle: nil), forCellWithReuseIdentifier: "Explore_CVC")
        CV_Explore.register(UINib(nibName: "Explore_First_CVC", bundle: nil), forCellWithReuseIdentifier:   "Explore_First_CVC")
        CV_Explore.register(UINib(nibName: "Filter_CVC", bundle: nil), forCellWithReuseIdentifier:   "Filter_CVC")
        CV_Explore.register(UINib(nibName: "LoaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:   "LoaderCollectionViewCell")
        
        CV_Explore.dataSource = self
        CV_Explore.delegate = self
    }
    
    //MARK: Here Customize the view
    func viewcustomization() {
        self.navigationController?.isNavigationBarHidden = true
        VW_Map_Filter.layer.cornerRadius = 20
        VW_Map_Filter.layer.shadowColor = UIColor.gray.cgColor
        VW_Map_Filter.layer.shadowOffset = CGSize(width:0, height:1.0)
        VW_Map_Filter.layer.shadowOpacity = 0.5
        VW_Map_Filter.layer.shadowRadius = 2.0
        self.setSearchTitle()
        self.setFilterView()
    }
    
    //MARK: - Notification Method
    func addedWishList(notification:Notification) {
        if(self.arrExplore.count > 0){
            self.arrExplore[self.selectedIndex].is_wishlist = "Yes"
            let indexPath = IndexPath(row: self.selectedIndex + 1, section: 0)
            self.CV_Explore.reloadItems(at: [indexPath])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y as CGFloat;
        if (y > 0){
        }else {
            let offsetY = scrollView.contentOffset.y as CGFloat;
            let alpha = min(1, 1 - ((15 + 150 - offsetY) / 84))
            if (offsetY > 100)
            {
                VW_Top_3.alpha = alpha
            } else  {
                VW_Top_3.alpha = alpha
            }
        }
    }
    
    func setSearchTitle(){
        let title = anywhere + " · " + anytime + " · \(self.strTotalGuest) " + guest
        self.btnTopSearchTitle.setTitle(title, for: .normal)
    }
    
    func setFilterView() {
        if(self.noOfFilter == 0){
            self.lblFilterImg.isHidden = false
            self.lblNoOfFilterCount.isHidden = true
        }else{
            self.lblFilterImg.isHidden = true
            self.lblNoOfFilterCount.text = String(self.noOfFilter)
            self.lblNoOfFilterCount.isHidden = false
        }
    }
    
    //MARK:- Expand the top view
    @IBAction func btnTopSearchClicked(_ sender: Any) {
        self.CV_Explore.contentOffset = CGPoint(x: self.CV_Explore.contentOffset.x, y: 0.0)
//        let indexPath = IndexPath(row:0, section: 0)
//        self.CV_Explore.reloadItems(at: [indexPath])
    }
    
    
    //MARK:- Collection view for Wishlist and Explore list
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isEmpty == true){
            return 2
        }else if(isLoading){
            return self.arrExplore.count + 2
        }
        return self.arrExplore.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            indexpath = indexPath
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Explore_First_CVC", for: indexPath) as! Explore_First_CVC
            if(self.isFilterApplied){
                cell.btnClearAll.isHidden = false
            }else{
                cell.btnClearAll.isHidden = true
            }
            cell.Btn_close.addTarget(self, action: #selector(btnCloseAddWishList), for: .touchUpInside)
            cell.btnAnywhere.addTarget(self, action: #selector(btnAnywhereClicked), for: .touchUpInside)
            cell.btnAnyTime.addTarget(self, action: #selector(btnAnyTimeClicked), for: .touchUpInside)
            cell.btnClearAll.addTarget(self, action: #selector(btnClearAllClicked), for: .touchUpInside)
            cell.btnGuest.addTarget(self, action: #selector(btnGuestSelection), for: .touchUpInside)
            return cell
        }
        
        if(isEmpty == true){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Filter_CVC", for: indexPath) as! Filter_CVC
            if(self.isFilterApplied){
                cell.lblCantList.text = noDataAfterFilter
                cell.btnRemoveFilter.isHidden = false
                cell.btnRemoveFilter.addTarget(self, action: #selector(btnRemoveFilterClicked), for: .touchUpInside)
            }else{
                cell.lblCantList.text = noExploreData
                cell.btnRemoveFilter.isHidden = true
            }
            return cell
        }else if(isLoading && self.arrExplore.count+1 == indexPath.row) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoaderCollectionViewCell", for: indexPath) as! LoaderCollectionViewCell
            return cell
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Explore_CVC", for: indexPath) as! Explore_CVC
            let objExplore = arrExplore[indexPath.row - 1]
            
            let detail = objExplore.currency_symbol + " " + objExplore.room_price + " " + objExplore.room_type
            let textChange = objExplore.currency_symbol + " " + objExplore.room_price
            
            let attributedStr = attributedTextboldText(detail as NSString, boldText: textChange, fontSize: 18)
            cell.lbl_Master_Detail.attributedText = attributedStr
            cell.Main_Img.sd_setImage(with: URL(string: objExplore.room_thumb_image)!, placeholderImage:UIImage(named:""))
            cell.LoveBtn.tag = indexPath.row - 1
            cell.LoveBtn.addTarget(self, action: #selector(btnWishlistClicked), for: .touchUpInside)
            if(objExplore.is_wishlist == "Yes"){
                cell.LoveBtn.setImage(#imageLiteral(resourceName: "heart_selected"), for: .normal)
            }else{
                cell.LoveBtn.setImage(#imageLiteral(resourceName: "heart_normal"), for: .normal)
            }
            
            let reviewCount = Int(objExplore.reviews_count)
            if(reviewCount! > 0){
                cell.vwRatingConstant.constant = 30
                cell.lblRating.text = createRatingStar(ratingValue: objExplore.rating_value)
                cell.lbl_Review.text = objExplore.reviews_count + " " + review
                
            }else{
                cell.vwRatingConstant.constant = 0
            }
            
            if(indexPath.row == self.arrExplore.count-1){
                if(self.pageNo != self.totalPages){
                    self.pageNo = self.pageNo + 1
                    self.getExplore(dicts: NSMutableDictionary())
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row - 1
        let homeVC = ProductDetail_VC(nibName: "ProductDetail_VC", bundle: nil)
        if(self.arrExplore.count > 0 && self.arrExplore.count >= self.selectedIndex) {
            homeVC.roomId = self.arrExplore[indexPath.row - 1].room_id
            homeVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 220)
        }else if(isLoading && self.arrExplore.count+1 == indexPath.row) {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 80)
        }
        
        var height = UIScreen.main.bounds.size.width * 0.8
        if(self.arrExplore.count > 0) {
            if let reviews_count = Int(arrExplore[indexPath.row - 1].reviews_count){
                if(reviews_count > 0){
                    height = height + 35
                }
            }
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: height)
    }
    
    //MARK:- Handle Header Buttons
    func btnCloseAddWishList(sender: UIButton!) {
        UIView.animate(withDuration: 0.2) {
            self.CV_Explore.setContentOffset(CGPoint(x: 0,y :160), animated: true)
            self.VW_Top_3.alpha = 1.0
        }
    }
    
    func btnGuestSelection(sender: UIButton!) {
        let viewGuest = GuestVC(nibName: "GuestVC", bundle: nil)
        viewGuest.nCurrentGuest = Int(strTotalGuest)!
        viewGuest.adults = Int(stradult)!
        viewGuest.child = Int(strchild)!
        viewGuest.delegate = self
        self.present(viewGuest, animated: true, completion: {})
    }
    
    func btnAnywhereClicked(sender: UIButton!) {
        let viewWhereTo = SearchVC(nibName: "SearchVC", bundle: nil)
        viewWhereTo.strSearchLoc = strSearchedLocName
        viewWhereTo.delegate = self
        self.present(viewWhereTo, animated: true, completion: {})
    }
    
    func btnAnyTimeClicked(sender: UIButton!) {
        let selector = WWCalendarTimeSelector(nibName: "WWCalendarTimeSelector", bundle: nil)
        selector.isFromExplorePage = true
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates)
        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
        selector.hidesBottomBarWhenPushed = true
        selector.optionSelectionType = WWCalendarTimeSelectorSelection.range
        self.navigationController?.pushViewController(selector, animated: false)
    }
    
    func btnRemoveFilterClicked(sender: UIButton!){
        self.removeFilter()
    }
    
    func btnClearAllClicked(sender: UIButton!) {
        UIView.animate(withDuration: 0.2) {
            self.CV_Explore.setContentOffset(CGPoint(x: 0,y :160), animated: true)
            self.VW_Top_3.alpha = 1.0
        }
        self.removeFilter()
    }
    
    func btnWishlistClicked(sender: UIButton!) {
        self.selectedIndex = sender.tag
        if(self.arrExplore[selectedIndex].is_wishlist == "Yes") {
            //Delete from the saved list
            self.removeFromWishList()
        }else{
            let count = (appDelegate?.arrWishList.count)!
            if(count > 0){
                let vc = AddWishlistVC(nibName: "AddWishlistVC", bundle: nil)
                vc.strRoomId = arrExplore[self.selectedIndex].room_id
                vc.strRoomName = arrExplore[self.selectedIndex].room_name
                vc.view.backgroundColor = UIColor.clear
                vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                self.present(vc, animated: false, completion: nil)
            }else{
                //Create new wishlist
                let createVc = AddWishListItemVC(nibName: "AddWishListItemVC", bundle: nil)
                createVc.roomName = arrExplore[self.selectedIndex].room_name
                createVc.roomId = arrExplore[self.selectedIndex].room_id
                self.present(UINavigationController(rootViewController: createVc), animated: true, completion: {})
            }
        }
    }
    
    //MARK:- Filter button clicked
    @IBAction func btnFilterClicked(_ sender: Any) {
        let filterVC = FilterVC(nibName: "FilterVC", bundle: nil)
        filterVC.delegate = self
        filterVC.dictParams = self.dictFilter
        filterVC.noOfFilterApplied = self.noOfFilter
        self.present(UINavigationController(rootViewController: filterVC), animated: true, completion: {})
    }
    
    //MARK:- Filter button clicked
    @IBAction func btnMapClicked(_ sender: Any) {
        let mapRoomVC = MapRoomVC(nibName: "MapRoomVC", bundle: nil)
        mapRoomVC.arrExploreData = self.arrExplore
        mapRoomVC.delegate = self
        mapRoomVC.dictParams = self.dictFilter
        mapRoomVC.noOfFilterApplied = self.noOfFilter
        self.present(mapRoomVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Remove filter - clear all
    func removeFilter() {
        isFilterApplied = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            let cell = self.CV_Explore!.cellForItem(at: self.indexpath) as! Explore_First_CVC
            cell.btnAnywhere.setTitle(anywhere, for: UIControlState.normal)
            cell.btnAnyTime.setTitle(anytime, for: UIControlState.normal)
            cell.btnGuest.setTitle("1 " + guest, for: UIControlState.normal)
            self.isEmpty = false
            self.strTotalGuest = "1"
            self.stradult = "1"
            self.strchild = "0"
            self.strSearchedLocName = ""
            self.multipleDates = []
            self.pageNo = 1
            self.setSearchTitle()
            self.dictFilter.removeAllObjects()
            self.dictSearch.removeAllObjects()
            self.noOfFilter = 0
            self.setFilterView()
            self.arrExplore.removeAll()
            self.CV_Explore.reloadData()
            self.getExplore(dicts: NSMutableDictionary())
        }
    }
    
    //MARK:- API call
    func getExplore(dicts:NSMutableDictionary){
        self.isLoading = true
        if(pageNo == 1){
            self.arrExplore.removeAll()
            self.CV_Explore.reloadData()
        }
        self.VW_Map_Filter.isHidden = true
        let params = dicts
        params.setValue(self.pageNo, forKey: "page")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_EXPLORE, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    if(error! == "No Data Found"){
                        self.isEmpty = true
                        self.CV_Explore.reloadData()
                    }else{
                        showToastMessage(error!)
                    }
                }else {
                    if(response != nil) {
                        let resDic = response as! NSDictionary
                        self.isEmpty = false
                        let dicRes = resDic.value(forKey: "data") as! NSArray
                        let exploreList = ExploreModel().initiateExploreData(arrRes: dicRes)
                        self.arrExplore.append(contentsOf: exploreList)
                        if let pages = resDic.value(forKey: "total_page"){
                            self.totalPages = pages as! Int
                        }
                        if let min_price = resDic.value(forKey: "min_price"){
                            self.minPrice = min_price as! Int
                            appDelegate?.mimimumPrice = min_price as! Int
                        }
                        if let max_price = resDic.value(forKey: "max_price"){
                            self.maxPrice = max_price as! Int
                            appDelegate?.maximumPrice = max_price as! Int
                        }
                        self.CV_Explore.reloadData()
                        self.VW_Map_Filter.isHidden = false
                    }
                }
                self.isLoading = false
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    //MARK:- API call get whishlist details
    func getWhishList() {
        let params = NSMutableDictionary()
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_GET_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    //                    showToastMessage(error!)
                }else{
                    if(response != nil) {
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
    
    //MARK:- API call add in Existing whishlist details
    func removeFromWishList() {
        ProgressHud.shared.Animation = true
        let roomId = self.arrExplore[self.selectedIndex].room_id
        let params = NSMutableDictionary()
        params.setValue(roomId, forKey: "room_id")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_DELETE_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(response != nil){
                        self.arrExplore[self.selectedIndex].is_wishlist = "No"
                        let indexPath = IndexPath(row: self.selectedIndex + 1, section: 0)
                        self.CV_Explore.reloadItems(at: [indexPath])
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
    
    //MARK:- create a filter parameter
    func filterSearch() {
        isFilterApplied = true
        dictSearch = NSMutableDictionary()
        if strFullLocName != "" {
            dictSearch["location"] = strFullLocName
        }
        dictSearch["guests"] = strTotalGuest
        if strStartDate != "" && strStartDate != ""
        {
            dictSearch["checkin"]  = strStartDate
            dictSearch["checkout"] = strEndDate
        }
        
        let dictTotalParams : NSMutableDictionary = NSMutableDictionary(dictionary:dictSearch)
        if dictFilter.count > 0
        {
            dictTotalParams.addEntries(from: dictFilter as! [AnyHashable : Any])
        }
        self.pageNo = 1
        self.getExplore(dicts: dictTotalParams)
        
    }
    // MARK:- WWCalendar Delegate Method(s)
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        multipleDates = dates
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.multipleDates = dates
            let formalDates = dates
            let startDay = formalDates[0]
            let lastDay = formalDates.last
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateFormat = "dd-MM-yyy"
            if formalDates.count==1 {
                let start = Calendar.current.date(byAdding: .day, value: 1, to: startDay)
                self.strEndDate = dateFormatter.string(from: (start)!)
            } else {
                self.strEndDate = dateFormatter.string(from: lastDay!)
            }
            self.strStartDate = dateFormatter.string(from: startDay)
            let cell = self.CV_Explore!.cellForItem(at: self.indexpath) as! Explore_First_CVC
            cell.btnAnyTime.setTitle((self.strEndDate == "") ? anytime : String(format:"%@ - %@",self.strStartDate,self.strEndDate), for: UIControlState.normal)
            self.pageNo = 1
            self.filterSearch()
        }
    }
    
    func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        /*
         appDelegate.makentTabBarCtrler.hidesBottomBarWhenPushed = false
         appDelegate.makentTabBarCtrler.view.isHidden = false
         */
    }
    
    //MARK:- Delegate method
    func onGuestAdded(adults:Int,child:Int) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.strTotalGuest = String(format: "%d",adults+child)
            self.stradult = String(adults)
            self.strchild = String(child)
    
            self.setSearchTitle()
            let cell = self.CV_Explore!.cellForItem(at: self.indexpath) as! Explore_First_CVC
            if(self.strchild != "0"){
            cell.btnGuest.setTitle((self.strTotalGuest == "1") ? "1 " + guest : String(format:"%@-adults %@-children",self.stradult,self.strchild), for: UIControlState.normal)
            }else{
               cell.btnGuest.setTitle((self.strTotalGuest == "1") ? "1 " + guest : String(format:"%@-adults",self.stradult), for: UIControlState.normal)
            }
            self.pageNo = 1
            self.filterSearch()
        }
    }
    
    //MARK:- Filter applied delegate method
    func onFilterApply(dic: NSMutableDictionary, noOfFilterApplied: Int) {
        isFilterApplied = true
        self.pageNo = 1
        self.dictFilter = dic
        self.noOfFilter = noOfFilterApplied
        self.setFilterView()
        self.filterSearch()
    }
    
    func aaddressPickingDidFinish(_ searchedLocation: LocationModel, searchedString : String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if searchedString == "Anywhere" {
                self.strLatitude = ""
                self.strLongitude = ""
                self.strFullLocName = ""
                self.strSearchedLocName = searchedString
                self.isEmpty = false
            }else {
                self.strLocationName  = searchedString// (str.count>0) ? str[0] : ""
                self.strSearchedLocName = searchedLocation.searchedAddress
                self.strFullLocName = self.strSearchedLocName.replacingOccurrences(of: " ", with: "%20")
                let cell = self.CV_Explore!.cellForItem(at: self.indexpath) as! Explore_First_CVC
                cell.btnAnywhere.setTitle((self.strSearchedLocName == "") ? anywhere : String(format:"%@",self.strSearchedLocName), for: UIControlState.normal)
            }
            self.pageNo = 1
            self.filterSearch()
        }
    }
    
}

