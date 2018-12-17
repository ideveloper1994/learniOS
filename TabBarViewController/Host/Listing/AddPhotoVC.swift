//
//  AddPhotoVC.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

protocol RoomImageAddedDelegate
{
    func RoomImageAdded(arrImgs:NSArray,arrImgIds:NSArray)
}


class AddPhotoVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var lbAddPhotos: UILabel!
    
    @IBOutlet var collectionImages: UICollectionView!
    
    var image:UIImage!
    var arrImages = NSMutableArray()
    var arrRoomImageIds = NSMutableArray()
    var listModel = ListingModel()
    var imagePicker = UIImagePickerController()
    var nSelectedIndex : Int = 0
    var isRemoveTapped:Bool = false
    var delegate: RoomImageAddedDelegate?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        btnEdit.setTitle(edit, for: .normal)
        lbAddPhotos.text = addphotos
        collectionImages.delegate = self
        collectionImages.dataSource = self
        collectionImages.register(UINib(nibName: "SelectedImageCell", bundle: nil), forCellWithReuseIdentifier: "SelectedImageCell")
        
        if image != nil && arrImages.count == 0{
            uploadImage(imageToUpload: image)
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Collectionview Delegate & Datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedImageCell", for: indexPath) as! SelectedImageCell
        //cell.imgSelected.image = //arrImages[indexPath.item]
        cell.imgSelected?.sd_setImage(with: NSURL(string: arrImages[indexPath.row] as! String) as URL?, placeholderImage:UIImage(named:""))
        
        if isRemoveTapped{
            cell.btnDelete.isHidden = false
            YTAnimation.vibrateAnimation(cell)
        }else{
            cell.btnDelete.isHidden = true
            cell.layer.removeAnimation(forKey: "shake")
            
        }
        
        cell.btnDelete.layer.cornerRadius = cell.btnDelete.frame.size.width/2
        cell.btnDelete.layer.borderColor = UIColor.white.cgColor
        cell.btnDelete.layer.borderWidth = 1
        cell.btnDelete.tag = indexPath.item
        cell.btnDelete.addTarget(self, action: #selector(AddPhotoVC.deleteImage), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        if indexPath.item == 0{
            let rect = UIScreen.main.bounds
            return CGSize(width: (rect.size.width), height: (rect.size.width/2 + 50))
        }else{
            let rect = UIScreen.main.bounds
            return CGSize(width: (rect.size.width/3), height: (rect.size.width/3))
        }
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
    func removeImageFromCollectionView()
    {
        self.arrImages.removeObject(at: self.nSelectedIndex)
        self.arrRoomImageIds.removeObject(at: self.nSelectedIndex)
        self.delegate?.RoomImageAdded(arrImgs:self.arrImages.mutableCopy() as! NSArray, arrImgIds:self.arrRoomImageIds.mutableCopy() as! NSArray)
        isRemoveTapped = false
        self.collectionImages.deleteItems(at: [IndexPath(item: nSelectedIndex, section: 0)])
        self.btnEdit.isHidden = (self.arrImages.count > 0) ? false : true
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
    @IBAction func btnEditClicked(_ sender: UIButton) {
        if btnEdit.titleLabel?.text == edit {
            isRemoveTapped = true
            btnEdit.setTitle(done, for: .normal)
        } else {
            isRemoveTapped = false
            btnEdit.setTitle(edit, for: .normal)
        }
        collectionImages.reloadData()
    }
    @IBAction func btnbackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddPhotosClicked(_ sender: UIButton) {
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
    func deleteImage(_ sender:UIButton!){
        nSelectedIndex = sender.tag
        deletePhoto(strImgId: arrRoomImageIds[nSelectedIndex] as! String)
    }
    
    //MARK: - Api Call
    func uploadImage(imageToUpload: UIImage){
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        params.setValue(PostKey.image, forKey: PostKey.postType)
        params.setValue(imageToUpload, forKey: PostKey.imageData)
        params.setValue(listModel.room_id, forKey: "room_id")
        let fileName = (listModel.room_id) + ".jpg"
        params.setValue(fileName, forKey: PostKey.filename)
        ServerAPI.sharedInstance.makeCall(requestMethod: "POST", apiName: API_UPLOAD_ROOM_IMAGE, params: params, isTokenRequired: true, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                ProgressHud.shared.Animation = false
                if(error != nil){
                    showToastMessage(error!, isSuccess: false)
                }else{
                    let res = res as! NSDictionary
                    if res["image_urls"] != nil {
                        let imgUrl:String = res["image_urls"] as! String
                        let imgId:String = res["room_image_id"] as! String
                        self.arrImages.add(imgUrl)
                        self.arrRoomImageIds.add(imgId)
                        self.collectionImages.reloadData()
                        self.listModel.room_thumb_images.add(imgUrl)
                        self.listModel.room_thumb_image_ids.add(imgId)
                    }
                }
            }
        }) { (error) in
            print(error)
            ProgressHud.shared.Animation = false
        }
    }
    func deletePhoto(strImgId: String){
        ProgressHud.shared.Animation = true
        let params = NSMutableDictionary()
        params.setValue(listModel.room_id, forKey: "room_id")
        params.setValue(strImgId, forKey: "image_id")
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_UPLOAD_ROOM_IMAGE, params: params, isTokenRequired: true, forSuccessionBlock: { (res, error) in
            DispatchQueue.main.async {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    self.removeImageFromCollectionView()
                }
                ProgressHud.shared.Animation = false
            }
        }) { (error) in
            print(error)
            ProgressHud.shared.Animation = false
        }
    }
    
    //MARK: - Memeory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
