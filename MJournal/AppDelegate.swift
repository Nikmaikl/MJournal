//
//  AppDelegate.swift
//  MJournal
//
//  Created by Michael on 03.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit
import CoreData
import Firebase

import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("PassedOnboarding") {
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc = storyboard.instantiateViewControllerWithIdentifier("Onboarding")
            window?.rootViewController = vc
        }
        
        return true
    }
    
}