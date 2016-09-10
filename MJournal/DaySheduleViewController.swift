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
import FirebaseAnalytics
import WatchConnectivity

@objc protocol LessonDelegate: class {
    optional func shouldSaveLesson(id: Int)
}


class DaySheduleViewController: UITableViewController, WCSessionDelegate, LessonDelegate, RefreshLessonsDelegate {
    
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
    
    var timeTable = [[String]]()
    var editingLessonTypeID: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeTable = NSUserDefaults.standardUserDefaults().valueForKey("Timetable") as! [[String]]

        leftButtonItemCancel = UIBarButtonItem(image: UIImage(named: "Cancel_icon"), style: .Plain, target: self, action: #selector(cancelEditing))
        rightButtonItemOk = UIBarButtonItem(image: UIImage(named: "Ok_icon"), style: .Plain, target: self, action: #selector(saveLesson))
        rightbarItemEdit = UIBarButtonItem(image: UIImage(named: "Edit_icon"), style: .Plain, target: self, action: #selector(editButtonTapped))
        
        noneSubjectsLabel.font = UIFont.appMediumFont()
        addSubjectButton.titleLabel?.font = UIFont.appSemiBoldFont()
        
        CoreDataHelper.instance.save()
        
        standartLeftItem = navigationItem.leftBarButtonItem
        standartRightItem = rightbarItemEdit
        
        leftButtonItemCancel.setTitleTextAttributes(["NSFontAttributeName": UIFont.appMediumFont()], forState: .Normal)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()//UIColor(red: 105/255, green: 141/255, blue: 169/225, alpha: 1.0)//colorForBar
        self.clearsSelectionOnViewWillAppear = true
        
        self.navigationItem.rightBarButtonItem = standartRightItem
        if tableView.numberOfRowsInSection(0) == 0 { self.navigationItem.rightBarButtonItem = nil}
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.1
//        self.tableView.addGestureRecognizer(lpgr)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if #available(iOS 9.0, *) {
            if WCSession.isSupported() {
                let session = WCSession.defaultSession()
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    @available(iOS 9.0, *)
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        var notEvenLessons = [String]()
        var evenLessons = [String]()
        if Time.getDay() == -1 {
            replyHandler(["notEvenLessons": notEvenLessons, "evenLessons": evenLessons])
            return
        }
        
        let sourceEvenLessons = Day.allDays()[Time.getDay()].allEvenLessons()
        
        for (i, lesson) in Day.allDays()[Time.getDay()].allNotEvenLessons().enumerate() {
            notEvenLessons.append(lesson.name!)
            if i < sourceEvenLessons.count {
                for evenLesson in sourceEvenLessons {
                    if Int(evenLesson.id!) == i {
                        evenLessons.append(evenLesson.name!)
                        break
                    } else {
                        evenLessons.append(lesson.name!)
                    }
                }
            } else {
                evenLessons.append(lesson.name!)
            }
        }
        
        replyHandler(["notEvenLessons": notEvenLessons, "evenLessons": evenLessons])
    }
    
    func saveLesson() {
        setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = rightbarItemEdit
        
        if #available(iOS 9.0, *) {
            if WCSession.defaultSession().reachable {
                let notEvenLessons = getNotEvenLessonsInString()
                WCSession.defaultSession().sendMessage(["notEvenLessons": notEvenLessons], replyHandler: nil, errorHandler: nil)
            }
        }
    }
    
    func getNotEvenLessonsInString() -> [String] {
        var notEvenLessons = [String]()
        for lesson in Day.allDays()[Time.getDay()].allNotEvenLessons() {
            notEvenLessons.append(lesson.name!)
        }
        return notEvenLessons
    }
    
    func geEvenLessonsInString() -> [String] {
        var evenLessons = [String]()
        for lesson in Day.allDays()[Time.getDay()].allEvenLessons() {
            evenLessons.append(lesson.name!)
        }
        return evenLessons
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
            addSubjectButton.setTitle("+ Добавить", forState: .Normal)
            tableView.tableHeaderView = blankListOfLessonsView
            
        }
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            tableView.beginUpdates()
            tableView.rowHeight = 260
            tableView.endUpdates()
            navigationItem.rightBarButtonItem = rightButtonItemOk
            
            if tableView.numberOfRowsInSection(0) == 1 {
                tableView.tableFooterView = nil
                navigationItem.leftBarButtonItem = nil
                self.navigationItem.setHidesBackButton(true, animated: true)
                if currentDay.allNotEvenLessons().last?.name == nil {
                    navigationItem.rightBarButtonItem?.enabled = false
                }
            } else {
//                tableView.tableFooterView = addSubjectView
                UIView.performWithoutAnimation({
                    self.addSubjectButton.setTitle("+ Добавить еще", forState: .Normal)
                    self.addSubjectButton.layoutIfNeeded()
                })
                self.navigationItem.setHidesBackButton(true, animated: true)
            }
            
            if currentDay.allNotEvenLessons().last?.name != nil {
                tableView.tableFooterView = addSubjectView
                UIView.performWithoutAnimation({
                    self.addSubjectButton.setTitle("+ Добавить еще", forState: .Normal)
                    self.addSubjectButton.layoutIfNeeded()
                })
            }
            
            if Int((currentDay.allNotEvenLessons().last?.number)!) >= timeTable.count {
                tableView.tableFooterView = nil
            }
        } else {
            tableView.beginUpdates()
            tableView.rowHeight = 135
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
        CoreDataHelper.instance.context.deleteObject(currentDay.allNotEvenLessons().last!)
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
        return currentDay.allNotEvenLessons().count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            CoreDataHelper.instance.context.deleteObject(currentDay.allNotEvenLessons()[indexPath.row])
            CoreDataHelper.instance.save()
            tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(0...0)), withRowAnimation: .None)
            if tableView.numberOfRowsInSection(0)+1 >= timeTable.count {
                tableView.tableFooterView = addSubjectView 
            }
            if tableView.numberOfRowsInSection(0) == 0 {
                self.setEditing(false, animated: true)
                self.navigationItem.rightBarButtonItem = nil
                tableView.tableHeaderView = blankListOfLessonsView
                tableView.tableFooterView = addSubjectView
                addSubjectButton.setTitle("+ Добавить", forState: .Normal)
            } else {
                self.navigationItem.rightBarButtonItem = rightButtonItemOk
            }
        }
    }
    
    var shouldExpandCell = true
    
    @IBAction func addSubject(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: {
            self.addSubjectButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
            }, completion: { b->Void in
                UIView.animateWithDuration(0.05, animations: {
                    self.addSubjectButton.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: { b->Void in
                        self.addNewSubject()
                })
        })
    }
    
    func addNewSubject() {
        shouldExpandCell = false
        //        if tableView.numberOfRowsInSection(0)+1 >= Int((currentDay.allNotEvenLessons().last?.number)!)-1 {
        //            tableView.tableFooterView = nil
        //        }
        
        let lesson = Lesson()
        lesson.startTime = String(timeTable[currentDay.allNotEvenLessons().count][0])
        lesson.endTime = String(timeTable[currentDay.allNotEvenLessons().count][1])
        lesson.id = currentDay.lessons?.count
        if currentDay.allNotEvenLessons().count != 0 {
            lesson.number = Int((currentDay.allNotEvenLessons().last?.number)!)+1
        } else {
            lesson.number = 1
        }
        lesson.day = currentDay
        lesson.type = "Лекция"
        lesson.isEven = false
        
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        
        
        currentDay.lessons!.addObject(lesson)
        CoreDataHelper.instance.save()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
        
        
        //if tableView.numberOfRowsInSection(0) == 1 && !tableView.editing {
        setEditing(true, animated: true)
        //}
        
        
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: Int(lesson.id!), inSection: 0)) as? SubjectTableViewCell
        cell?.lessonNameField.becomeFirstResponder()
        cell?.cardViewTrailingConstraint.constant = 8
        cell?.cardView2.hidden = true
        cell?.mainView.hidden = true
        cell?.headerView.layer.cornerRadius = 10
        cell?.cardView.backgroundColor = UIColor.clearColor()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if editing {
            let cell = tableView.dequeueReusableCellWithIdentifier("SubjectCell") as? SubjectTableViewCell
            if cell != nil {
                if !shouldExpandCell && currentDay.allNotEvenLessons()[indexPath.row].name == nil{
                    return 80
                } else {
                    return 260
                }
            }
            return 0
        } else {
            return 135
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = tableView.cellForRowAtIndexPath(indexPath)
        if let subjectRow = row as? SubjectTableViewCell {
            UIView.animateWithDuration(0.2, animations: {
                if subjectRow.leftSwipeGesture.direction == .Left {
                    subjectRow.cardView.transform = CGAffineTransformMakeScale(0.85, 0.85)
                } else {
                    subjectRow.cardView2.transform = CGAffineTransformMakeScale(0.85, 0.85)
                }
                }, completion: { b->Void in
                    UIView.animateWithDuration(0.05, animations: {
                        if subjectRow.leftSwipeGesture.direction == .Left {
                            subjectRow.cardView.transform = CGAffineTransformMakeScale(1, 1)
                        } else {
                            subjectRow.cardView2.transform = CGAffineTransformMakeScale(1, 1)
                        }
                        
                        }, completion: { b->Void in
                            self.performSegueWithIdentifier("ShowSubjectInfo", sender: subjectRow)
                    })
            })
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SubjectCell")
        if cell == nil {
            tableView.registerNib(UINib(nibName: "SubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "SubjectCell")
            cell = tableView.dequeueReusableCellWithIdentifier("SubjectCell")
        }

        if let subjectCell = cell as? SubjectTableViewCell {
            let lesson = currentDay.allNotEvenLessons()[indexPath.row]
            lesson.id = indexPath.row
            
            CoreDataHelper.instance.save()
            
            subjectCell.colorForToday = colorForBar
            subjectCell.id = indexPath.row
            if lesson.number == nil {
                subjectCell.lessonNumber = indexPath.row+1
            } else {
                subjectCell.lessonNumber = Int((lesson.number)!)
            }
            subjectCell.lesson = lesson
            subjectCell.navigationController = self
            subjectCell.lessonDelegate = self
            let lesson2 = currentDay.getEvenLesson(indexPath.row)
            if !editing {
                if lesson2 != nil {
                    subjectCell.lesson2 = lesson2
                } else {
                    subjectCell.cardView2.hidden = true
                }
                subjectCell.visualView.hidden = true
            }
            
            return subjectCell
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? SubjectInfoTableViewController {
            destinationVC.refreshDelegate = self
            if let cell = sender as? SubjectTableViewCell {
                if cell.leftSwipeGesture.direction == .Left {
                    destinationVC.lesson = cell.lesson
                } else {
                    destinationVC.lesson = cell.lesson2
                }
            }
        }
        if let destinationVC = segue.destinationViewController as? SelectionViewController {
            destinationVC.editingLessonTypeID = editingLessonTypeID
        }
    }
    @IBAction func addButtonInHeaderPressed(sender: AnyObject) {
    }
    
    
    
    func refresh() {
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}