//
//  LoadWebView.swift
//  Arheb
//
//  Created on 01/06/17.
//  Copyright © 2017 Arheb. All rights reserved.
//

import UIKit

class LoadWebView: UIViewController, UIWebViewDelegate {

    @IBOutlet var webCommon: UIWebView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var vwNav: UIView!

    var strPageTitle = ""
    var strWebUrl = ""
    var strCancellationFlexible = ""

    // MARK: - UIViewController method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewcustomization()
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Customize the view
    func viewcustomization(){
        self.navigationController?.navigationBar.isHidden = true
        vwNav.layer.shadowColor = UIColor.lightGray.cgColor
        webCommon.delegate = self
        //Here set the url
        if strCancellationFlexible.characters.count>0 {
            webCommon.loadHTMLString(strCancellationFlexible, baseURL: nil)
        }else {
            let encodedUrl = strWebUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            webCommon.loadRequest(URLRequest(url: URL(string: encodedUrl!)!))
        }
        lblTitle.text = strPageTitle
    }

    // MARK: - UIWebViewDelegate method(s)
    func webViewDidStartLoad(_ webView: UIWebView) {
        ProgressHud.shared.Animation = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let res: String? = webView.stringByEvaluatingJavaScript(from: "document.getElementById('json').innerHTML")
        let tabbar:ArhebTabbar =  appDelegate?.window?.rootViewController as! ArhebTabbar
        if (res?.characters.count)! > 0
        {
            let data: NSData = res!.data(using: String.Encoding.utf8)! as NSData
            var items = NSDictionary()
            
            do
            {
                let jsonResult : Dictionary = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! NSDictionary as Dictionary
                
                items = jsonResult as NSDictionary
                if (items.count>0)
                {
                    if items["status_code"] != nil
                    {
                        if items["status_code"] as! NSString == "1" && items["success_message"] as! NSString == "Request Booking Send to Host"
                        {
                            let dict: [AnyHashable: Any] = [
                                "description" : items["success_message"] as! NSString
                            ]
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ResquestToBook"), object: self, userInfo: dict)
                            tabbar.selectedIndex = 2
                            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
                            showToastMessage((items["success_message"] as! NSString) as String, isSuccess: true)
                        }
                        else if items["status_code"] as! NSString == "1" && items["success_message"] as! NSString == "Payment Successfully Paid"
                        {
                            let dict: [AnyHashable: Any] = [
                                "description" : items["success_message"] as! NSString
                            ]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ResquestToBook"), object: self, userInfo: dict)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "roombooked"), object: self, userInfo: dict)
                            tabbar.selectedIndex = 2
                            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                            //  print(viewControllers.count)
                            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
                           showToastMessage((items["success_message"] as! NSString) as String, isSuccess: true)
                            
                        }
                        else // if items["status_code"] as! NSString == "1" && items["success_message"] as! NSString == "Payment Failed"
                        {
                            self.onBackTapped(self)
                            showToastMessage((items["success_message"] as! NSString) as String, isSuccess: false)
                        }
                        
                    }
                }
                else {
                }
            }
            catch _ {
            }
            
        }
        ProgressHud.shared.Animation = false
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if strPageTitle == instagram{
            checkRequestForCallbackURL(request: request)
        }
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        ProgressHud.shared.Animation = false
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Custom Method
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(InstagramKey.redirectUrl) {
            if(requestURLString.contains("#access_token=")){
                let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
                handleAuth(authToken: requestURLString.substring(from: range.upperBound))
                ProgressHud.shared.Animation = false
                self.navigationController?.popViewController(animated: true)
                return false;
            }
            
            
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
        let tokenDict:[String: String] = ["token" : authToken]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.instagramToken), object: nil, userInfo: tokenDict)
        print("Instagram authentication token ==", authToken)
    }
    

    // MARK:- Localization Method
    func localization() {
        self.lblTitle.text = title
    }

}
