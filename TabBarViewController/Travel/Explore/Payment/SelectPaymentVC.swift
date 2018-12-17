//
//  SelectPaymentVC.swift
//  Arheb
//
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class SelectPaymentVC: UIViewController {
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnAddPayment: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        btnAddPayment.layer.borderColor = UIColor.white.cgColor
        btnAddPayment.layer.borderWidth = 1.5
        btnAddPayment.layer.cornerRadius = btnAddPayment.frame.size.height/2
        btnSave.layer.cornerRadius = btnSave.frame.size.height/2
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func onSaveTapped(_ sender:UIButton!)
    {
        
    }
    
    @IBAction func onAddPaymentTapped(_ sender:UIButton!)
    {
        let vc = FilterAmenities(nibName: "FilterAmenities", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
