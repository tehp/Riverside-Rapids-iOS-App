//
//  AppDelegate.swift
//  Rapids
//
//  Created by Noah on 2016-02-04.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import UIKit
import CalendarView


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    //Define custom green color
    static let navColor = UIColor(red: 0/255, green: 69/255, blue: 41/255, alpha: 1)
    static let navColorLight = UIColor(red: 0/255, green: 120/255, blue: 41/255, alpha: 1)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()  // Back buttons and such
        navigationBarAppearace.barTintColor = AppDelegate.navColor  // Bar's background color
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]  // Title's text color
        
        CalendarView.daySelectedBackgroundColor = AppDelegate.navColor
        CalendarView.daySelectedTextColor = UIColor.whiteColor()
        CalendarView.todayBackgroundColor = UIColor(white: 0.0, alpha: 0.3)
        CalendarView.todayTextColor = UIColor.whiteColor()
        CalendarView.otherMonthBackgroundColor = UIColor.clearColor()
        CalendarView.otherMonthTextColor = AppDelegate.navColor
        CalendarView.dayTextColor = AppDelegate.navColor
        CalendarView.dayBackgroundColor = UIColor.clearColor()
        CalendarView.weekLabelTextColor = AppDelegate.navColor
        
        // Sets title colour to white 
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            
        //Set status bar text to white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Customizations for Navigation Bar -Mac
        UINavigationBar.appearance().barTintColor = AppDelegate.navColor
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

