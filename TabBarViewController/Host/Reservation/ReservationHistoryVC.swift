//
//  ReservationHistoryVC.swift
//  Arheb
//
//  Created on 6/2/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit
import FLAnimatedImage

class ReservationHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIGestureRecognizerDelegate {
    
    // MARK:- IBOutlet(s)
    
    @IBOutlet weak var tblMessages: UITableView!
    @IBOutlet weak var txtEnterText: UITextView!
    @IBOutlet  var imgLoader : FLAnimatedImageView!
    @IBOutlet weak var lblTextPlaceholder: UILabel!
    @IBOutlet weak var lblMessageStatus: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var vwEnterText: UIView!
    @IBOutlet weak var vwInbox: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnBook:UIButton!
    @IBOutlet weak var btnPreApprove:UIButton!
    @IBOutlet weak var btnDecline:UIButton!
    @IBOutlet weak var heightVwEnterText: NSLayoutConstraint!
    @IBOutlet weak var bottomVwEnterText: NSLayoutConstraint!
    @IBOutlet weak var topLblDecline: NSLayoutConstraint!
    
    var arrMessage:[ConversationMessageModel] = [ConversationMessageModel]()
    var linePreviousNumber:Int!
    var isInbox:Bool = Bool()
    var objConModel:ConversationModel!
    var modelTripsInboxData : TripsModel!
    var modelInboxData : ReservationModel!
    var inboxData:InboxModel!
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
        registerCell()
        setDotLoader(imgLoader)
        getAllMessages()
        checkMessageStaus()
        linePreviousNumber = 1
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        tblMessages.addGestureRecognizer(tap)
        if isInbox {
            NotificationCenter.default.addObserver(self, selector:#selector(self.PreAcceptChanged), name: NSNotification.Name(rawValue: "preacceptchanged"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.declined), name: NSNotification.Name(rawValue: "CancelReservation"), object: nil)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ReservationHistoryVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ReservationHistoryVC.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func viewcustomization() {
        tblMessages.separatorColor = UIColor.clear
        tblMessages.estimatedRowHeight = 100
        tblMessages.rowHeight = UITableViewAutomaticDimension
        vwEnterText.layer.borderColor = UIColor.lightGray.cgColor
        self.automaticallyAdjustsScrollViewInsets = true
        btnPreApprove.setTitle(preApprove, for: .normal)
        btnDecline.setTitle(decline, for: .normal)
        btnBook.setTitle(book_now, for: .normal)
        btnSend.setTitle(send, for: .normal)
        lblTextPlaceholder.text = writeMessage
    }
    
    func registerCell(){
        tblMessages.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        tblMessages.register(UINib(nibName: "MessageReciever", bundle: nil), forCellReuseIdentifier: "MessageReciever")
    }
    
    //MARK: - Tableview delegate & datasource method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessage.count > 0 ? arrMessage.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let convMesModel:ConversationMessageModel = arrMessage[indexPath.row]
        if convMesModel.sender_user_name.isEmptyString() {
            let cell:MessageReciever = tblMessages.dequeueReusableCell(withIdentifier: "MessageReciever") as! MessageReciever
            cell.displayMessageText(convMesModel: convMesModel)
            cell.btnReciever.addTarget(self,action: #selector(self.recieverProfileClicked), for: .touchUpInside)
            return cell
        } else {
            let cell:MessageCell = tblMessages.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
            cell.btnSender.addTarget(self,action: #selector(self.senderProfileClicked), for: .touchUpInside)
            cell.displayMessageText(convMesModel: convMesModel)
            return cell
        }
    }
    
    //MARK: - keyboardNotification Method
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomVwEnterText.constant = keyboardSize.height
            UIView.performWithoutAnimation {
                tblMessages.contentOffset.y += keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomVwEnterText.constant = 0
            UIView.performWithoutAnimation {
                tblMessages.contentOffset.y -= keyboardSize.height
            }
        }
    }
    
    //MARK: - Textview Delegate Method(s)
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(range.location == 0 && text.isEmptyString()){
            disableBtnSend()
            return false
        } else {
            let line = calculateLineOfTextView()
            if line != 5 && line == linePreviousNumber+1 {
                linePreviousNumber = line
                heightVwEnterText.constant = heightVwEnterText.constant + 10
            }
            enableBtnSend()
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > Arheb.maxEnterText {
            textView.text.removeAll()
        }
        if textView.text.isEmptyString() {
            disableBtnSend()
        } else {
            enableBtnSend()
        }
    }
    
    //MARK: - Notification Method
    
    func PreAcceptChanged() {
        inboxData.message_status = pre_accepted
        checkMessageStaus()
        getAllMessages()
    }
    
    func declined() {
        inboxData.message_status = "Declined"
        checkMessageStaus()
        getAllMessages()
    }
    
    //MARK: - Gesture Recognizer Method
    func handleTap(_ sender: UITapGestureRecognizer) {
        txtEnterText.resignFirstResponder()
    }
    
    //MARK: - Custom Method
    
    func scrollToLast() {
        let indexPathScroll = IndexPath(row: arrMessage.count - 1, section: 0)
        tblMessages.scrollToRow(at: indexPathScroll, at: .bottom, animated: false)
    }
    
    func calculateLineOfTextView() -> Int {
        let numLines:Int = Int(txtEnterText.contentSize.height / (txtEnterText.font?.lineHeight)!);
        return numLines
    }
    
    func enableBtnSend() {
        btnSend.setTitleColor(AppColor.sendBtnColor, for: .normal)
        btnSend.isUserInteractionEnabled = true
        lblTextPlaceholder.isHidden = true
    }
    
    func disableBtnSend() {
        btnSend.setTitleColor(AppColor.disableSendBtnColor, for: .normal)
        btnSend.isUserInteractionEnabled = false
        lblTextPlaceholder.isHidden = false
        txtEnterText.text.removeAll()
        heightVwEnterText.constant = 70
    }
    
    func checkMessageStaus()   {
        if(isInbox){
            lblMessageStatus.text = inboxData.message_status
            lblUserName.text = inboxData.host_user_name
            lblMessageStatus.backgroundColor = UIColor.clear
            lblMessageStatus.textColor = UIColor.darkGray
            let objUser = getUserDetails()
            if objUser?.user_id != inboxData.request_user_id {
                if inboxData.message_status == pre_accepted || inboxData.message_status == inquiry {
                    topLblDecline.constant = -44
                    vwInbox.isHidden = true
                    btnBook.isHidden = (inboxData.booking_status == available) ? false : true
                } else {
                    topLblDecline.constant = -44
                    vwInbox.isHidden = true
                }
            } else {
                if inboxData.message_status == inquiry {
                    topLblDecline.constant = 0
                    vwInbox.isHidden = false
                } else {
                    topLblDecline.constant = -44
                    vwInbox.isHidden = true
                }
            }
        } else {
            lblMessageStatus.text = modelInboxData != nil ? modelInboxData.trip_status : modelTripsInboxData.trip_status
            lblUserName.text = modelInboxData != nil ? modelInboxData.guest_user_name: modelTripsInboxData.user_name
            lblMessageStatus.backgroundColor = AppColor.mainColor
            lblMessageStatus.textColor = UIColor.white
            topLblDecline.constant = -44
            vwInbox.isHidden = true
        }
    }
    
    //MARK: - Api calling
    
    func getAllMessages() {
        let param = NSMutableDictionary()
        if isInbox {
            param.setValue(inboxData.host_user_id, forKey: Messages.hostUserID)
            param.setValue(inboxData.reservation_id, forKey: Messages.reservationID)
        } else {
            if modelInboxData != nil {
                param.setValue(modelInboxData.guest_users_id, forKey: Messages.hostUserID)
                param.setValue(modelInboxData.reservation_id, forKey: Messages.reservationID)
            } else {
                param.setValue(modelTripsInboxData.host_user_id, forKey: Messages.hostUserID)
                param.setValue(modelTripsInboxData.reservation_id, forKey: Messages.reservationID)
            }
        }
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_CONVERSATION_LIST, params: param, isTokenRequired: true, forSuccessionBlock: { (res, error) in
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    self.imgLoader.isHidden = true
                    let dictRes:NSDictionary = res as! NSDictionary;
                    self.objConModel = ConversationModel()
                    self.objConModel =  self.objConModel.addResponseToConversation(res: dictRes)
                    if self.arrMessage.count>0 {
                        self.arrMessage.removeAll()
                    }
                    self.arrMessage = self.objConModel.arrMessages
                    self.tblMessages.reloadData()
                    self.tblMessages.setNeedsLayout()
                    self.tblMessages.layoutIfNeeded()
                    self.tblMessages.reloadData()
                    self.scrollToLast()
                }
            }
        }) { (error) in
            self.imgLoader.isHidden = true
            print(error)
        }
    }
    
    func sendMessage(txt:String) {
        let param = NSMutableDictionary()
        if isInbox {
            param.setValue(inboxData.host_user_id, forKey: Messages.hostUserID)
            param.setValue(inboxData.reservation_id, forKey: Messages.reservationID)
            param.setValue(inboxData.room_id, forKey: Messages.roomId)
        } else {
            if modelInboxData != nil {
                param.setValue(modelInboxData.guest_users_id, forKey: Messages.hostUserID)
                param.setValue(modelInboxData.reservation_id, forKey: Messages.reservationID)
                param.setValue(modelInboxData.room_id, forKey: Messages.roomId)
            } else {
                param.setValue(modelTripsInboxData.host_user_id, forKey: Messages.hostUserID)
                param.setValue(modelTripsInboxData.reservation_id, forKey: Messages.reservationID)
                param.setValue(modelTripsInboxData.room_id, forKey: Messages.roomId)
            }
        }
        param.setValue(txt, forKey: Messages.message)
        param.setValue(Messages.messageTypeStatic, forKey: Messages.messageType)
        self.disableBtnSend()
        txtEnterText.resignFirstResponder()
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_SENDMESSAGE, params: param, isTokenRequired: true, forSuccessionBlock: { (res, error) in
            self.imgLoader.isHidden = true
            let dictRes:NSDictionary = res as! NSDictionary;
            OperationQueue.main.addOperation {
                if(error != nil){
                    showToastMessage(error!)
                }else{
                    let resDict:NSMutableDictionary = dictRes.mutableCopy() as! NSMutableDictionary
                    var objConMesModel = ConversationMessageModel()
                    resDict.setValue(self.objConModel.sender_thumb_image, forKey: "sender_thumb_image")
                    resDict.setValue(self.objConModel.sender_user_name, forKey: "sender_user_name")
                    objConMesModel =  objConMesModel.addSendMessage(res: resDict)
                    self.arrMessage.append(objConMesModel)
                    self.tblMessages.insertRows(at: [IndexPath(row: self.arrMessage.count-1, section: 0)], with: .none)
                    self.scrollToLast()
                }
            }
        }) { (error) in
            self.imgLoader.isHidden = true
            print(error)
        }
    }
    
    //MARK: - IBAction Method
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSendCicked(_ sender: Any) {
        self.imgLoader.isHidden = false
        sendMessage(txt: txtEnterText.text)
    }
    
    @IBAction func btnVwClicked(_ sender: Any) {
        print("vwTapped")
    }
    
    @IBAction func btnPreApproveClicked(_ sender:Any){
        let preAcceptVC = PreAcceptVC(nibName: "PreAcceptVC", bundle: nil)
        if isInbox {
            preAcceptVC.strReservationId = inboxData.reservation_id
        } else {
            preAcceptVC.strReservationId = modelInboxData != nil ? modelInboxData.reservation_id : modelTripsInboxData.reservation_id
        }
        preAcceptVC.strPageTitle = "Pre-Approve"
        self.navigationController?.pushViewController(preAcceptVC, animated: true)
    }
    
    @IBAction func btnDeclineClicked(_ sender:Any){
        let cancelVC = CancelReservationVC(nibName: "CancelReservationVC", bundle: nil)
        cancelVC.arrCancelTitles = [why_are_you_declining,i_do_not_feel_comfortable,my_listing_is_not_good,waiting_for_more_attractive_reservation,guest_is_asking_for_different_dates,this_message_is_spam,other]
        cancelVC.isInbox = self.isInbox
        cancelVC.strReservationId = inboxData.reservation_id
        cancelVC.strMethodName = API_PRE_APPROVAL_OR_DECLINE
        self.navigationController?.pushViewController(cancelVC, animated: true)
    }
    
    @IBAction func btnBookClicked(_ sender:Any){
        let viewWeb = LoadWebView(nibName: "LoadWebView", bundle: nil)
        viewWeb.hidesBottomBarWhenPushed = true
        viewWeb.strPageTitle = payment
        let authToken = KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken)
        viewWeb.strWebUrl = String(format:"%@%@?reservation_id=%@&token=%@",baseUrl,API_PAY_NOW,inboxData.reservation_id,authToken!)
        //        print(viewWeb.strWebUrl)
        self.navigationController?.pushViewController(viewWeb, animated: true)
    }
    
    func senderProfileClicked(){
        let vc = ProfileDetailVC(nibName: "ProfileDetailVC", bundle: nil)
        ProfileDetailVC.isProfileEdited = true
        vc.otherUserId = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func recieverProfileClicked(){
        let vc = ProfileDetailVC(nibName: "ProfileDetailVC", bundle: nil)
        ProfileDetailVC.isProfileEdited = true
        if isInbox {
            vc.otherUserId = inboxData.host_user_id
        } else {
            vc.otherUserId = modelInboxData != nil ? modelInboxData.guest_users_id : modelTripsInboxData.host_user_id
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
