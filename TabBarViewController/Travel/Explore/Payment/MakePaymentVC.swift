//
//  MakePaymentVC.swift
//  Arheb
//
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class MakePaymentVC: UIViewController {
    @IBOutlet var tableProfile: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var btnCreaditCard: UIButton!
    @IBOutlet var btnPayPal: UIButton!
    @IBOutlet var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        btnNext.alpha = 0.5
        btnNext.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func onPaymentTypeTapped(_ sender:UIButton!)
    {
        btnNext.alpha = 1.0
        btnNext.isUserInteractionEnabled = true
        
        let  userDefaults = UserDefaults.standard
        userDefaults.synchronize()
        
        if sender.tag == 11
        {
            userDefaults.set(btnCreaditCard.titleLabel?.text, forKey: "paymenttype")
            btnCreaditCard.setTitleColor(UIColor.white, for: .normal)
            btnPayPal.setTitleColor(UIColor.black, for: .normal)
        }
        else if sender.tag == 22
        {
            userDefaults.set("PayPal", forKey: "paymenttype")
            btnPayPal.setTitleColor(UIColor.white, for: .normal)
            btnCreaditCard.setTitleColor(UIColor.black, for: .normal)
        }
        else
        {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
