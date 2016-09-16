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
import FirebaseAnalytics

import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        
        if !UserDefaults.standard.bool(forKey: "PassedOnboarding") {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "Onboarding")
            window?.rootViewController = vc
        }
        
        return true
    }
    
}
