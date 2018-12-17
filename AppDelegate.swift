//
//  AppDelegate.swift
//  Arheb
//
//  Created on 5/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import CoreData
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var strRoomID:String?
    var nSelectedIndex : Int = 0
    var arrWishList = [WishListModel]()
    var mimimumPrice = 0
    var maximumPrice = 700
    var isFromMap = false //Filter view present from map or explore
    var isWishListCreated =  false
    var currentLanguage = "en"
    var phoneNoDetail = [PhoneNoModel]()
    var isFromProfilePage = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if(UserDefaults.standard.object(forKey: UserDefaultKey.kHostorTravel) == nil){
            setNsuserDefaultValue(value: HostOrTravel.travel, key: UserDefaultKey.kHostorTravel)
        }
        let vc = ArhebTabbar()
        vc.selectedIndex = 0
//                let vc1 = PhotoUploadVC(nibName: "PhotoUploadVC", bundle: nil)
        
//        let vc1 = PhoneVerificationVC(nibName: "PhoneVerificationVC", bundle: nil)
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses = [ReservationHistoryVC.self,AddMessageVC.self]
        
        STOREVALUE(value: "", keyname: USER_LONGITUDE)
        STOREVALUE(value: "", keyname: USER_LATITUDE)
        STOREVALUE(value: "", keyname: USER_LOCATION)
        if(GETVALUE(USER_LANGUAGE) == ""){
            STOREVALUE(value: english, keyname: USER_LANGUAGE)
        }
        if (UserDefaults.standard.object(forKey: USER_CURRENCY) == nil) {
            STOREVALUE(value: "USD $", keyname: USER_CURRENCY)
        }
        if (UserDefaults.standard.object(forKey: USER_CURRENCY_SYMBOL) == nil) {
            STOREVALUE(value: "$", keyname: USER_CURRENCY_SYMBOL)
        }
        if (UserDefaults.standard.object(forKey: USER_CURRENCY_SYMBOL_ORG) == nil) {
            STOREVALUE(value: "&#36;", keyname: USER_CURRENCY_SYMBOL_ORG)
        }
        if (UserDefaults.standard.object(forKey: USER_CURRENCY_ORG) == nil) {
            STOREVALUE(value: "USD", keyname: USER_CURRENCY_ORG)
        }
        
        currentLanguage = getDefaultLanguage()
        
        if(UserDefaults.standard.bool(forKey: UserDefaultKey.kLoggedIn)) {
            getPhoneNumbers()
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    // MARK: - Google Signin Delegate Method
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlOpen = url.absoluteString
        var version = Bundle.main.infoDictionary?["FacebookAppID"] as? String
        version = String(format:"fb%@",version!)
        if (urlOpen as NSString).range(of:version!).location != NSNotFound {
            let handled = FBSDKApplicationDelegate.sharedInstance().application(app,open:url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication]as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation] as? String)
            return handled
        }
        else
        {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let urlOpen = url.absoluteString
        //        print(urlOpen)
        var version = Bundle.main.infoDictionary?["FacebookAppID"] as? String
        version = String(format:"fb%@",version!)
        if (urlOpen as NSString).range(of:version!).location != NSNotFound {
            let handled = FBSDKApplicationDelegate.sharedInstance().application(application,open:url, sourceApplication: sourceApplication, annotation: annotation)
            return handled
        }
        else
        {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Arheb")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func getDefaultLanguage() -> String{
        if(UserDefaults.standard.object(forKey: "AppLanguage") != nil){
            let code = UserDefaults.standard.object(forKey: "AppLanguage") as! String
            return code
        }else{
            return "en"}
    }
    
    
    //Get hpone Numbers
    func getPhoneNumbers() {
        let params = NSMutableDictionary()
        ServerAPI.sharedInstance.makeCall(requestMethod: "GET", apiName: API_GET_PHONE_NUMBER, params: params, isTokenRequired: true, forSuccessionBlock: { (response, error) in
            DispatchQueue.main.async {
                if(error != nil) {
                    
                }else{
                    if(response != nil) {
                        let resDic = response as! NSDictionary
                        let dicRes = resDic.value(forKey: "users_phone_numbers") as! NSArray
                        appDelegate?.phoneNoDetail = PhoneNoModel().initiatePhoneData(arrRes: dicRes)
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
            }
        }
    }
    
}

