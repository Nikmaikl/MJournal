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
    
    var sheduleParser = SheduleParser()
    
    var evenLessons: [String]?
    var notEvenlessons: [String]?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        noLessonsLabel.setAttributedText(NSAttributedString(string: "Нет занятий!\nМожно поспать.", attributes: [NSFontAttributeName:UIFont.appSemiBoldFont()]))
        
        noLessonsGroup.setHidden(false)
//        if WCSession.isSupported() {
//            let session = WCSession.default()
//            session.delegate = self
//            session.activate()
//            if session.isReachable {
//            }
//        }
//        if WCSession.isSupported() {
//            let session = WCSession.default()
//            session.delegate = self
//            session.activate()
//            if session.isReachable {
//                session.sendMessage([:], replyHandler: {(response: [String:Any]) -> Void in
//                    
//                    if let notEvenlessons = response["notEvenLessons"] as? [String] {
//                        if notEvenlessons.count == 0 {
//                            self.noLessonsGroup.setHidden(false)
//                            UserDefaults.standard.setValue(self.notEvenlessons, forKey: "evenLessons")
//                            UserDefaults.standard.synchronize()
//                        }
//                        self.updateWithLessons(notEvenlessons)
//                    }
//                    
//                    if let evenLessons = response["evenLessons"] as? [String] {
//                        self.evenLessons = evenLessons
//                        UserDefaults.standard.setValue(self.evenLessons, forKey: "evenLessons")
//                        UserDefaults.standard.synchronize()
//                    }
//                    
//                    }, errorHandler: nil)
//            }
//        }
    }
    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(watchOS 2.2, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }

    
    override func didAppear() {
        super.didAppear()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    func updateWithLessons(_ lessons: [String]) {
        if lessons.count == 0 {
            self.noLessonsGroup.setHidden(false)
        }
        self.table.setNumberOfRows(lessons.count, withRowType: "SubjectRow")
        for (i, subj) in lessons.enumerated() {
            let controller = self.table.rowController(at: i) as? SubjectRowController
            controller?.lessonName = subj
        }

    }
    
    private func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        if let notEvenLessons = message["notEvenLessons"] as? [String] {
            updateWithLessons(notEvenLessons)
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
}

