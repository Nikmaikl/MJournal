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
    
    @IBOutlet weak var addSubjectButton: UIButton!
    @IBOutlet weak var addSubjectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.tintColor = colorForBar
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func editButtonPressed() {
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if editing {
            addSubjectView.hidden = false
        } else {
            addSubjectView.hidden = true
        }
        super.setEditing(editing, animated: animated)
    }
    
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SheduleParser.shedule.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            print(SheduleParser.shedule[dayNumber].count)
            tableView.beginUpdates()
            print(SheduleParser.shedule[dayNumber].count)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            SheduleParser.shedule[dayNumber].removeObjectAtIndex(indexPath.row)
            
            tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(0...1)), withRowAnimation: .Automatic)
            tableView.endUpdates()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }

    @IBAction func addSubject(sender: AnyObject) {
        SheduleParser.shedule[dayNumber].addObject("География")
        print(tableView.numberOfRowsInSection(0))
        print(SheduleParser.shedule[dayNumber].count)

        tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(0...0)), withRowAnimation: .Automatic)
//        tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(0...1)), withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubjectCell", forIndexPath: indexPath)
        let subject = SheduleParser.shedule[dayNumber][indexPath.row] as! String
        let room: String = String(RoomParser.rooms[subject]!)
        
        if let subjectCell = cell as? SubjectTableViewCell {
            subjectCell.colorForToday = colorForBar
            subjectCell.lesson = Lesson(name: subject, time: String(TimetableParser.timeTable["Regular"]![indexPath.row]["Start"] as! String) + " - \n" + String(TimetableParser.timeTable["Regular"]![indexPath.row]["End"] as! String), type: nil, place: nil, professor: nil)
        }
        
        
//        cell.textLabel!.text = String(indexPath.row+1) + ". " + subject
//        cell.detailTextLabel!.text = "     " + String(TimetableParser.timeTable["Regular"]![indexPath.row]["Start"] as! String) + " - " + String(TimetableParser.timeTable["Regular"]![indexPath.row]["End"] as! String)
        if room != "0" {
//            cell.detailTextLabel!.text! += ", каб. " + room
        }
        
        return cell
    }
}