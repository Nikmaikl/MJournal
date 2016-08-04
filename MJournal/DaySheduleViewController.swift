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
    var colorForBar: UIColor = UIColor(red: 76/255, green: 86/255, blue: 108/225, alpha: 1.0)
    
    var day: String?
    
    @IBOutlet weak var addSubjectButton: UIButton!
    @IBOutlet weak var addSubjectView: UIView!
    
    var lpgr: UILongPressGestureRecognizer!
    
    var currentLongPressingRow:NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = colorForBar
        self.clearsSelectionOnViewWillAppear = true
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if tableView.numberOfRowsInSection(0) == 0 { self.navigationItem.rightBarButtonItem?.enabled = false}
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.1
        self.tableView.addGestureRecognizer(lpgr)
    }
    
    func handleLongPress(lgr: UILongPressGestureRecognizer) {
        let p = lgr.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(p)
        
        if indexPath != nil && (currentLongPressingRow?.row == indexPath!.row || currentLongPressingRow == nil) {
            currentLongPressingRow = indexPath
            let cell = tableView!.cellForRowAtIndexPath(indexPath!)
            UIView.animateWithDuration(0.2, animations: {
                if lgr.state == .Ended {
                    cell!.transform = CGAffineTransformMakeScale(1, 1)
                } else {
                    cell!.transform = CGAffineTransformMakeScale(0.9, 0.9)
                }
                }, completion: { b->Void in
                    if lgr.state == .Ended {
                        self.currentLongPressingRow = nil
                    }
            })
        } else if (currentLongPressingRow != nil && (currentLongPressingRow?.row != indexPath?.row ||
            indexPath == nil)) {
            let cell = tableView!.cellForRowAtIndexPath(currentLongPressingRow!)
            UIView.animateWithDuration(0.2, animations: {
                cell!.transform = CGAffineTransformMakeScale(1, 1)
                self.currentLongPressingRow = nil
            })
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if tableView.numberOfRowsInSection(0) == 0 {
            addSubjectView.hidden = false
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing || (!editing && tableView.numberOfRowsInSection(0) == 0) {
            addSubjectView.hidden = false
        } else {
            addSubjectView.hidden = true
        }
    }
    
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        let destRow = destinationIndexPath.row
        
//        for (var i=0; i < SheduleParser.shedule[dayNumber].count-destRow-1; i+=1) {
//            SheduleParser.shedule[dayNumber][i] = SheduleParser.shedule[dayNumber][i+1]
//        }
        
        SheduleParser.shedule[dayNumber][destinationIndexPath.row] = SheduleParser.shedule[dayNumber][sourceIndexPath.row]
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SheduleParser.shedule[dayNumber].count
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
            
            SheduleParser.shedule[dayNumber].removeObjectAtIndex(indexPath.row)
            tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(0...0)), withRowAnimation: .None)
            if tableView.numberOfRowsInSection(0) == 0 {
                self.setEditing(false, animated: true)
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
            addSubjectView.hidden = false
            
        }
    }

    @IBAction func addSubject(sender: AnyObject) {
        SheduleParser.shedule[dayNumber].addObject("")
        tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(0...0)), withRowAnimation: .None)
//        addSubjectView.hidden = true
//        self.navigationItem.rightBarButtonItem?.enabled = false
        
        if tableView.numberOfRowsInSection(0) == 1 && !tableView.editing {
//            self.navigationItem.rightBarButtonItem?.enabled = true
            setEditing(true, animated: true)
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? SubjectTableViewCell
            cell?.lessonNameField.becomeFirstResponder()
        }
        
        if tableView.numberOfRowsInSection(0) == TimetableParser.timeTable["Regular"]!.count {
            addSubjectView.hidden = true
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = tableView.cellForRowAtIndexPath(indexPath)
        if let subjectRow = row as? SubjectTableViewCell {
            UIView.animateWithDuration(0.2, animations: {
                subjectRow.transform = CGAffineTransformMakeScale(0.85, 0.85)
                }, completion: { b->Void in
                    UIView.animateWithDuration(0.05, animations: {
                        subjectRow.transform = CGAffineTransformMakeScale(1, 1)
                        }, completion: { b->Void in
                            self.performSegueWithIdentifier("ShowSubjectInfo", sender: nil)
                        })
            })
        }
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if self.tableView.editing {return .Delete}
        return .None
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubjectCell", forIndexPath: indexPath)
        let subject = SheduleParser.shedule[dayNumber][indexPath.row] as! String
        
        if let subjectCell = cell as? SubjectTableViewCell {
            subjectCell.colorForToday = colorForBar
            if SheduleParser.shedule[dayNumber][indexPath.row] as! String == "" {
                subjectCell.lesson = Lesson(name: "", startTime: String(TimetableParser.timeTable["Regular"]![indexPath.row]["Start"] as! String), endTime: String(TimetableParser.timeTable["Regular"]![indexPath.row]["End"] as! String), type: nil, place: nil, professor: nil)
                return subjectCell
            }
            subjectCell.lesson = Lesson(name: subject, startTime: String(TimetableParser.timeTable["Regular"]![indexPath.row]["Start"] as! String), endTime: String(TimetableParser.timeTable["Regular"]![indexPath.row]["End"] as! String), type: nil, place: nil, professor: nil)
        }
        
        return cell
    }
}