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
        if #available(iOS 9.0, *) {
            if WCSession.isSupported() {
                let session = WCSession.default()
                session.delegate = self
                session.activate()
            }
        }
        
        
        FIRApp.configure()
        

        if !UserDefaults.standard.bool(forKey: "PassedOnboarding") {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "Onboarding")
            window?.rootViewController = vc
        }
        

        return true
    }
    
}

//@available(iOS 9.3, *)
//extension AppDelegate: WCSessionDelegate {
//    
////    private func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
////        var notEvenLessons = [String]()
////        var evenLessons = [String]()
////        for lesson in Day.allDays()[Time.getDay()].allNotEvenLessons() {
////            notEvenLessons.append(lesson.name!)
////        }
////        for lesson in Day.allDays()[Time.getDay()].allEvenLessons() {
////            evenLessons.append(lesson.name!)
////        }
////        replyHandler(["notEvenLessons": notEvenLessons as AnyObject, "evenLessons": evenLessons as AnyObject])
////    }
//    
//    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        
//    }
//    
//    public func sessionDidDeactivate(_ session: WCSession) {
//        
//    }
//    
//    public func sessionDidBecomeInactive(_ session: WCSession) {
//        
//    }
//}

@available(iOS 9.3, *)
extension AppDelegate: WCSessionDelegate {
        private func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
            var lessons = [String]()
            
            if !Time.isEvenWeek() {
                for lesson in Day.allDays()[Time.getDay()].allNotEvenLessons() {
                    lessons.append(lesson.name!)
                }
            } else {
                for (i, lesson) in Day.allDays()[Time.getDay()].allNotEvenLessons().enumerated() {
                    if Day.allDays()[Time.getDay()].allEvenLessons().count < i && Day.allDays()[Time.getDay()].allEvenLessons()[i].id == Day.allDays()[Time.getDay()].allNotEvenLessons()[i].id {
                        lessons.append(Day.allDays()[Time.getDay()].allEvenLessons()[i].name!)
                    } else {
                        lessons.append(lesson.name!)
                    }
                }
            }

            replyHandler(["lessons": lessons as AnyObject])
        }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
