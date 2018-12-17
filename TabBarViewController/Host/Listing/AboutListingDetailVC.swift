//
//  AboutListingDetailVC.swift
//  Arheb
//
//  Created on 03/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class AboutListingDetailVC: UIViewController,UITextViewDelegate {
    @IBOutlet var lblPlaceHolder: UILabel!

    @IBOutlet var ConstLbHeight: NSLayoutConstraint!
    @IBOutlet var txvDescription: UITextView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lblTitle: UILabel!
    
    
    var titleLabel = String()
    var descriptionText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        btnSave.setTitle(save, for: .normal)
        txvDescription.delegate = self
        btnSave.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = titleLabel
        lblPlaceHolder.text = descriptionText
        let height = heightForView(text: descriptionText, font: lblPlaceHolder.font, width: lblPlaceHolder.frame.size.width)
        if height > 18{
            ConstLbHeight.constant = height
        }
        else{
            ConstLbHeight.constant = 21
        }

    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                if(text == "\n") {
                    textView.resignFirstResponder()
                    return false
                }
                return true
    }

    func textViewDidChange(_ textView: UITextView) {
        let length =  txvDescription.text?.characters.count
        if length!>0
        {
            btnSave.isHidden = false
            lblPlaceHolder.isHidden = true
        }
        else
        {
            btnSave.isHidden = true
            lblPlaceHolder.isHidden = false
        }
        
    }
    

    @IBAction func btnSaveClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
