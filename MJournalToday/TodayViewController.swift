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
        
        currentShedule.sizeToFit()
        
        if #available(iOS 10.0, *) {
            nowLabel.textColor = UIColor(red: 96/255, green: 99/255, blue: 98/255, alpha: 1.0)
            noCurrentShedule.textColor = UIColor(red: 96/255, green: 99/255, blue: 98/255, alpha: 1.0)
            currentShedule.textColor = UIColor(red: 96/255, green: 99/255, blue: 98/255, alpha: 1.0)
        } else {
            // or use some work around
        }
        
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
        
        nowLabel.font = UIFont.appSemiBoldFont(17)
        currentShedule.font = UIFont.appMediumFont()
        leadingLine.backgroundColor = UIColor.getColorForCell(withRow: Time.getDay(), alpha: 1.0)
        //96	99	98
        noCurrentShedule.isHidden = true
        currentShedule.isHidden = false
        leadingLine.isHidden = false
        nowLabel.isHidden = false
        
        currentShedule.text = ""
        
        for (i, lesson) in notEvenLessons.enumerated() {
            currentShedule.text = currentShedule.text! + "\(lesson.startTime!) - \(lesson.name!)"
            if i < evenLessons.count && Int(evenLessons[i].id!) == i && Time.isEvenWeek() {
                currentShedule.text = "\(evenLessons[i].name!)"
                if evenLessons[i].audience != nil && evenLessons[i].audience != "" {
                    currentShedule.text = currentShedule.text! + "   n\(evenLessons[i].audience!)\n"
                } else {
                    currentShedule.text = currentShedule.text! + "\n"
                }
            } else {
                if notEvenLessons[i].audience != nil && notEvenLessons[i].audience != "" {
                    currentShedule.text = currentShedule.text! + "   \(notEvenLessons[i].audience!)\n"
                } else {
                    currentShedule.text = currentShedule.text! + "\n"
                }
            }
        }
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        } else {
        }
    }
    
    func showNoLessons() {
        nowLabel.isHidden = true
        currentShedule.isHidden = true
        leadingLine.isHidden = true
        noCurrentShedule.isHidden = false
        noCurrentShedule.font = UIFont.appSemiBoldFont()
        noCurrentShedule.textAlignment = .center
        noCurrentShedule.text = "Сегодня занятий нет."
    }
    
    @IBAction func pressedOnWidget(_ sender: AnyObject) {
        let url = URL(string: "foo://")
        extensionContext?.open(url!, completionHandler: nil)
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        if Time.getDay() == -1 || notEvenLessons.count == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize
        }
        else {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 200)
        }
    }
}
