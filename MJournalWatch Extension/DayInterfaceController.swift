//
//  DayInterfaceController.swift
//  MJournal
//
//  Created by Michael on 07.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import WatchKit
import Foundation

class DayInterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let dayNumber = context as? Int
        
        let subjects = SheduleParser.shedule[dayNumber!]
        
        table.setNumberOfRows(subjects.count, withRowType: "SubjectRow")
        for (i, subj) in subjects.enumerate() {
            let controller = table.rowControllerAtIndex(i) as? SubjectRowController
            controller?.label.setText("\(i+1). " + (subj as! String))
        }
    }
}

class SubjectRowController: NSObject {
    @IBOutlet var label: WKInterfaceLabel!
}

