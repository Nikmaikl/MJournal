//
//  MoreSettingsTableViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 13.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics

class MoreSettingsTableViewController: UITableViewController, PickerDelegate {
    
    var timeTable = [[String]]()
    
    var titlesForLessons = ["Первая", "Вторая", "Третья", "Четвертая", "Пятая", "Шестая", "Седьмая"]
    var oneLessonTime: Int!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = ["NSFontAttributeName": UIFont.appBoldFont(), "NSForegroundColorAttributeName": UIColor.white]
        
        navigationItem.rightBarButtonItem = nil
        
        footerButton.titleLabel!.font = UIFont.appMediumFont()
        
        oneLessonTime = UserDefaults.standard.integer(forKey: "OneLessonTime")
        
        navigationItem.rightBarButtonItem = !UserDefaults.standard.bool(forKey: "PassedOnboarding") ? UIBarButtonItem(image: UIImage(named: "rightArrow_icon"), style: .plain, target: self, action: #selector(nextStep)) : nil

        tableView.tableFooterView = nil
        
        var startTime = 60*8+30
        var endTime = startTime+oneLessonTime
        
        if let tt = UserDefaults.standard.value(forKey: "Timetable") as? [[String]] {
            timeTable = tt
        } else {
            for _ in 0 ..< 7 {
                var startHour = "\(startTime/60)"
                if startHour.characters.count < 2 { startHour = "0"+startHour }
                var startMin = "\(startTime%60)"
                if startMin.characters.count < 2 { startMin = "0"+startMin }
                
                var endHour = "\(endTime/60)"
                if endHour.characters.count < 2 { endHour = "0"+endHour }
                var endMin = "\(endTime%60)"
                if endMin.characters.count < 2 { endMin = "0"+endMin }
                
                timeTable.append(["\(startHour):\(startMin)", "\(endHour):\(endMin)"])
                startTime = endTime
                endTime += oneLessonTime
            }
            UserDefaults.standard.setValue(timeTable, forKey: "Timetable")
            UserDefaults.standard.synchronize()
        }
        
        tableView.register(UINib(nibName: "SheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "SheduleCell")
    }
    
    func nextStep() {
        UserDefaults.standard.set(true, forKey: "PassedOnboarding")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "GoToShedule", sender: nil)
    }
    
    @IBAction func footerButtonPressed(_ sender: AnyObject) {
        Analytics.logEvent("didPassWelcome", parameters: nil)
        UserDefaults.standard.set(true, forKey: "PassedOnboarding")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "GoToShedule", sender: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timeTable.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SheduleCell", for: indexPath) as? SheduleTableViewCell
        
        timeTable = UserDefaults.standard.value(forKey: "Timetable") as! [[String]]

        
        cell?.titleLabel.text = "\(titlesForLessons[(indexPath as NSIndexPath).row]) пара"

        cell?.id = (indexPath as NSIndexPath).row
        cell?.navigationController = self

        return cell!
    }

    @IBAction func addButtonPressed(_ sender: AnyObject) {
        timeTable.append(["23:50", "23:55"])
        UserDefaults.standard.set(timeTable, forKey: "Timetable")
        UserDefaults.standard.synchronize()
        tableView.reloadData()
        if tableView.numberOfRows(inSection: 0)+1 > 7 {
            navigationItem.rightBarButtonItem = nil
        }
    }
}
