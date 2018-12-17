//
//  AboutMeVC.swift
//  Arheb
//
//  Created on 6/2/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class AboutMeVC: UIViewController {

    @IBOutlet var txtVwAbout: UITextView!
    @IBOutlet var vwNav: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewcustomization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtVwAbout.becomeFirstResponder()
        txtVwAbout.text = EditProfileVC.objUser.about_me
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        txtVwAbout.resignFirstResponder()
    }
    
    //MARK: Customize the view
    func viewcustomization() {
        self.navigationController?.navigationBar.isHidden = true
        vwNav.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        EditProfileVC.objUser.about_me = txtVwAbout.text.trim()
        self.navigationController?.popViewController(animated: true)
    }
    

}
