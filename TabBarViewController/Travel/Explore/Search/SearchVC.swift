//
//  SearchVC.swift
//  Arheb
//
//  Created on 6/5/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

protocol AddressPickerDelegate {
    func aaddressPickingDidFinish(_ searchedLocation: LocationModel, searchedString : String)
}

class SearchVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate,GooglePlacesDataLoaderDelegate {
    
    @IBOutlet var tblList: UITableView!
    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var txtFldSearch: UITextField!
    @IBOutlet var btnClear: UIButton!
    @IBOutlet var btnClose: UIButton!
    
    var selectedLocation: LocationModel!
    var modelCustomLocation: CustomLocationModel!
    var delegate: AddressPickerDelegate?
    var selectedCell: SearchCell!
    var strLocationName: String = ""
    var dataLoader: GooglePlacesDataLoader?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var searchCountdownTimer: Timer?
    var autocompletePredictions = [Any]()
    weak var locationAnnotation: MKAnnotation?
    var isCalled : Bool = false
    var strSearchLoc: String = ""
    
    // MARK:- View Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        updateCurrentLocation()
        let longitude = GETVALUE(USER_LONGITUDE) as NSString
        let latitude = GETVALUE(USER_LATITUDE) as NSString
        if (longitude.length > 0 && latitude.length > 0) {
            let longitude1 :CLLocationDegrees = Double(longitude as String)!
            let latitude1 :CLLocationDegrees = Double(latitude as String)!
            let location = CLLocation(latitude: latitude1, longitude: longitude1)
            self.currentLocation = location
        }
        if strSearchLoc.characters.count>0 {
            if strSearchLoc != "Nearby" && strSearchLoc != "Anywhere" {
                txtFldSearch.text = strSearchLoc
                self.startCountdownTimer(forSearch: txtFldSearch.text!)
            }
        }
        let locName = GETVALUE(USER_LOCATION) as NSString
        if (locName.length > 0) {
            self.strLocationName = locName as String
            txtFldSearch.becomeFirstResponder()
        }
        txtFldSearch.textColor = UIColor.white
        txtFldSearch.delegate = self
        txtFldSearch.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        btnClear.isHidden = true
        UITextField.appearance().tintColor = UIColor.white
        tblList.tableHeaderView = vwHeader
        dataLoader = GooglePlacesDataLoader.init(delegate: self)
        selectedLocation = LocationModel()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Here Customize the view
    func viewcustomization(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK:- TableView Method(s)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section != 0) {
            return 70
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section != 0) {
            let viewHolder:UIView = UIView()
            viewHolder.frame =  CGRect(x: 0, y:0, width: (self.view.frame.size.width) ,height: 40)
            let lblSeparator:UILabel = UILabel()
            lblSeparator.frame =  CGRect(x: 0, y:20, width: viewHolder.frame.size.width ,height: 1)
            lblSeparator.backgroundColor = UIColor.lightGray
            viewHolder.addSubview(lblSeparator)
            let lblRoomName:UILabel = UILabel()
            lblRoomName.frame =  CGRect(x: 50, y:30, width: viewHolder.frame.size.width-100 ,height: 40)
            lblRoomName.text="Popular Destinations"
            lblRoomName.textColor = UIColor.lightGray
            viewHolder.addSubview(lblRoomName)
            return viewHolder
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.autocompletePredictions.count == 0 {
            return 65
        } else {
            return 76
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.autocompletePredictions.count == 0) ? 2 : self.autocompletePredictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.autocompletePredictions.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
            cell.lblName.text = (indexPath.row==0) ? "Anywhere" : "Nearby"
            cell.lblName?.font = UIFont (name: "CircularAirPro-Book", size: 18)
            return cell
        } else {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
            cell.lblName.text = String(format:"%@ %@",finalTitle!,finalSubTitle)
            cell.lblName.font = UIFont (name: "CircularAirPro-Book", size: 17)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.autocompletePredictions.count == 0 {
            let longitude = GETVALUE(USER_LONGITUDE) as NSString
            let latitude = GETVALUE(USER_LATITUDE) as NSString
            if (longitude.length > 0 && latitude.length > 0) {
                selectedLocation.searchedAddress = strLocationName
                self.selectedLocation.longitude = String(format: "%2f", self.currentLocation.coordinate.longitude)
                self.selectedLocation.latitude = String(format: "%2f", self.currentLocation.coordinate.latitude)
            }
            delegate?.aaddressPickingDidFinish(self.selectedLocation,searchedString : (indexPath.row == 0) ? "Anywhere" : "Nearby")
            self.btnCloseClicked(nil)
        } else {
            selectedCell = tableView.cellForRow(at: indexPath) as! SearchCell
            let dict = self.locationDescription(at: indexPath.row) as NSDictionary
            let title  = dict["description"]
            selectedLocation.searchedAddress = (selectedCell.lblName.text)!
            delegate?.aaddressPickingDidFinish(self.selectedLocation,searchedString : title as! String)
            self.btnCloseClicked(nil)
        }
    }
    
