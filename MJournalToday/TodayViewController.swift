//
//  TodayViewController.swift
//  MJournalToday
//
//  Created by Michael on 06.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit
import NotificationCenter

let userDef = NSUserDefaults()

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var currentShedule: UILabel!
    
    var timeTable = TimetableParser()

    override func viewDidLoad() {
        super.viewDidLoad()
        timeTable.getCurrentSubject({
            subj, nextSubj in
            self.currentShedule.text = "Сейчас: " + subj + "\nСледующий: " + nextSubj
        })
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    }
}
