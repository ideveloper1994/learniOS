//
//  PhotoUploadVC.swift
//  Arheb
//
//  Created on 6/21/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class PhotoUploadVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var ConstVwMainLeading: NSLayoutConstraint!
    
    var imagePicker = UIImagePickerController()
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getInstagramUserDetail(notification:)),
                                               name: NSNotification.Name(rawValue: NotificationName.instagramToken), object: nil)
    }    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ConstVwMainLeading.constant += UIScreen.main.bounds.size.width*2
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.ConstVwMainLeading.constant -= UIScreen.main.bounds.size.width*2
            // self.view.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK: - Image Picker Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            let pickedImageEdited: UIImage? = (info[UIImagePickerControllerOriginalImage] as? UIImage)
            uploadImage(imageToUpload: pickedImageEdited!)
        }
        dismiss(animated: false, completion: nil)
    }
    
    //MARK: - IBAction Method
    @IBAction func btnFacbookPhotoClicked(_ sender: Any){
        let viewWeb = LoadWebView(nibName: "LoadWebView", bundle: nil)
        viewWeb.hidesBottomBarWhenPushed = true
        viewWeb.strPageTitle = instagram
        viewWeb.strWebUrl = String(format: "https://www.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=%@",InstagramKey.clientId,InstagramKey.redirectUrl,InstagramKey.scope)
        print(viewWeb.strWebUrl)
        self.navigationController?.pushViewController(viewWeb, animated: true)
    }
    
    @IBAction func btnSkipClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUploadPhotoClicked(_ sender: Any) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: take_photo, style: .default) { _ in
            self.takePhoto()
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: choose_photo, style: .default)
        { _ in
            self.choosePhoto()
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: cancel_s, style: .cancel)
        { _ in
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    //MARK: - Custom Method
    func takePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let settingsActionSheet: UIAlertController = UIAlertController(title:error, message:device_has_no_camera, preferredStyle:UIAlertControllerStyle.alert)
            settingsActionSheet.addAction(UIAlertAction(title:ok, style:UIAlertActionStyle.cancel, handler:nil))
            present(settingsActionSheet, animated:true, completion:nil)
        }
    }
    func choosePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - Notification Method
    func getInstagramUserDetail(notification: NSNotification){
        let token:String = notification.userInfo!["token"] as! String
        let param = NSMutableDictionary()
        param.setValue(GetKey.instagram, forKey: GetKey.getType)
        param.setValue(token , forKey: "token")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName:"", params: param, isTokenRequired: false, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    print(error ?? "")
                }else {
                    let dict:NSDictionary = response as! NSDictionary
                    if(dict.value(forKey: "data") != nil){
                        let dictData:NSDictionary = dict.value(forKey: "data") as! NSDictionary
                        print(dictData.value(forKey: "profile_picture") ?? "")
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    //MARK: - Api Call
    //Upload Profile Image
    func uploadImage(imageToUpload: UIImage){
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        params.setValue(PostKey.image, forKey: PostKey.postType)
        params.setValue(imageToUpload, forKey: PostKey.imageData)
        let objUser:LoginModel = getUserDetails()!
        let fileName = (objUser.user_id) + ".jpg"
        params.setValue(fileName, forKey: PostKey.filename)
        ServerAPI.sharedInstance.makeCall(requestMethod: "POST", apiName: API_UPLOAD_PROFILE_IMAGE, params: params, isTokenRequired: true, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
                if(error != nil){
                    showToastMessage(error!, isSuccess: false)
                }else{
                   // let res = res as! NSDictionary
                }
            }
        }) { (error) in
            print(error)
            ProgressHud.shared.Animation = false
        }
    }
    

    //MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