    func Btn_Close(sender: UIButton!){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- API Calling Method(s)
    
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
    
    func GetGoogleRequest(_ dict: NSMutableDictionary, methodName : NSString, forSuccessionBlock successBlock: @escaping (_ newResponse: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        self.getBlockServerResponse(dict, method: methodName, withSuccessionBlock: {(_ response: Any) -> Void in
            successBlock(response)
        }, andFailureBlock: {(_ error: Error) -> Void in
            failureBlock(error)
        })
    }
    
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
    
    func getLocationData(){
        let param = NSMutableDictionary()
        param.setValue(GetKey.location, forKey: GetKey.getType)
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName:"", params: param, isTokenRequired: false, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    print(error ?? "")
                }else {
                    self.modelCustomLocation = addDataToCustomLocationModel(data: response as! NSData)
                    self.selectedLocation.searchedAddress = self.modelCustomLocation.geoplugin_countryName
                    self.selectedLocation.longitude = self.modelCustomLocation.geoplugin_longitude
                    self.selectedLocation.latitude = self.modelCustomLocation.geoplugin_latitude
                    self.getLocationName(lat: Double(self.selectedLocation.latitude)!, long:Double(self.selectedLocation.longitude)!)
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    // MARK:- Custom Method(s)
    func searchDidComplete(withPlaceDetails placeDetails: NSDictionary) {
        let placeGeometry =  (placeDetails["geometry"]) as? NSDictionary
        let locationDetails  = (placeGeometry?["location"]) as? NSDictionary
        let lat = (locationDetails?["lat"] as? Double)
        let lng = (locationDetails?["lng"] as? Double)
        selectedLocation.searchedAddress = (((placeDetails as Any) as AnyObject).value(forKey: "formatted_address") as? String)!
        self.selectedLocation.longitude = String(format: "%2f", lng!)
        self.selectedLocation.latitude = String(format: "%2f", lat!)
        delegate?.aaddressPickingDidFinish(self.selectedLocation,searchedString : (selectedCell.lblName.text)!)
    }
    
    func searchDidComplete(withPlaceDetails placeDetails: [AnyHashable: Any], andAttributions htmlAttributions: String) {
        locationAnnotation = PlaceDetailsAnnotation(placeDetails: placeDetails)
        selectedLocation.searchedAddress = (((placeDetails as Any) as AnyObject).value(forKey: "formatted_address") as? String)!
        self.selectedLocation.longitude = String(format: "%2f", (self.locationAnnotation?.coordinate.longitude)!)
        self.selectedLocation.latitude = String(format: "%2f", (self.locationAnnotation?.coordinate.latitude)!)
        self.selectedLocation.currentLocation = CLLocation(latitude: (self.locationAnnotation?.coordinate.latitude)!, longitude: (self.locationAnnotation?.coordinate.longitude)!)
        delegate?.aaddressPickingDidFinish(self.selectedLocation,searchedString : "")
    }
    
    func googleData(didLoadPlaceDetails placeDetails: NSDictionary) {
        self.searchDidComplete(withPlaceDetails: placeDetails)
    }
    
    func locationDescription(at index: Int) -> [AnyHashable: Any] {
        let jsonData: [AnyHashable: Any] = self.autocompletePredictions[index] as! [AnyHashable : Any]
        return jsonData
    }
    
    func getLocationName(lat: CLLocationDegrees, long: CLLocationDegrees)  {
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
                if(pm.locality != nil){
                self.strLocationName = pm.locality!
                    STOREVALUE(value: self.strLocationName, keyname: USER_LOCATION)
                }
            } else {
            }
        })
    }
    
    func startCountdownTimer(forSearch searchString: String) {
        if (self.searchCountdownTimer != nil) {
            self.searchCountdownTimer?.invalidate()
        }
        self.dataLoader?.cancelAllRequests()
        let fireDate = Date(timeIntervalSinceNow: 1.0)
        let info: [AnyHashable: Any] = [
            "searchString" : searchString,
            ]
        self.searchCountdownTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(self.searchCountdownTimerFired), userInfo: info, repeats: false)
        RunLoop.main.add(self.searchCountdownTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func searchCountdownTimerFired(_ countdownTimer: Timer) {
        let searchString = countdownTimer.userInfo as! NSDictionary
        let newsearchString: String? = searchString["searchString"] as? String
        self.dataLoader?.sendAutocompleteRequest(withSearch: newsearchString, andLocation: nil)
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
    
    func showAlert() {
        let locName = GETVALUE(USER_LOCATION) as NSString
        if (locName.length > 0) {
            self.strLocationName = locName as String
            txtFldSearch.becomeFirstResponder()
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
    
    // MARK:- TextField Delegate Method(s)
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateCurrentLocation()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataLoader?.cancelAllRequests()
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        btnClear.isHidden = ((textField.text?.characters.count)! > 0) ? false : true
        self.startCountdownTimer(forSearch: textField.text!)
    }
    
    // MARK: - GooglePlacesDataLoaderDelegate methods
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, didLoadAutocompletePredictions predictions: [Any]) {
        self.autocompletePredictions = predictions
        tblList.reloadData()
    }
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, didLoadPlaceDetails placeDetails: [AnyHashable: Any], withAttributions htmlAttributions: String) {
        self.searchDidComplete(withPlaceDetails: placeDetails, andAttributions: htmlAttributions)
    }
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, autocompletePredictionsDidFailToLoad error: Error?) {
    }
    
    func googlePlacesDataLoader(_ loader: GooglePlacesDataLoader, placeDetailsDidFailToLoad error: Error?) {
    }
    
    // MARK: Location Manager Delegate methods
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        STOREVALUE(value: String(format: "%f", coord.longitude), keyname: USER_LONGITUDE)
        STOREVALUE(value: String(format: "%f", coord.latitude), keyname: USER_LATITUDE)
        
        let locName = GETVALUE(USER_LOCATION)
        if (locName == "") {
            self.getLocationName(lat: coord.latitude, long: coord.longitude)
        }
        self.currentLocation = locationObj
        locationManager.stopUpdatingLocation()
    }
   
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnClearClicked(_ sender: Any) {
        txtFldSearch.text = ""
        self.autocompletePredictions = [Any]()
        tblList.reloadData()
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
}
