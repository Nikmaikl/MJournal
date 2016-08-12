//
//  DaySheduleViewController.swift
//  MJournal
//
//  Created by Michael on 05.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMobileAds

class DaySheduleViewController: UITableViewController, SavingLessonDelegate {
    
    var dayNumber: Int = 0
    
    @IBOutlet weak var addSubjectButton: UIButton!
    @IBOutlet weak var addSubjectView: UIView!
    @IBOutlet weak var blankListOfLessonsView: UIView!
    
    var standartLeftItem: UIBarButtonItem!
    var standartRightItem: UIBarButtonItem!
    
    var lpgr: UILongPressGestureRecognizer!
    
    var currentLongPressingRow: NSIndexPath? = nil
    
    var currentDay: Day!
    
    
    var colorForBar = UIColor(red: 76/255, green: 86/255, blue: 108/225, alpha: 1.0)
    
    
    var leftButtonItemCancel: UIBarButtonItem!
    var rightButtonItemOk: UIBarButtonItem!
    var rightbarItemEdit: UIBarButtonItem!
    
    @IBOutlet weak var noneSubjectsLabel: UILabel!
    
    var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftButtonItemCancel = UIBarButtonItem(image: UIImage(named: "Cancel_icon"), style: .Plain, target: self, action: #selector(cancelEditing))
        rightButtonItemOk = UIBarButtonItem(image: UIImage(named: "Ok_icon"), style: .Plain, target: self, action: #selector(saveLesson))
        rightbarItemEdit = UIBarButtonItem(image: UIImage(named: "Edit_icon"), style: .Plain, target: self, action: #selector(editButtonTapped))
        
        noneSubjectsLabel.font = UIFont.appMediumFont()
        addSubjectButton.titleLabel?.font = UIFont.appSemiBoldFont()
        
        CoreDataHelper.instance.save()
        
        standartLeftItem = navigationItem.leftBarButtonItem
        standartRightItem = rightbarItemEdit
        
        leftButtonItemCancel.setTitleTextAttributes(["NSFontAttributeName": UIFont.appMediumFont()], forState: .Normal)
        
        self.navigationController?.navigationBar.tintColor = colorForBar
        self.clearsSelectionOnViewWillAppear = true
        
        self.navigationItem.rightBarButtonItem = standartRightItem
        if tableView.numberOfRowsInSection(0) == 0 { self.navigationItem.rightBarButtonItem = nil}
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.1
        self.tableView.addGestureRecognizer(lpgr)
        
        
//        tableView.frame.size.height -= kGADAdSizeBanner.size.height*1.27
        

        
    }
    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        let newY = self.tableView.contentOffset.y + self.tableView.frame.size.height - banner.frame.size.height
//        let newFrame = CGRectMake(banner.frame.origin.x, newY, banner.frame.size.width, banner.frame.size.height)
//        self.banner.frame = newFrame
//        self.banner.frame = newFrame
//    }
    
    func saveLesson() {
        setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = rightbarItemEdit
    }
    
    func editButtonTapped() {
        setEditing(!tableView.editing, animated: true)
        if editing {
        } else {
        }
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
            tableView.tableFooterView = addSubjectView
            tableView.tableHeaderView = blankListOfLessonsView
            
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            tableView.rowHeight = 260
            tableView.beginUpdates()
            tableView.endUpdates()
            navigationItem.rightBarButtonItem = rightButtonItemOk
            
            if tableView.numberOfRowsInSection(0) == 1 {
                tableView.tableFooterView = nil
                navigationItem.leftBarButtonItem = nil
                self.navigationItem.setHidesBackButton(true, animated: true)
                if currentDay.allLessons().last?.name == nil {
                    navigationItem.rightBarButtonItem?.enabled = false
                }
            } else {
                tableView.tableFooterView = addSubjectView
                self.navigationItem.setHidesBackButton(true, animated: true)
            }
            
            if currentDay.allLessons().last?.name != nil {
                tableView.tableFooterView = addSubjectView
            }
            
            if tableView.numberOfRowsInSection(0)+1 > TimetableParser.timeTable.count {
                tableView.tableFooterView = nil
            }
        } else {
            tableView.rowHeight = 135
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.tableFooterView = nil
            navigationItem.leftBarButtonItem = standartLeftItem
            navigationItem.rightBarButtonItem?.title = nil
            navigationItem.rightBarButtonItem = rightbarItemEdit
            self.navigationItem.setHidesBackButton(false, animated: true)
        }
    }
    
    func cancelEditing() {
        setEditing(false, animated: true)
        CoreDataHelper.instance.context.deleteObject(currentDay.allLessons().last!)
        CoreDataHelper.instance.save()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
        if tableView.numberOfRowsInSection(0) == 0 {
            tableView.tableFooterView = addSubjectView
            navigationItem.rightBarButtonItem = nil
            tableView.tableHeaderView = blankListOfLessonsView
        } else {
            navigationItem.rightBarButtonItem = rightbarItemEdit
        }
    }
    
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        SheduleParser.shedule[dayNumber][destinationIndexPath.row] = SheduleParser.shedule[dayNumber][sourceIndexPath.row]
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDay.lessons!.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            CoreDataHelper.instance.context.deleteObject(currentDay.allLessons()[indexPath.row])
            CoreDataHelper.instance.save()
            tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(0...0)), withRowAnimation: .None)
            if tableView.numberOfRowsInSection(0)+1 >= TimetableParser.timeTable.count {
                tableView.tableFooterView = addSubjectView
            }
            if tableView.numberOfRowsInSection(0) == 0 {
                self.setEditing(false, animated: true)
                self.navigationItem.rightBarButtonItem = nil
                tableView.tableHeaderView = blankListOfLessonsView
                tableView.tableFooterView = addSubjectView
            } else {
                self.navigationItem.rightBarButtonItem = rightButtonItemOk
            }
        }
    }
    
    @IBAction func addSubject(sender: AnyObject) {
        let lesson = Lesson()
        lesson.startTime = String(TimetableParser.timeTable[currentDay.lessons!.count]["Start"] as! String)
        lesson.endTime = String(TimetableParser.timeTable[currentDay.lessons!.count]["End"] as! String)
        lesson.id = currentDay.lessons?.count
        lesson.day = currentDay
        
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        
        
        currentDay.lessons!.addObject(lesson)
        CoreDataHelper.instance.save()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
        
        
        if tableView.numberOfRowsInSection(0) == 1 && !tableView.editing {
            setEditing(true, animated: true)
        }
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: Int(lesson.id!), inSection: 0)) as? SubjectTableViewCell
        cell?.lessonNameField.becomeFirstResponder()
        
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
//                            self.performSegueWithIdentifier("ShowSubjectInfo", sender: subjectRow)
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
        
        if let subjectCell = cell as? SubjectTableViewCell {
            subjectCell.colorForToday = colorForBar
            subjectCell.lesson = currentDay.allLessons()[indexPath.row]
            subjectCell.navigationController = self
            if subjectCell.lesson?.name == nil {
            }
            return subjectCell
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? SubjectInfoTableViewController {
            if let cell = sender as? SubjectTableViewCell {
                destinationVC.lesson = cell.lesson
            }
        }
    }
}