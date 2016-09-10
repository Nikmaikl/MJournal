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
        
        navigationController?.navigationBar.titleTextAttributes = ["NSFontAttributeName": UIFont.appBoldFont(), "NSForegroundColorAttributeName": UIColor.whiteColor()]
        
        navigationItem.rightBarButtonItem = nil
        
        footerButton.titleLabel!.font = UIFont.appMediumFont()
        
        oneLessonTime = NSUserDefaults.standardUserDefaults().integerForKey("OneLessonTime")
        
        navigationItem.rightBarButtonItem = !NSUserDefaults.standardUserDefaults().boolForKey("PassedOnboarding") ? UIBarButtonItem(image: UIImage(named: "rightArrow_icon"), style: .Plain, target: self, action: #selector(nextStep)) : nil

        tableView.tableFooterView = nil
        
        var startTime = 60*8+30
        var endTime = startTime+oneLessonTime
        
        if let tt = NSUserDefaults.standardUserDefaults().valueForKey("Timetable") as? [[String]] {
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
            NSUserDefaults.standardUserDefaults().setValue(timeTable, forKey: "Timetable")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        tableView.registerNib(UINib(nibName: "SheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "SheduleCell")
    }
    
    func nextStep() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PassedOnboarding")
        NSUserDefaults.standardUserDefaults().synchronize()
        performSegueWithIdentifier("GoToShedule", sender: nil)
    }
    
    @IBAction func footerButtonPressed(sender: AnyObject) {
        FIRAnalytics.logEventWithName("didPassWelcome", parameters: nil)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PassedOnboarding")
        NSUserDefaults.standardUserDefaults().synchronize()
        performSegueWithIdentifier("GoToShedule", sender: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timeTable.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SheduleCell", forIndexPath: indexPath) as? SheduleTableViewCell
        
        timeTable = NSUserDefaults.standardUserDefaults().valueForKey("Timetable") as! [[String]]

        
        cell?.titleLabel.text = "\(titlesForLessons[indexPath.row]) пара"

        cell?.id = indexPath.row
        cell?.navigationController = self

        return cell!
    }

    @IBAction func addButtonPressed(sender: AnyObject) {
        timeTable.append(["23:50", "23:55"])
        NSUserDefaults.standardUserDefaults().setObject(timeTable, forKey: "Timetable")
        NSUserDefaults.standardUserDefaults().synchronize()
        print(NSUserDefaults.standardUserDefaults().valueForKey("Timetable") as! [[String]])
        tableView.reloadData()
        if tableView.numberOfRowsInSection(0)+1 > 7 {
            navigationItem.rightBarButtonItem = nil
        }
    }
}
