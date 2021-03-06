//
//  DaySheduleContainerViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 10.09.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class DaySheduleContainerViewController: UIViewController {

    @IBOutlet weak var daySheduleTableVC: UIView!
    
    var dayNumber: Int!
    var currentDay: Day!
    var colorForBar: UIColor!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    
    var actualDay: Date!
    
    var weekDayNumber: Int!
    
    @IBOutlet weak var timeHeaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeHeaderView.backgroundColor = UIColor.darkBackground()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.appBoldFont()]
        
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.darkBackground()
        navigationController?.navigationBar.isTranslucent = false
        
        if UserDefaults.standard.bool(forKey: "white_theme") {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.default
            self.navigationController?.navigationBar.tintColor = UIColor.black
        } else {
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
        
        dayLabel.textColor = UIColor.navigationBarTintColor()
        rightArrowButton.setTitleColor(UIColor.navigationBarTintColor(), for: UIControl.State())
        leftArrowButton.setTitleColor(UIColor.navigationBarTintColor(), for: UIControl.State())
        leftArrowButton.titleLabel?.textColor = UIColor.navigationBarTintColor()
        
        
        dayLabel.font = UIFont.appSemiBoldFont()
        dayLabel.text = createTimeForDay()
        
        leftArrowButton.titleLabel?.font = UIFont.appSemiBoldFont(30)
        rightArrowButton.titleLabel?.font = UIFont.appSemiBoldFont(30)
        
        if self.dayNumber-1 < 0 {
            self.leftArrowButton.isHidden = true
        }
        
        if self.dayNumber+1 >= Day.allDays().count {
            self.rightArrowButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTitleForWeek(week: Int) -> String {
        let months = ["января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"]
        return months[week-1]
    }

    var rightClicks = 0
    
    func createTimeForDay() -> String {
        var textForDayLabel = ""
        if Time.getDay() > dayNumber {
            textForDayLabel = "\(Time.getActualDay()-(abs(Time.getDay()-dayNumber)))"
        } else {
            textForDayLabel = "\(Time.getActualDay()+(abs(Time.getDay()-dayNumber)))"
        }
        
        textForDayLabel = "\(weekDayNumber!)"
        
        textForDayLabel += " " + getTitleForWeek(week: Time.getYesterDayMonth(daysToAdd: rightClicks, sinceDate: actualDay))
        
        return textForDayLabel
    }
    
    @IBAction func leftArrowButtonPressed(_ sender: AnyObject) {
        rightClicks -= 1
        UIView.animate(withDuration: 0.2, animations: {
            self.leftArrowButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }, completion: { b->Void in
                UIView.animate(withDuration: 0.05, animations: {
                    self.leftArrowButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: { b->Void in
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DaySheduleVC") as? DaySheduleViewController {
                            self.rightArrowButton.isHidden = false
                            self.dayNumber = self.dayNumber - 1
                            
                            self.weekDayNumber = Time.yesterDay(daysToAdd: self.rightClicks, sinceDay: self.actualDay)
                            vc.dayNumber = self.dayNumber
                            vc.currentDay = Day.allDays()[self.dayNumber]
                            vc.colorForBar = UIColor.getColorForCell(withRow: self.dayNumber, alpha: 1.0)
                            vc.customNavigationItem = self.navigationItem
                            
                            self.dayLabel.text = self.createTimeForDay()
                            self.title = NSLocalizedString(WeekDays.days[self.dayNumber], comment: "Day")
                            
                            vc.willMove(toParent: self)
                            self.daySheduleTableVC.addSubview(vc.view)
                            self.addChild(vc)
                            vc.didMove(toParent: self)
                            if self.dayNumber-1 < 0 {
                                self.leftArrowButton.isHidden = true
                            }
                        }
                })
        })


    }
    
    @IBAction func rightArrowButtonPressed(_ sender: AnyObject) {
        rightClicks += 1
        UIView.animate(withDuration: 0.2, animations: {
            self.rightArrowButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }, completion: { b->Void in
                UIView.animate(withDuration: 0.05, animations: {
                    self.rightArrowButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: { b->Void in

        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DaySheduleVC") as? DaySheduleViewController {
            self.leftArrowButton.isHidden = false
            self.dayNumber = self.dayNumber + 1
            self.weekDayNumber = Time.yesterDay(daysToAdd: self.rightClicks, sinceDay: self.actualDay)
            vc.dayNumber = self.dayNumber
            vc.currentDay = Day.allDays()[self.dayNumber]
            vc.colorForBar = UIColor.getColorForCell(withRow: self.dayNumber, alpha: 1.0)
            vc.customNavigationItem = self.navigationItem
            
            self.dayLabel.text = self.createTimeForDay()
            self.title = NSLocalizedString(WeekDays.days[self.dayNumber], comment: "Day")
            
            vc.willMove(toParent: self)
            self.daySheduleTableVC.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            if self.dayNumber+1 >= Day.allDays().count {
                self.rightArrowButton.isHidden = true
            }
        }
                })
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sheduleVC = segue.destination as? DaySheduleViewController {
            sheduleVC.dayNumber = self.dayNumber
            sheduleVC.currentDay = currentDay
            sheduleVC.colorForBar = colorForBar
            sheduleVC.customNavigationItem = self.navigationItem
        }
    }

}
