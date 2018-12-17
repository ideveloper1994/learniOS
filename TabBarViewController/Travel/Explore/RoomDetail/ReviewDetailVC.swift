//
//  ReviewDetailVC.swift
//  Arheb
//
//  Created on 6/14/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class ReviewDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var tblReview: UITableView!
    
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var lblReviewCount: UILabel!
    @IBOutlet var lblTotalRatting: UILabel!
    
    @IBOutlet var lblAccuracy: UILabel!
    @IBOutlet var lblCheckIn: UILabel!
    @IBOutlet var lblClenliness: UILabel!
    @IBOutlet var lblCommunication: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblValue: UILabel!
    
    var objReviews = ReviewsModel()
    
    var roomId = ""
    var isLoading = true
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewcustomization()
        self.getReviewDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewcustomization(){
        tblReview.estimatedRowHeight = 100
        tblReview.rowHeight = UITableViewAutomaticDimension
        tblReview.tableFooterView = UIView()
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    func registerCell(){
        tblReview.dataSource = self
        tblReview.delegate = self
        tblReview.register(UINib(nibName: "RatingDetailCell", bundle: nil), forCellReuseIdentifier: "RatingDetailCell")
    }
    
    //MARK:- Set Header View
    func setHeaderDetails() {
        self.lblReviewCount.text = String(format:(objReviews.total_review == "1") ? "%@ " + review : "%@ " + reviews, objReviews.total_review)
        self.lblTotalRatting.text = createRatingStar(ratingValue: objReviews.value)
        self.lblAccuracy.text = createRatingStar(ratingValue: objReviews.accuracy_value)
        self.lblCheckIn.text = createRatingStar(ratingValue: objReviews.check_in_value)
        self.lblClenliness.text = createRatingStar(ratingValue: objReviews.cleanliness_value)
        self.lblCommunication.text = createRatingStar(ratingValue: objReviews.communication_value)
        self.lblLocation.text = createRatingStar(ratingValue: objReviews.location_value)
        self.lblValue.text = createRatingStar(ratingValue: objReviews.value)
        self.tblReview.tableHeaderView = self.vwHeader
    }
    
    //MARK: - Tableview delegate & datasource method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objReviews.userDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingDetailCell", for: indexPath) as! RatingDetailCell
        let objUser = self.objReviews.userDetails[indexPath.row]
        cell.lblReviewDetail.text = objUser.review_message
        cell.lblUserName.text = objUser.review_user_name
        cell.lblReviewDate.text = objUser.review_date
        if(objUser.review_user_image != ""){
            cell.imgUser.sd_setImage(with: URL(string: objUser.review_user_image), placeholderImage:UIImage(named:""))
        }
        return cell
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- API call
    func getReviewDetail() {
        self.isLoading = true
        if(pageNo == 1){
            
        }
        let params = NSMutableDictionary()
        params.setValue(self.pageNo, forKey: "page")
        params.setValue(self.roomId, forKey: "room_id")
        
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_REVIEW_LIST, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!, isSuccess: false)
                }else{
                    let resDic = response as! NSDictionary
                    self.objReviews = ReviewsModel().initiateReviewData(responseDict: resDic)
                    self.setHeaderDetails()
                    self.tblReview.reloadData()
                    self.isLoading = false
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    
}
