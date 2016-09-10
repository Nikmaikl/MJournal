//
//  EvenDayInterfaceController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 31.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class EvenDayInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var table: WKInterfaceTable!
    
    @IBOutlet var noLessonsGroup: WKInterfaceGroup!
    
    @IBOutlet var noLessonsLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        noLessonsLabel.setAttributedText(NSAttributedString(string: "Нет занятий!\nМожно поспать.", attributes: [NSFontAttributeName:UIFont.appSemiBoldFont()]))
        
//        if WCSession.isSupported() {
//            let session = WCSession.defaultSession()
//            session.delegate = self
//            session.activateSession()
//            
//            if session.reachable {
//                
//                session.sendMessage([:], replyHandler: {(response: [String:AnyObject]) -> Void in
//                    
//                    if let evenLessons = response["evenLessons"] as? [String] {
//                        print(evenLessons)
//                        if evenLessons.count == 0 {
//                            self.noLessonsGroup.setHidden(false)
//                        }
//                        self.table.setNumberOfRows(evenLessons.count, withRowType: "EvenSubjectRow")
//                        for (i, subj) in evenLessons.enumerate() {
//                            let controller = self.table.rowControllerAtIndex(i) as? EvenSubjectRowController
//                            controller?.lessonName = subj
//                        }
//                    }
//                    }, errorHandler: nil)
//            }
//        }
        
    }
    
    override func didAppear() {
        super.didAppear()
        
        if let evenLessons = NSUserDefaults.standardUserDefaults().valueForKey("evenLessons") as? [String]{
            if evenLessons.count == 0 {
                self.noLessonsGroup.setHidden(false)
            }
            self.table.setNumberOfRows(evenLessons.count, withRowType: "EvenSubjectRow")
            for (i, subj) in evenLessons.enumerate() {
                let controller = self.table.rowControllerAtIndex(i) as? EvenSubjectRowController
                controller?.lessonName = subj
            }
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
}

class EvenSubjectRowController: NSObject {
    @IBOutlet var label: WKInterfaceLabel!
    
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
