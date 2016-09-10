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
        
    @IBOutlet weak var noCurrentShedule: UILabel!
    @IBOutlet weak var currentShedule: UILabel!
    @IBOutlet weak var leadingLine: UIView!
    @IBOutlet weak var nowLabel: UILabel!
    
    let currentDay = Time.getDay()
    var notEvenLessons: [Lesson]!
    var evenLessons: [Lesson]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Time.getDay() == -1 {
            showNoLessons()
            return
        }
        
        notEvenLessons = Day.allDays()[currentDay].allNotEvenLessons()
        evenLessons = Day.allDays()[currentDay].allEvenLessons()
        
        if notEvenLessons.count == 0 {
            showNoLessons()
            return
        }
        
        nowLabel.font = UIFont.appMediumFont(14)
        leadingLine.backgroundColor = UIColor.getColorForCell(withRow: Time.getDay(), alpha: 1.0)
        
        noCurrentShedule.hidden = true
        currentShedule.hidden = false
        leadingLine.hidden = false
        nowLabel.hidden = false
        
        currentShedule.text = ""
        
        for (i, lesson) in notEvenLessons.enumerate() {
            currentShedule.text = currentShedule.text! + "\(lesson.startTime!) - \(lesson.name!)"
            if i < evenLessons.count && evenLessons[i].id == i {
                currentShedule.text = currentShedule.text! + " | \(evenLessons[i].name!)\n"
            } else {
                currentShedule.text = currentShedule.text! + "\n"
            }
        }
    }
    
    func showNoLessons() {
        nowLabel.hidden = true
        currentShedule.hidden = true
        leadingLine.hidden = true
        noCurrentShedule.hidden = false
        noCurrentShedule.font = UIFont.appSemiBoldFont()
        noCurrentShedule.textAlignment = .Center
        noCurrentShedule.text = "Сегодня занятий нет."
    }
    
    @IBAction func pressedOnWidget(sender: AnyObject) {
        let url = NSURL(string: "foo://")
        extensionContext?.openURL(url!, completionHandler: nil)
        
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        if Time.getDay() == -1 || notEvenLessons.count == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
    }
}