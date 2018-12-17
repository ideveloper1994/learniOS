//
//  LocationVC.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import MapKit
import FLAnimatedImage

protocol HostRoomLocationDelegate {
    func onHostRoomLocaitonChanged(modelList:ListingModel)
}

class LocationVC: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate, GooglePlacesDataLoaderDelegate, EditLocationDelegate {
    
    // MARK:- IBOutlet(s)
    @IBOutlet var lblWhatCity: UILabel!
    @IBOutlet var ConstLbHeight: NSLayoutConstraint!
    @IBOutlet var tblLocation: UITableView!
    @IBOutlet var ConstTblHeight: NSLayoutConstraint!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var txtLocation: UITextField!
    @IBOutlet var btnClearText: UIButton!
    @IBOutlet var animatedLoader: FLAnimatedImageView!
    @IBOutlet var lblCallout: UILabel!
    @IBOutlet var lblLocation: UILabel!
    
    var strRoomType = ""
    var strPropertyType = ""
    var strPropertyName = ""
    var strGuestType = ""
    var isLocationPicked: Bool = false
    var strRoomLocation = ""
    var strLatitude = ""
    var strLongitude = ""
    var isFirstTime : Bool = true
    var isSearchStarted: Bool = false
    var dataLoader: GooglePlacesDataLoader?
    var googleModel: GoogleLocationModel!
    var locationManager: CLLocationManager!
    var searchCountdownTimer: Timer?
    var currentLocation: CLLocation!
    var autocompletePredictions = [Any]()
    var isFromAddRoomDetail : Bool = false
    var dictLocation = NSMutableDictionary()
    var isCalled: Bool = false
    var strLocationName:String = ""
    var delegate: AddressPickerDelegate?
    weak var locationAnnotation: MKAnnotation?
    var selectedLocation: LocationModel!
    var listModel : ListingModel!
    var delegateHost: HostRoomLocationDelegate?
    var modelCustomLocation : CustomLocationModel!
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCallout.isHidden = true
        dataLoader = GooglePlacesDataLoader.init(delegate: self)
        animatedLoader?.isHidden = true
        txtLocation.delegate = self
        btnClearText.titleLabel?.font = UIFont(name: "makent2", size: 17)
        btnNext.isHidden = true
        selectedLocation = LocationModel()
        tblLocation.isHidden = true
        dataLoader = GooglePlacesDataLoader.init(delegate: self)
        txtLocation.layer.borderColor =  UIColor(red: 223.0 / 255.0, green: 224.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0).cgColor
        txtLocation.layer.borderWidth = 1.0
        txtLocation.layer.cornerRadius = 3.0
        txtLocation.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        tblLocation.delegate = self
        tblLocation.dataSource = self
        tblLocation.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
        ConstTblHeight.constant = 0
        self.localization()
        if isFromAddRoomDetail {
            btnNext.setTitle("Save", for: .normal)
            txtLocation.placeholder = "Address"
            txtLocation.text = strRoomLocation
            isSearchStarted = true
            let longitude1 :CLLocationDegrees = Double(strLongitude)!
            let latitude1 :CLLocationDegrees = Double(strLatitude)!
            UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions(), animations: { () -> Void in
                let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude1 , longitude: longitude1)
                let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(BostonCoordinates, 35500, 35500)
                let adjustedRegion: MKCoordinateRegion = self.mapView.regionThatFits(viewRegion)
                self.mapView.setRegion(adjustedRegion, animated: true)
            }, completion: { (finished: Bool) -> Void in
            })
            self.setClearButton()
            ConstLbHeight.constant = 0
        } else {
            updateCurrentLocation()
            ConstLbHeight.constant = 50
        }
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.onZoom), userInfo: nil, repeats: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK:- Google Place Delegate Method(s)
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, didLoadAutocompletePredictions predictions: [Any]) {
        self.autocompletePredictions = predictions
        tblLocation.isHidden = false
        tblLocation.reloadData()
    }
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, didLoadPlaceDetails placeDetails: [AnyHashable: Any], withAttributions htmlAttributions: String) {
        self.searchDidComplete(withPlaceDetails: placeDetails, andAttributions: htmlAttributions)
    }
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, autocompletePredictionsDidFailToLoad error: Error?) {
    }
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, placeDetailsDidFailToLoad error: Error?) {
    }
    
    func showAlert() {
        let locName = GETVALUE(USER_LOCATION) as NSString
        if locName.length > 0 {
            self.strLocationName = locName as String
            txtLocation.becomeFirstResponder()
        } else {
            self.strLocationName = locName as String
        }
        let settingsActionSheet: UIAlertController = UIAlertController(title:"Location Permission", message:"Please grant Makent access to your location through settings > privacy > location services.", preferredStyle:UIAlertControllerStyle.alert)
        settingsActionSheet.addAction(UIAlertAction(title:"Settings", style:UIAlertActionStyle.default, handler:{ action in
            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
    }
    
    func updateCurrentLocation() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                     getLocationData()
                    locationManager.requestWhenInUseAuthorization()
                    break
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.requestAlwaysAuthorization()
                }
            } else {
                self.showAlert()
            }
            locationManager.delegate = self
        }
        if #available(iOS 8.0, *) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    // MARK:- TextField Delegate Method(s)
    
    func textFieldDidChange(_ textField: UITextField) {
        if isFromAddRoomDetail {
            btnNext.isHidden = true
        } else {
            self.btnNext.isHidden = ((textField.text?.characters.count)! > 0) ? false : true
        }
        self.startCountdownTimer(forSearch: textField.text!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isFromAddRoomDetail {
            isSearchStarted = true
            self.updateCurrentLocation()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isSearchStarted = false
        dataLoader?.cancelAllRequests()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        } else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK:- Table View Method(s)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ConstTblHeight.constant = CGFloat(autocompletePredictions.count * 44)
        return (self.autocompletePredictions.count == 0) ? 0 : self.autocompletePredictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dict: [AnyHashable: Any] = self.locationDescription(at: indexPath.row)
        let titleString: String? = (dict["description"] as? String)
        var addresArray  = titleString?.components(separatedBy: ",")
        let finalTitle: String? = ((addresArray?.count)! > 0) ? addresArray?[0] : ""
        var finalSubTitle: String = ""
        let count = (addresArray?.count)! as Int
        for i in 1 ..< count {
            finalSubTitle = finalSubTitle + (addresArray?[i])!
            if i < (addresArray?.count)! - 1 {
                if i == 1 {
                    finalSubTitle = finalSubTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                }
                finalSubTitle = finalSubTitle + ","
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        cell.imgCurrency.isHidden = true
        cell.lblCurrency.textColor = UIColor.darkGray
        cell.lblCurrency.text = String(format:"%@ %@",finalTitle!,finalSubTitle)
        cell.lblCurrency.font = UIFont (name: "CircularAirPro-Book", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ConstTblHeight.constant = 0
        let selectedCell = tableView.cellForRow(at: indexPath) as! CurrencyCell
        txtLocation.text =  (selectedCell.lblCurrency.text)!
        let selPrediction = self.autocompletePredictions[indexPath.row] as! NSDictionary
        let referenceID: String? = (selPrediction["reference"] as? String)
        self.dataLoader?.cancelAllRequests()
        self.getLocationCoordinates(withReferenceID: referenceID!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.autocompletePredictions.count == 0 {
            return 50
        } else {
            return 50
        }
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClicked(_ sender: UIButton) {
        if !isFromAddRoomDetail {
            let vc = RoomsAndBedVC(nibName: "RoomsAndBedVC", bundle: nil)
            vc.strRoomType = strRoomType
            vc.strPropertyType = strPropertyType
            vc.strLat = strLatitude
            vc.strLong = strLongitude
            vc.strRoomLocation = (txtLocation.text?.replacingOccurrences(of: " ", with: "%20"))!
            vc.strPropertyName = strPropertyName
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if isLocationPicked {
                updateLocationFromAddRoomDetail(dictLocation)
            } else {
                let dict = NSMutableDictionary()
                dict["room_id"]   = appDelegate?.strRoomID
                dict["latitude"]   = strLatitude
                dict["longitude"]   = strLongitude
                dict["is_success"]   = "No"
                updateLocationFromAddRoomDetail(dict)
            }
        }
    }
    
    @IBAction func btnClearClicked(_ sender: Any) {
        if (txtLocation.text?.characters.count)! > 0
        {
            btnClearText.titleLabel?.font = UIFont(name: "makent2", size: 11)
            txtLocation.text = ""
            self.setLocationbutton()
            btnNext.isHidden = true
        } else {
            if strLocationName.characters.count > 0 {
                txtLocation.text = strLocationName
                setClearButton()
                btnNext.isHidden = false
                let longitude = GETVALUE(USER_LONGITUDE)
                let latitude = GETVALUE(USER_LATITUDE)
                if longitude.characters.count > 0 && latitude.characters.count > 0 {
                    let longitude1 :CLLocationDegrees = Double(longitude as String)!
                    let latitude1 :CLLocationDegrees = Double(latitude as String)!
                    UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions(), animations: { () -> Void in
                        let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude1 , longitude: longitude1)
                        let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(BostonCoordinates, 35500, 35500)
                        let adjustedRegion: MKCoordinateRegion = self.mapView.regionThatFits(viewRegion)
                        self.mapView.setRegion(adjustedRegion, animated: true)
                    }, completion: { (finished: Bool) -> Void in
                    })
                }
            }
        }
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        self.dataLoader?.cancelAllRequests()
        self.dataLoader?.sendAutocompleteRequest(withSearch: sender.text, andLocation: nil)
    }
    
    // MARK:- Custom Method(s)
    
    func onZoom() {
        lblCallout.center = mapView.center
        lblCallout.isHidden = false
        isSearchStarted = false
    }
    
    func setClearButton() {
        btnClearText.titleLabel?.font = UIFont(name: "makent2", size: 11)
        btnClearText.layer.borderColor = UIColor.darkGray.cgColor
        btnClearText.layer.borderWidth = 1.0
        btnClearText.layer.cornerRadius = self.btnClearText.frame.size.height/2
        btnClearText.setTitle("=", for: .normal)
        btnClearText.titleLabel?.text = "="
    }
    
    func googleData(didLoadPlaceDetails placeDetails: NSDictionary) {
        self.searchDidComplete(withPlaceDetails: placeDetails)
    }
    
    func searchDidComplete(withPlaceDetails placeDetails: NSDictionary) {
        let placeGeometry =  (placeDetails["geometry"]) as? NSDictionary
        let locationDetails  = (placeGeometry?["location"]) as? NSDictionary
        let lat = (locationDetails?["lat"] as? Double)
        let lng = (locationDetails?["lng"] as? Double)
        let longitude1 :CLLocationDegrees = lng!
        let latitude1 :CLLocationDegrees = lat!
        let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude1 , longitude: longitude1)
        let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(BostonCoordinates, 45500, 45500)
        let adjustedRegion: MKCoordinateRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
        btnNext.isHidden = false
        selectedLocation.longitude = String(format: "%2f", lng!)
        selectedLocation.latitude = String(format: "%2f", lat!)
        strLatitude = String(format: "%2f", lat!)
        strLongitude = String(format: "%2f", lng!)
        if isFromAddRoomDetail {
            gotoUpdateLocationView()
        }
        tblLocation.isHidden = true
    }
    
    func searchDidComplete(withPlaceDetails placeDetails: [AnyHashable: Any], andAttributions htmlAttributions: String) {
        locationAnnotation = PlaceDetailsAnnotation(placeDetails: placeDetails)
        selectedLocation.searchedAddress = (((placeDetails as Any) as AnyObject).value(forKey: "formatted_address") as? String)!
        selectedLocation.longitude = String(format: "%2f", (self.locationAnnotation?.coordinate.longitude)!)
        selectedLocation.latitude = String(format: "%2f", (self.locationAnnotation?.coordinate.latitude)!)
        self.currentLocation = CLLocation(latitude: (self.locationAnnotation?.coordinate.latitude)!, longitude: (self.locationAnnotation?.coordinate.longitude)!)
        delegate?.aaddressPickingDidFinish(self.selectedLocation,searchedString : "")
    }
    
    func gotoUpdateLocationView() {
        let locView = EditLocationVC(nibName: "EditLocationVC", bundle: nil)
        locView.googleModel = googleModel
        locView.delegate = self
        locView.strLatitude  =  strLatitude
        locView.strLongitude = strLongitude
        self.present(locView, animated: true, completion: {
        })
    }
    
    func changeAddress(_ dicts: NSMutableDictionary) {
        let locView =  EditLocationVC(nibName: "EditLocationVC", bundle: nil)
        locView.strStreetName = dicts["street_name"] as! String
        locView.strAbtName = dicts["street_address"] as! String
        locView.strCityName = dicts["city"] as! String
        locView.strStateName = dicts["state"] as! String
        locView.strZipcode = dicts["zip"] as! String
        locView.strCountryName = dicts["country"] as! String
        locView.strLatitude  =  strLatitude
        locView.strLongitude = strLongitude
        locView.isFromFromEditing = true
        locView.delegate = self
        //        self.navigationController?.hidesBottomBarWhenPushed = true
        self.present(locView, animated: true, completion: {
        })
    }
    
    func locationDescription(at index: Int) -> [AnyHashable: Any] {
        let jsonData: [AnyHashable: Any] = self.autocompletePredictions[index] as! [AnyHashable : Any]
        return jsonData
    }
    
    func zoomtoLocationWithlongitude(_ longitude: Double, latitude: Double) {
        var region = MKCoordinateRegion()
        var span = MKCoordinateSpanMake(0.075, 0.075)
        region.center = mapView.region.center
        span.latitudeDelta=mapView.region.span.latitudeDelta / 2.0002
        span.longitudeDelta=mapView.region.span.longitudeDelta / 2.0002
        region.span=span
        mapView.setRegion(region, animated: true)
    }
    
    func searchCountdownTimerFired(_ countdownTimer: Timer) {
        let searchString = countdownTimer.userInfo as! NSDictionary
        let newsearchString: String? = searchString["searchString"] as? String
        self.dataLoader?.sendAutocompleteRequest(withSearch: newsearchString, andLocation: nil)
    }
    
    func startCountdownTimer(forSearch searchString: String) {
        //stop the current countdown
        if self.searchCountdownTimer != nil {
            self.searchCountdownTimer?.invalidate()
        }
        //cancel all pending requests
        self.dataLoader?.cancelAllRequests()
        let fireDate = Date(timeIntervalSinceNow: 1.0)
        // add search data to the userinfo dictionary so it can be retrieved when the timer fires
        let info: [AnyHashable: Any] = [
            "searchString" : searchString,
            ]
        self.searchCountdownTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(self.searchCountdownTimerFired), userInfo: info, repeats: false)
        RunLoop.main.add(self.searchCountdownTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func setLocationbutton() {
        if !isFromAddRoomDetail {
            btnClearText.titleLabel?.font = UIFont(name: "makent2", size: 17)
            btnClearText.setTitle("2", for: .normal)
            btnClearText.titleLabel?.text = "2"
            btnClearText.layer.borderColor = UIColor.clear.cgColor
            btnClearText.layer.borderWidth = 0.0
            btnClearText.layer.cornerRadius = 0.0
        } else {
            btnClearText.titleLabel?.font = UIFont(name: "makent2", size: 17)
            btnClearText.setTitle("", for: .normal)
            btnClearText.titleLabel?.text = ""
            btnClearText.layer.borderColor = UIColor.clear.cgColor
            btnClearText.layer.borderWidth = 0.0
            btnClearText.layer.cornerRadius = 0.0
        }
    }
    
    func updateNewLocation(_ dicts : NSMutableDictionary, location_name: String) {
        var tempModel = ListingModel()
        tempModel = listModel
        tempModel.room_location = location_name
        if isLocationPicked {
            tempModel.street_name = dicts["street_name"] as! String
            tempModel.street_address = dicts["street_address"] as! String
            tempModel.city_name = dicts["city"] as! String
            tempModel.state_name = dicts["state"] as! String
            tempModel.zipcode = dicts["zip"] as! String
            tempModel.country_name = dicts["country"] as! String
        } else {
            tempModel.street_name = dicts["address_line_1"] as! String
            tempModel.street_address = dicts["address_line_2"] as! String
            tempModel.city_name = dicts["city"] as! String
            tempModel.state_name = dicts["state"] as! String
            tempModel.zipcode = dicts["postal_code"] as! String
            tempModel.country_name = dicts["country"] as! String
        }
        tempModel.latitude = strLatitude
        tempModel.longitude = strLongitude
        listModel = tempModel
        delegateHost?.onHostRoomLocaitonChanged(modelList:listModel)
    }
    
    // MARK:- Location Manager Delegate Method(s)
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        STOREVALUE(value: String(format: "%f", coord.longitude), keyname: USER_LONGITUDE)
        STOREVALUE(value: String(format: "%f", coord.latitude), keyname: USER_LATITUDE)
        self.getLocationName(lat: coord.latitude, long: coord.longitude)
        strLatitude = String(format:"%f",coord.latitude)
        strLongitude = String(format:"%f",coord.longitude)
        self.currentLocation = locationObj
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if isSearchStarted {
            return
        }
        if isFromAddRoomDetail && !isFirstTime {
            isLocationPicked = false
            btnNext.isHidden = false
            return
        }
        if isFromAddRoomDetail {
            isLocationPicked = false
            btnNext.isHidden = true
            return
        }
        strLatitude = String(format:"%f",mapView.centerCoordinate.latitude)
        strLongitude = String(format:"%f",mapView.centerCoordinate.longitude)
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if placemarks == nil {
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])
                if pm != nil {
                    let strLoc = self.stringPlaceMark(placemark: pm!)
                    if strLoc.characters.count>0 {
                        self.txtLocation.text = strLoc
                        self.btnNext.isHidden = false
                    }
                }
            }
        })
    }
    
    func stringPlaceMark(placemark: CLPlacemark) -> String {
        var string = String()
        if (placemark.locality != nil) {
            string += placemark.locality!
        }
        if (placemark.administrativeArea != nil) {
            if (string.characters.count ) > 0 {
                string += ", "
            }
            string += placemark.administrativeArea!
        }
        if (placemark.country != nil) {
            if (string.characters.count ) > 0 {
                string += ", "
            }
            string += placemark.country!
        }
        if (string.characters.count  == 0 && placemark.name != nil) {
            string += placemark.name!
        }
        if (placemark.thoroughfare != nil) {
        }
        return string
    }
    
    func getLocationName(lat: CLLocationDegrees, long: CLLocationDegrees) {
        if isCalled {
            return
        }
        isCalled = true
        let longitude :CLLocationDegrees = long
        let latitude :CLLocationDegrees = lat
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])!
                self.txtLocation.text = String(format:"%@, %@",pm.locality!,pm.country!)
                self.btnNext.isHidden = false
                self.strLocationName = String(format:"%@, %@",pm.locality!,pm.country!)
                STOREVALUE(value: self.strLocationName, keyname: USER_LOCATION)
                self.setClearButton()
                UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions(), animations: { () -> Void in
                    let BostonCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat , longitude: long)
                    let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(BostonCoordinates, 35500, 35500)
                    let adjustedRegion: MKCoordinateRegion = self.mapView.regionThatFits(viewRegion)
                    self.mapView.setRegion(adjustedRegion, animated: true)
                }, completion: { (finished: Bool) -> Void in
                })
            } else {
            }
        })
    }
    
    // MARK:- API Calling Method(s)
    
    func getLocationCoordinates(withReferenceID referenceID: String) {
        self.view.endEditing(true)
        let dict = NSMutableDictionary()
        if KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken) != nil{
            let authToken = KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken)
            dict.setValue(authToken, forKey: "token")
        }
        self.GetGoogleRequest(dict,methodName: referenceID as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let gModel = response as! GoogleLocationModel
            OperationQueue.main.addOperation {
                if gModel.status_code == "1" {
                    self.googleModel = gModel
                    let dictTemp = gModel.dictTemp["result"] as! NSDictionary
                    self.googleData(didLoadPlaceDetails: dictTemp)
                } else {
                }
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
            }
        })
    }
    
    func updateLocationFromAddRoomDetail(_ dict : NSMutableDictionary) {
        ProgressHud.shared.Animation = true
        self.animatedLoader.isHidden = false
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_UPDATE_ROOM_LOCATION, params: dict , isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    let result = response as! NSDictionary
                    let locationDetail = result["location_details"] as! NSDictionary
                    let locationName = result["location_name"] as? String
                    if locationDetail.count > 0 && self.isLocationPicked {
                        self.updateNewLocation(dict, location_name: locationName!)
                    } else {
                        self.updateNewLocation(dict, location_name: locationName!)
                    }
                    self.navigationController!.popViewController(animated: true)
                }
                ProgressHud.shared.Animation = false
            }
            
        }) { (Error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
            }
        }
    }
    
    
    func GetGoogleRequest(_ dict: NSMutableDictionary, methodName : NSString, forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        self.getBlockServerResponse(dict, method: methodName, withSuccessionBlock: {(_ response: Any) -> Void in
            successBlock(response)
        }, andFailureBlock: {(_ error: Error) -> Void in
            failureBlock(error)
        })
    }
    
    func getBlockServerResponse(_ params: NSMutableDictionary, method: NSString, withSuccessionBlock successBlock: @escaping (_ response: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        let paramsComponent: String = "?key=AIzaSyAYVHgDeSBCitv0p-pxkJBMAVWemoa5Pkk&reference=\(method)&sensor=\("true")"
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json" + paramsComponent.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)
        var items = NSDictionary()
        let request = NSMutableURLRequest(url:url!);
        URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
            if !(data != nil) {
                failureBlock(error!)
            } else {
                do {
                    let jsonResult : Dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary as Dictionary
                    items = jsonResult as NSDictionary
                    if (items.count>0) {
                        successBlock(GoogleLocationModel().initiateLocationData(responseDict: items))
                    } else {
                        failureBlock(error!)
                    }
                } catch _ {
                }
            }
            }.resume()
    }
    func getLocationData(){
        let param = NSMutableDictionary()
        param.setValue(GetKey.location, forKey: GetKey.getType)
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName:"", params: param, isTokenRequired: false, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    print(error ?? "")
                }else {
                    self.modelCustomLocation = addDataToCustomLocationModel(data: response as! NSData)
                    self.strLatitude = self.modelCustomLocation.geoplugin_latitude
                    self.strLongitude = self.modelCustomLocation.geoplugin_longitude
                    self.getLocationName(lat: Double(self.modelCustomLocation.geoplugin_latitude)!, long:Double(self.modelCustomLocation.geoplugin_longitude)!)
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    //MARK: - Edit Location Delegate Method(s)
    
    func saveLocationName(dicts : NSMutableDictionary, isSuccess: Bool) {
        let settingsActionSheet: UIAlertController = UIAlertController(title: (isSuccess) ? locationFound : locationNotFound, message:manuallyPin, preferredStyle:UIAlertControllerStyle.alert)
        settingsActionSheet.addAction(UIAlertAction(title:editAddress, style:UIAlertActionStyle.default, handler:{ action in
            self.changeAddress(dicts)
        }))
        settingsActionSheet.addAction(UIAlertAction(title:pinOnMap, style:UIAlertActionStyle.destructive, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
        dictLocation = dicts
        isFirstTime = false
        if isSuccess {
            btnNext.isHidden = false
            isLocationPicked = true
        } else {
            isLocationPicked = false
            btnNext.isHidden = true
        }
    }
    
    func goBack() {
        self.navigationController!.popViewController(animated: false)
    }
    
    // MARK:- Localization Method
    func localization() {
        self.lblWhatCity.text = whatCity
        self.lblLocation.text = location
        self.txtLocation.placeholder = city
        self.btnNext.setTitle(nxt, for: .normal)
    }
}
