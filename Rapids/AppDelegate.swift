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
    
    let PREF_FIRST_LAUNCH = "launchedBefore"
    static var firstLaunch: Bool = false
    
    // Define custom green color
    static let navColor = UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 65.0/255.0, alpha: 1)
    
    // Folders
    static let documentsFolder = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let tempFolder = documentsFolder.URLByAppendingPathComponent("temp", isDirectory: true)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // SETUP FOLDER STRUCTURES
        print("App Documents Folder Location: \(AppDelegate.documentsFolder.path!)")
        
        let fileManager = NSFileManager.defaultManager()
        let tempFolderPath = AppDelegate.tempFolder.path!
        if fileManager.fileExistsAtPath(tempFolderPath) {
            // Empty temp folder
            let enumerator = fileManager.enumeratorAtPath(tempFolderPath)
            while let file = enumerator?.nextObject() as? String {
                do {
                    try fileManager.removeItemAtURL(AppDelegate.tempFolder.URLByAppendingPathComponent(file))
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        } else {
            // Create temp folder
            do {
                try fileManager.createDirectoryAtPath(tempFolderPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        
        // SETUP NAVIGATION BAR
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.whiteColor()  // Back buttons and such
        navigationBarAppearace.barTintColor = AppDelegate.navColor  // Bar's background color
        
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]  // Title's text color
        
        // Sets title colour to white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //Set status bar text to white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // SETUP CALENDARVIEW
        CalendarView.daySelectedBackgroundColor = AppDelegate.navColor
        CalendarView.daySelectedTextColor = UIColor.whiteColor()
        CalendarView.todayBackgroundColor = UIColor(white: 0.0, alpha: 0.3)
        CalendarView.todayTextColor = UIColor.whiteColor()
        CalendarView.otherMonthBackgroundColor = UIColor.clearColor()
        //CalendarView.dayTextColor = AppDelegate.navColor
        CalendarView.dayBackgroundColor = UIColor.clearColor()
        //CalendarView.weekLabelTextColor = AppDelegate.navColor
        CalendarView.otherMonthTextColor = UIColor.lightGrayColor()
        
        // HANDLE FIRST LAUNCH
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey(PREF_FIRST_LAUNCH)
        if launchedBefore  {
            AppDelegate.firstLaunch = false
        }
        else {
            AppDelegate.firstLaunch = true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: PREF_FIRST_LAUNCH)
            CredentialsManager.sharedInstance.signOut()
        }
        
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

