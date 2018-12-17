//
//  TripsVC.swift
//  Arheb
//
//  Created on 5/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FLAnimatedImage

class TripsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet var lbTrips: UILabel!
    @IBOutlet var collectionTrips: UICollectionView!
    @IBOutlet var animatedImageView: FLAnimatedImageView?
    @IBOutlet var animatedLoader: FLAnimatedImageView?
    @IBOutlet weak var  btnStartExplore : UIButton?
    @IBOutlet weak var  viewTipsHolder : UIView?
    @IBOutlet weak var  viewCollection : UIView?
    
    let arrTripsImgs = ["pending_trip.png","current_trip.png","upcoming_trip.png","past_trip.png"]
    var arrTripsList : NSArray = NSArray()
    
    // MARK:- View method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setDotLoader(animatedLoader)
        collectionTrips.register(UINib(nibName: "TripsCell", bundle: nil), forCellWithReuseIdentifier: "TripsCell")
        btnStartExplore?.layer.borderColor = UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0).cgColor
        btnStartExplore?.layer.borderWidth = 1.5
        btnStartExplore?.layer.cornerRadius = 5
        if let path =  Bundle.main.path(forResource: "itinerary-empty", ofType: "gif") {
            if let data = NSData(contentsOfFile: path) {
                let gif = FLAnimatedImage(animatedGIFData: data as Data!)
                animatedImageView?.animatedImage = gif
            }
        }
        self.getTripsStatus()
        self.viewTipsHolder?.isHidden = true
        self.viewCollection?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK:- Memory Warning(s)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- API Calling Method(s)
    
    func getTripsStatus(){
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_TRIPS_TYPE, params: NSMutableDictionary(), isTokenRequired: true, forSuccessionBlock: { (response, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    self.animatedLoader?.isHidden = true
                    self.viewTipsHolder?.isHidden = false
                    self.collectionTrips.isHidden = true
//                    showToastMessage(error!, isSuccess: true)
                }else{
                    let result = response as! NSDictionary
                    self.arrTripsList = result.value(forKey: "Trips_type") as! NSArray
                    self.animatedLoader?.isHidden = true
                    self.viewTipsHolder?.isHidden = true
                    self.viewCollection?.isHidden = false
                    self.collectionTrips.reloadData()
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            ProgressHud.shared.Animation = false
        }
    }
    
    // MARK:- Collection View Method(s)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTripsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionTrips.dequeueReusableCell(withReuseIdentifier: "TripsCell", for: indexPath as IndexPath) as! TripsCell
        if arrTripsList.count > 0 {
            cell.lblTripDetail?.text =  arrTripsList[indexPath.row] as? String
            cell.imageView?.image = UIImage(named:arrTripsImgs[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let rect = self.getScreenSize()
        return CGSize(width: (rect.size.width/2)-10, height: (rect.size.width/2)-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TripsDetailVC(nibName: "TripsDetailVC", bundle: nil)
        let triptype = (arrTripsList[indexPath.row] as AnyObject).lowercased.replacingOccurrences(of: " ", with: "_")
        let title = (arrTripsList[indexPath.row] as AnyObject).replacingOccurrences(of: "\n", with: " ")
        vc.strTripsType = triptype
        vc.strHeaderTitle = title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- Custom Method(s)
    
    func getScreenSize() -> CGRect {
        var rect = UIScreen.main.bounds as CGRect
        let orientation = UIApplication.shared.statusBarOrientation as UIInterfaceOrientation
        let device = UIScreen.main.traitCollection.userInterfaceIdiom
        if (device == .pad) {
            if(orientation.isLandscape) {
                rect = CGRect(x: 0, y:0,width: 1024 ,height: 768)
            } else {
                rect = CGRect(x: 0, y:0,width: 768 ,height: 1024)
            }
        }
        return rect
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func onStartExploreTapped(_ sender:UIButton!) {
        let tabbar:ArhebTabbar =  appDelegate?.window?.rootViewController as! ArhebTabbar
        tabbar.selectedIndex = 0
    }
    
}
