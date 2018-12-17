//
//  ProgressHud.swift
//  Arheb
//
//  Created on 5/30/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import Foundation

class ProgressHud {
    
    static let shared = ProgressHud()
    private let vwMain = UIView(frame: UIScreen.main.bounds)
    private let vwOuter = UIView(frame: UIScreen.main.bounds)
    private let vwInner = UIView()
    private let imgLoader = UIImageView()
    private let imgLoader1 = UIImageView()
    private var timerAnimate = Timer()
    private var Next_Image = 1
    
    var Animation: Bool = false {
        didSet {
            if Animation {
                timerAnimate = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ProgressHud.onModifyImage), userInfo: nil, repeats: true)
                UIApplication.shared.keyWindow?.addSubview(vwMain)
                self.spinAnimation()
            } else {
                Next_Image = 1
                timerAnimate.invalidate()
                vwMain.removeFromSuperview()
            }
        }
    }
    
    init() {
        vwMain.backgroundColor = UIColor.clear
        
        vwOuter.backgroundColor = UIColor.black
        vwOuter.alpha = 0.6
        
        vwInner.frame.size = CGSize(width: 110, height: 110)
        imgLoader.frame.size = CGSize(width: 80, height: 80)
        imgLoader1.frame.size = CGSize(width: 80, height: 80)
        
        vwInner.center = vwOuter.center
        imgLoader.center = vwInner.center
        imgLoader1.center = vwInner.center
        
        vwInner.backgroundColor = UIColor.white
        vwInner.layer.cornerRadius = 8.0
        imgLoader.backgroundColor = UIColor.clear
        imgLoader1.backgroundColor = UIColor.clear
        
        vwMain.addSubview(vwOuter)
        vwMain.addSubview(vwInner)
        vwMain.addSubview(imgLoader)
        vwMain.addSubview(imgLoader1)
        
        self.onModifyImage()
    }
    
    private func spinAnimation() {
        var rotationAnimation: CABasicAnimation
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotationAnimation.toValue = Int(-(Double.pi * 1.0 * 1 * 1))
        rotationAnimation.duration = 0.5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = 500
        imgLoader.layer.add(rotationAnimation, forKey: "rotationAnimation")

        var rotationAnimation1: CABasicAnimation
        rotationAnimation1 = CABasicAnimation(keyPath: "transform.rotation.y")
        rotationAnimation1.toValue = Int(Double.pi * 1.0 * 1 * 1)
        rotationAnimation1.duration = 0.5
        rotationAnimation1.isCumulative = true
        rotationAnimation1.repeatCount = 500
        imgLoader1.layer.add(rotationAnimation1, forKey: "rotationAnimation")
}
    
    @objc func onModifyImage() {
        if Next_Image == 1 {
            imgLoader.image = UIImage(named: "loading_01")
            imgLoader1.image = UIImage(named: "loading_01")
            Next_Image = 2
        } else if Next_Image == 2 {
            imgLoader.image = UIImage(named: "loading_02")
            imgLoader1.image = UIImage(named: "loading_02")
            Next_Image = 3
        } else if Next_Image == 3 {
            imgLoader.image = UIImage(named: "loading_03")
            imgLoader1.image = UIImage(named: "loading_03")
            Next_Image = 4
        } else if Next_Image == 4 {
            imgLoader.image = UIImage(named: "loading_04")
            imgLoader1.image = UIImage(named: "loading_04")
            Next_Image = 1
        }
    }
}
