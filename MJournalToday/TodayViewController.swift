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
    
    let currentDay = Time.getDay()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (i, lesson) in (Day.allDays()[currentDay].allLessons()).enumerate() {
            currentShedule.text = "\(i). \(lesson)"
        }
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    }
}
