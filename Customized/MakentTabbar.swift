//
//  ArhebTabbar.swift
//  Arheb
//
//  Created on 5/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ArhebTabbar: UITabBarController {
    
    var navSaved = UINavigationController()
    var navExplore = UINavigationController()
    var navTrips = UINavigationController()
    var navInbox = UINavigationController()
    var navProfile = UINavigationController()
    var navReservation = UINavigationController()
    var navCalnedar = UINavigationController()
    var navListing = UINavigationController()
    
    var savedVC = SavedVC()
    var exploreVC = ExploreVC()
    var tripsVC = TripsVC()
    var inboxVC = InboxVC()
    var profileVC = ProfileVC()
    var reservationVC = HostInboxVC()
    var calendarVC = SSCalendarTimeSelector()
    var listingVC = HostListingVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        UITabBar.appearance().tintColor =  UIColor(red: 0.0 / 255.0, green: 166.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
        UITabBar.appearance().barTintColor = UIColor.white
        
        savedVC = SavedVC(nibName: "SavedVC", bundle: nil)
        exploreVC = ExploreVC(nibName:"ExploreVC", bundle: nil)
        tripsVC = TripsVC(nibName: "TripsVC", bundle: nil)
        inboxVC = InboxVC(nibName: "InboxVC", bundle: nil)
        profileVC = ProfileVC(nibName: "ProfileVC", bundle: nil)
        reservationVC = HostInboxVC(nibName: "HostInboxVC", bundle: nil)
        calendarVC = SSCalendarTimeSelector(nibName: "SSCalendarTimeSelector", bundle: nil)
        calendarVC.optionSelectionType = SSCalendarTimeSelectorSelection.multiple
        calendarVC.optionMultipleSelectionGrouping = .pill
        listingVC = HostListingVC(nibName: "HostListingVC", bundle: nil)
        
        navExplore = UINavigationController(rootViewController: exploreVC)
        navSaved = UINavigationController(rootViewController: savedVC)
        navTrips = UINavigationController(rootViewController: tripsVC)
        navInbox = UINavigationController(rootViewController: inboxVC)
        navProfile = UINavigationController(rootViewController: profileVC)
        navReservation = UINavigationController(rootViewController: reservationVC)
        navCalnedar = UINavigationController(rootViewController: calendarVC)
        navListing = UINavigationController(rootViewController: listingVC)
        
        let iconSaved = UITabBarItem(title: TabbarTravel.titleSaved, image: #imageLiteral(resourceName: "saved"), selectedImage: #imageLiteral(resourceName: "saved"))
        let iconExplore = UITabBarItem(title:TabbarTravel.titleExplore, image: #imageLiteral(resourceName: "Explore"), selectedImage: #imageLiteral(resourceName: "Explore"))
        let iconTrips = UITabBarItem(title:TabbarTravel.titleTrips, image: #imageLiteral(resourceName: "Trips"), selectedImage: #imageLiteral(resourceName: "Trips"))
        let iconInbox = UITabBarItem(title:TabbarTravel.titleInbox, image: #imageLiteral(resourceName: "Inbox"), selectedImage: #imageLiteral(resourceName: "Inbox"))
        let iconProfile = UITabBarItem(title:TabbarTravel.titleProfile, image: #imageLiteral(resourceName: "Profile"), selectedImage: #imageLiteral(resourceName: "Profile"))
        let iconReservation = UITabBarItem(title:TabbarHost.titleReservation, image: #imageLiteral(resourceName: "Inbox"), selectedImage: #imageLiteral(resourceName: "Inbox"))
        let iconCalendar = UITabBarItem(title:TabbarHost.titleCalendar, image: #imageLiteral(resourceName: "hostcalendar"), selectedImage: #imageLiteral(resourceName: "hostcalendar"))
        let iconListing = UITabBarItem(title:TabbarHost.titleListing, image: #imageLiteral(resourceName: "Lisiting"), selectedImage: #imageLiteral(resourceName: "Lisiting"))
        
        
        exploreVC.tabBarItem = iconExplore
        savedVC.tabBarItem = iconSaved
        tripsVC.tabBarItem = iconTrips
        inboxVC.tabBarItem = iconInbox
        profileVC.tabBarItem = iconProfile
        reservationVC.tabBarItem = iconReservation
        calendarVC.tabBarItem = iconCalendar
        listingVC.tabBarItem = iconListing
        
        let Host:String = UserDefaults.standard.value(forKey: UserDefaultKey.kHostorTravel) as! String
        self.viewControllers = Host == HostOrTravel.host ? [navReservation,navCalnedar,navListing,navProfile] : [navExplore,navSaved,navTrips,navInbox,navProfile]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
