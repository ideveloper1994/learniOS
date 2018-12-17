//
//  WalletVC.swift
//  Arheb
//
//  Created on 6/22/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class WalletVC: UIViewController {

    @IBOutlet var vwNav: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewcustomization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Customize the view
    func viewcustomization(){
        self.navigationController?.navigationBar.isHidden = true
        vwNav.layer.shadowColor = UIColor.lightGray.cgColor
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
