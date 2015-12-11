//
//  DaySheduleViewController.swift
//  MJournal
//
//  Created by Michael on 05.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit

class DaySheduleViewController: UITableViewController {

    var dayNumber: Int = 0
    var colorForBar: UIColor = UIColor.blackColor()
    
    var day: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = colorForBar
        self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SheduleParser.shedule.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubjectCell", forIndexPath: indexPath)
        let subject = SheduleParser.shedule[dayNumber][indexPath.row] as! String
        let room: String = String(RoomParser.rooms[subject]!)
        
        cell.textLabel!.text = String(indexPath.row+1) + ". " + subject
        cell.detailTextLabel!.text = "     " + String(TimetableParser.timetable["Regular"]![indexPath.row]["Start"] as! String) + " - " + String(TimetableParser.timetable["Regular"]![indexPath.row]["End"] as! String)
        if room != "0" {
            cell.detailTextLabel!.text! += ", каб. " + room
        }
        
        return cell
    }
}