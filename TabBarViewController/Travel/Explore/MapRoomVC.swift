//
//  MapRoomVC.swift
//  Arheb
//
//  Created by devloper65 on 6/5/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import MapKit

class MapRoomVC: UIViewController,MKMapViewDelegate,uploadDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwFilter: UIView!
    @IBOutlet weak var cvRoom:UICollectionView!
    @IBOutlet weak var heightMap:NSLayoutConstraint!
    
    var selectedIndex = 0
    var arrExploreData = [ExploreModel]()
    var arrWhishList = [WishListModel]()
    var currencySymbol = ""
    var point3 = MyCustomPointAnnotation()
    var nAnnotationSeletedIndex : Int = 0
    var currentIndex : Int = 0
    
    var delegate: ApplyFilterDelegate?
    var noOfFilterApplied = 0
    var dictParams = NSMutableDictionary()
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        registerCell()
        if arrExploreData.count>0{
            displayRegionIncomeLevel()
        }
        else{
            vwBottom.isHidden = true
            heightMap.constant = Screen.height
        }
        if arrExploreData.count>2
        {
            let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MapRoomVC.handleSwipeinRight))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            cvRoom.addGestureRecognizer(swipeRight)
            let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MapRoomVC.handleSwipeinLeft))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.left
            cvRoom.addGestureRecognizer(swipeLeft)
        }
        
        cvRoom.isScrollEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.addedWishList(notification:)), name: NSNotification.Name(rawValue: NotificationName.addWishlist), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(appDelegate?.isFromMap)!{
            appDelegate?.isFromMap = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewcustomization(){
        self.automaticallyAdjustsScrollViewInsets = false
        cvRoom.isPagingEnabled = true
        vwFilter.layer.cornerRadius = 17
        vwFilter.layer.shadowColor = UIColor.gray.cgColor
        vwFilter.layer.shadowOffset = CGSize(width:0, height:1.0)
        vwFilter.layer.shadowOpacity = 0.5
        vwFilter.layer.shadowRadius = 2.0
    }
    
    func registerCell(){
        cvRoom.register(UINib(nibName: "RoomCell", bundle: nil), forCellWithReuseIdentifier: "RoomCell")
    }
    
    @IBAction func Btn_Add_New_WhishList(_ sender: UIButton) {
        let createVc = AddWishListItemVC(nibName: "AddWishListItemVC", bundle: nil)
        createVc.roomName = arrExploreData[self.selectedIndex].room_name
        createVc.roomId = arrExploreData[self.selectedIndex].room_id
        self.present(UINavigationController(rootViewController: createVc), animated: true, completion: {})
    }
    
    //MARK: - Map Delegate Method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if(annotation is MKUserLocation){
            return nil
        }
        // We could display multiple types of point annotations
        if (annotation is MyCustomPointAnnotation) {
            let pin = MyCustomPinAnnotationView.init(annotation: annotation)
            pin?.upDelegate = self
            pin?.color = UIColor.black
            return pin
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        view.backgroundColor = UIColor.clear
        for annotation in mapView.annotations {
            let viewI = mapView.view(for: annotation) as? MyCustomPinAnnotationView
            
            if !(viewI?.annotation is MKUserLocation){
                if annotation.isEqual(selectedAnnotation) {
                    viewI?.image = UIImage(named: "map_price_sel.png")
                    viewI?.color = UIColor.white
                }else{
                    viewI?.image = UIImage(named: "map_price.png")
                    viewI?.color = UIColor.black
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "map_price_sel.png")!
    }
    
    //MARK: - Notification Method
    func addedWishList(notification:Notification){
        if(self.arrExploreData.count > 0){
            self.arrExploreData[self.selectedIndex].is_wishlist = "Yes"
            let indexPath = IndexPath(row: self.selectedIndex, section: 0)
            self.cvRoom.reloadItems(at: [indexPath])
        }
    }
    
    //MARK: - Gesture Method
    func handleSwipeinRight(recognizer: UISwipeGestureRecognizer)
    {
        if currentIndex == 0
        {
            return
        }
        if currentIndex == arrExploreData.count - 1
        {
            currentIndex = arrExploreData.count - 2
        }
        else
        {
            currentIndex = currentIndex - 1
        }
        
        cvRoom.isScrollEnabled = true
        let cellSize:Int = Int(Screen.width/2 - 20)
        let xOrigin = (cellSize + 10) * currentIndex
        cvRoom.setContentOffset(CGPoint(x: (xOrigin == 0) ? -15 : xOrigin, y :0), animated: true)
        cvRoom.isScrollEnabled = false
        uploadDidfinish(Int32(currentIndex))
    }
    
    func handleSwipeinLeft(recognizer: UISwipeGestureRecognizer)
    {
        if currentIndex >= arrExploreData.count - 1
        {
            if currentIndex == arrExploreData.count - 1
            {
                currentIndex = arrExploreData.count-1
                return
            }
            currentIndex = currentIndex + 1
            return
        }
        if currentIndex >= arrExploreData.count - 2
        {
            currentIndex = currentIndex + 1
        }
        else{
            currentIndex = currentIndex + 1
            cvRoom.isScrollEnabled = true
            let cellSize:Int = Int(Screen.width/2 - 20)
            let posX:CGFloat = CGFloat((currentIndex == 1) ? cellSize + 10 : (cellSize + 7) * currentIndex)
            cvRoom.setContentOffset(CGPoint(x: posX,y :0), animated: true)
            cvRoom.isScrollEnabled = false
        }
        uploadDidfinish(Int32(currentIndex))
    }
    
    
    //MARK: - Collectionview Delegate & Datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrExploreData.count>0 ? arrExploreData.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:RoomCell = cvRoom.dequeueReusableCell(withReuseIdentifier: "RoomCell", for: indexPath) as! RoomCell
        let modelData:ExploreModel = arrExploreData[indexPath.row]
        let detail = modelData.currency_symbol + " " + modelData.room_price + " " + modelData.room_type
        let textChange = modelData.currency_symbol + " " + modelData.room_price
        let attributedStr = attributedTextboldText(detail as NSString, boldText: textChange, fontSize: 14)
        cell.lblPrice.attributedText = attributedStr
        cell.imgRoom.sd_setImage(with: NSURL(string: modelData.room_thumb_image)! as URL, placeholderImage:UIImage(named:""))
        cell.btnLike.tag = indexPath.row
        if(modelData.is_wishlist == "Yes") {
            cell.btnLike.setImage(#imageLiteral(resourceName: "heart_selected"), for: .normal)
        }else{
            cell.btnLike.setImage(#imageLiteral(resourceName: "heart_normal"), for: .normal)
        }
        cell.btnLike.addTarget(self, action: #selector(btnWishlistClicked), for: .touchUpInside)
        cell.lblSelection.isHidden = (indexPath.row == nAnnotationSeletedIndex) ? false : true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Screen.width/2 - 30 , height:cvRoom.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 30, 0, 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row>=arrExploreData.count
        {
            return
        }
        self.uploadDidfinish(Int32(indexPath.row))
    }
    
    func btnWishlistClicked(sender: UIButton!) {
        self.selectedIndex = sender.tag
        if(self.arrExploreData[selectedIndex].is_wishlist == "Yes") {
            //Delete from the saved list
            self.removeFromWishList()
        }else{
            let count = (appDelegate?.arrWishList.count)!
            if(count > 0){
                let vc = AddWishlistVC(nibName: "AddWishlistVC", bundle: nil)
                vc.strRoomId = self.arrExploreData[self.selectedIndex].room_id
                vc.strRoomName = self.arrExploreData[self.selectedIndex].room_name
                vc.view.backgroundColor = UIColor.clear
                vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                self.present(vc, animated: false, completion: nil)
            }else{
                //Create new wishlist
                let createVc = AddWishListItemVC(nibName: "AddWishListItemVC", bundle: nil)
                createVc.roomName = arrExploreData[self.selectedIndex].room_name
                createVc.roomId = arrExploreData[self.selectedIndex].room_id
                self.present(UINavigationController(rootViewController: createVc), animated: true, completion: {})
            }
        }
    }
    
    //MARK: - Custom Method
    func displayRegionIncomeLevel(){
        if arrExploreData.count == 0{
            return
        }
        let modelData1 = arrExploreData[0]
        currencySymbol = (modelData1.currency_symbol as String).stringByDecodingHTMLEntities
        
        let regionLatitude = modelData1.latitude
        let regionLongitude =  modelData1.longitude
        
        var lon:Double!
        var lat:Double!
        
        let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(regionLatitude)! , longitude: Double(regionLongitude)!)
        let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(BostonCoordinates, 35500, 35500)
        let adjustedRegion: MKCoordinateRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
        mapView.delegate = self
        
        for i in 0..<arrExploreData.count
        {
            let modelData = arrExploreData[i]
            lat = Double(modelData.latitude as String)!
            lon = Double(modelData.longitude as String)!
            
            point3 = MyCustomPointAnnotation()
            point3.coordinate = CLLocationCoordinate2DMake(lat, lon)
            point3.color = UIColor.black
            point3.price = String(format: "%@%@-%d-%@",currencySymbol, modelData.room_price,i,modelData.instant_book)
            mapView.addAnnotation(point3)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.uploadDidfinish(0)
        }
    }
    
    public func uploadDidfinish(_ tag: Int32)
    {
        let modelData = arrExploreData[Int(tag)]
        let regionLatitude = modelData.latitude
        let regionLongitude =  modelData.longitude
        let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(regionLatitude)! , longitude: Double(regionLongitude)!)
        let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(BostonCoordinates, 38500, 38500)
        let adjustedRegion: MKCoordinateRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
        
        nAnnotationSeletedIndex = Int(tag)
        let nextItem = IndexPath(item: Int(tag), section: 0)
        cvRoom.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
        cvRoom.reloadData()
        
        let info1 = MyCustomPointAnnotation()
        info1.coordinate = CLLocationCoordinate2D(latitude: Double(regionLatitude)! , longitude: Double(regionLongitude)!)
        info1.price = String(format: "%@%@-%d-%@",currencySymbol, modelData.room_price,Int(tag),modelData.instant_book)
        info1.color = UIColor.white
        mapView.addAnnotation(info1)
        
        mapView.selectAnnotation(info1 as MKAnnotation, animated: true)
    }
    
    
    //MARK: - IBAction Method
    @IBAction func btnActionClicked(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnFilterClicked(_ sender: Any) {
        let filterVC = FilterVC(nibName: "FilterVC", bundle: nil)
        filterVC.delegate = self.delegate
        filterVC.dictParams = self.dictParams
        filterVC.noOfFilterApplied = self.noOfFilterApplied
        appDelegate?.isFromMap = true
        self.present(filterVC, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- API call add in Existing whishlist details
    func removeFromWishList() {
        ProgressHud.shared.Animation = true
        let roomId = self.arrExploreData[self.selectedIndex].room_id
        let params = NSMutableDictionary()
        params.setValue(roomId, forKey: "room_id")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_DELETE_WISHLIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    if(response != nil){
                        let resDic = response as! NSDictionary
                        self.arrExploreData[self.selectedIndex].is_wishlist = "No"
                        let indexPath = IndexPath(row: self.selectedIndex, section: 0)
                        self.cvRoom.reloadItems(at: [indexPath])
                        self.getWhishList()
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
                        // self.CV_WhishListSelection.reloadData()
                        ExploreVC.isWishListCreated = true
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
}
