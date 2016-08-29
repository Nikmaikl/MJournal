//
//  TodayViewController.swift
//  MJournalToday
//
//  Created by Michael on 06.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var currentShedule: UILabel!
    
    let currentDay = Time.getDay()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notEvenLessons = Day.allDays()[currentDay].allNotEvenLessons()
        
        if notEvenLessons.count == 0 {
            currentShedule.textAlignment = .Center
            currentShedule.text = "Сегодня нет занятий"
            return
        }
        
        for (i, lesson) in notEvenLessons.enumerate() {
            currentShedule.text = "\(i+1). \(lesson.name!)\n"
        }
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}