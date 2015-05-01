//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Twelker on Apr/26/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//
//  Changed after Udacity code review:
//  - added a constructor to the Meme.swift structure
//  - added (programmatically) an "Action" system toolbar button to the detail view, in order to send the meme again and again
//  - remove superclass methods from the code in case no custom logic is added
//  - implement practice to always call superclass method and with same parameters as the override is invoked
//  - textFieldShouldReturn method: return true, not false (see Apple doc)
//  - improve view shifting up and down following Udacity comments
//  - add save to / restore from user default data
//  - delete rows from table (via table view and via collection view), to remove memes that you are no longer interested in
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var memes = [Meme]() // Define the Shared Model here! Can be accessed from anywhere inside the project.
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let memesDataKey = "memesDataKey"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.restoreData()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.saveData()
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
    
    func saveData() {
        
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(memes), forKey: memesDataKey)
    }
    
    func restoreData() {

        if defaults.dataForKey(memesDataKey) != nil {
            memes = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.dataForKey(memesDataKey)!) as! [Meme]
        }

    }


}

