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
    
    @IBOutlet var noLessonsLabel: WKInterfaceLabel!
    
    @IBOutlet var errorLabel: WKInterfaceLabel!
    
    
    var sheduleParser = SheduleParser()
    
    var evenLessons: [String]?
    var notEvenlessons: [String]?
    
    var session: WCSession!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        noLessonsLabel.setAttributedText(NSAttributedString(string: "Нет занятий!\nМожно поспать.", attributes: [NSFontAttributeName:UIFont.appSemiBoldFont()]))
        
        if WCSession.isSupported() {
            session = WCSession.default()
            
            session.delegate = self
            session.activate()
            
            noLessonsGroup.setHidden(true)
            errorLabel.setHidden(true)
            
        }
        print("Watch app awake")
    }
    @IBAction func refreshMenuItemPressed() {
        updateLessonInfo(WCSession.default())
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //if activationState == .activated {
            print("Watch app did complete Activate")
            updateLessonInfo(session)
        //}
    }
    
    func updateLessonInfo(_ session: WCSession) {
        if session.isReachable {
            session.sendMessage([:], replyHandler: {(response: [String:Any]) -> Void in
                if let lessons = response["lessons"] as? [String] {
                    if let rooms = response["rooms"] as? [String] {
                        if lessons.count != 0 {
                            self.updateWithLessons(lessons, rooms: rooms)
                            UserDefaults.standard.setValue(lessons, forKey: "lessons")
                            UserDefaults.standard.synchronize()
                        } else {
                            self.noLessonsGroup.setHidden(false)
                        }
                    }
                }
            }, errorHandler: nil)
        } else {
            errorLabel.setHidden(false)
        }
    }
    
    override func didAppear() {
        super.didAppear()
    
        print("Watch app appeared")
    }
    
    override func willActivate() {
        super.willActivate()
        print("Watch app will Activate")
        print(WCSession.default())
    }
    
    func updateWithLessons(_ lessons: [String], rooms: [String]) {
        if lessons.count == 0 {
            self.noLessonsGroup.setHidden(false)
        }
        self.table.setNumberOfRows(lessons.count, withRowType: "SubjectRow")
        for (i, subj) in lessons.enumerated() {
            let controller = self.table.rowController(at: i) as? SubjectRowController
            controller?.lessonName = subj
            controller?.roomNumber = rooms[i]
        }

    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        
        if segueIdentifier == "More_Info_Even" {
            if notEvenlessons?.count == 0 {
                return nil
            } else {
                return notEvenlessons
            }
        }
        return nil
    }
}

class SubjectRowController: NSObject {
    @IBOutlet var label: WKInterfaceLabel! {
        didSet {
        }
    }
    
    @IBOutlet var roomLabel: WKInterfaceLabel!
    
    @IBOutlet var subjectGroup: WKInterfaceGroup! {
        didSet {
            subjectGroup.setBackgroundColor(UIColor.getColorForCell(withRow: Time.getDay(), alpha: 1.0))
        }
    }
    
    var lessonName: String! {
        didSet {
            label.setAttributedText(NSAttributedString(string: (lessonName), attributes: [NSFontAttributeName:UIFont.appMediumFont()]))
        }
    }
    
    var roomNumber: String! {
        didSet {
            roomLabel.setAttributedText(NSAttributedString(string: (roomNumber), attributes: [NSFontAttributeName:UIFont.appMediumFont()]))
        }
    }
}

