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

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        noLessonsLabel.setAttributedText(NSAttributedString(string: "Нет занятий!\nМожно поспать.", attributes: [NSFontAttributeName:UIFont.appSemiBoldFont()]))
        
        noLessonsGroup.setHidden(true)
        

    }
    
    override func didAppear() {
        super.didAppear()
        
    }
    
    override func willActivate() {
        super.willActivate()
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
            if session.reachable {
                
                session.sendMessage([:], replyHandler: {(response: [String:AnyObject]) -> Void in
                    
                    if let lessons = response["currentDay"] as? [String] {
                        if lessons.count == 0 {
                            self.noLessonsGroup.setHidden(false)
                        }
                        self.table.setNumberOfRows(lessons.count, withRowType: "SubjectRow")
                        for (i, subj) in lessons.enumerate() {
                            let controller = self.table.rowControllerAtIndex(i) as? SubjectRowController
                            controller?.lessonName = subj
                        }
                    }
                    }, errorHandler: nil)
            }
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        if segueIdentifier == "More_Info_Even" {
            
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

