//
//  DayInterfaceController.swift
//  MJournal
//
//  Created by Michael on 07.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class DayInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var table: WKInterfaceTable!
    
    @IBOutlet var noLessonsGroup: WKInterfaceGroup!
    
    var sheduleParser = SheduleParser()
    
    let currentDay = Time.getDay()
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

    }
    
    override func didAppear() {
        super.didAppear()
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if let day = applicationContext["currentDay"] as? Day {
            let subjects = day.allNotEvenLessons()
            self.table.setNumberOfRows(subjects.count, withRowType: "SubjectRow")
            for (i, subj) in subjects.enumerate() {
                let controller = self.table.rowControllerAtIndex(i) as? SubjectRowController
                controller?.label.setText("\(i+1). " + (subj.name)!)
            }
        }
    }
}

class SubjectRowController: NSObject {
    @IBOutlet var label: WKInterfaceLabel!
}

