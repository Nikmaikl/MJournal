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
    @objc optional func shouldSaveLesson(_ id: Int)
}


class DaySheduleViewController: UITableViewController, WCSessionDelegate, LessonDelegate, RefreshLessonsDelegate {

    var dayNumber: Int = 0
    
    @IBOutlet var timeForWeekHeaderView: UIView!
    
    @IBOutlet weak var addSubjectButton: UIButton!
    @IBOutlet weak var addSubjectView: UIView!
    @IBOutlet weak var blankListOfLessonsView: UIView!
    
    var standartLeftItem: UIBarButtonItem!
    var standartRightItem: UIBarButtonItem!
    
    var lpgr: UILongPressGestureRecognizer!
    
    var currentLongPressingRow: IndexPath? = nil
    
    var currentDay: Day!
    
    var colorForBar = UIColor(red: 76/255, green: 86/255, blue: 108/225, alpha: 1.0)
    
    
    var leftButtonItemCancel: UIBarButtonItem!
    var leftButtonItemCalendar: UIBarButtonItem!
    var rightButtonItemOk: UIBarButtonItem!
    var rightbarItemEdit: UIBarButtonItem!
    
    @IBOutlet weak var noneSubjectsLabel: UILabel!
    
    var timeTable = [[String]]()
    var editingLessonTypeID: Int!
    
    var customNavigationItem: UINavigationItem!
    var customNavigationBar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeTable = UserDefaults.standard.value(forKey: "Timetable") as! [[String]]

        leftButtonItemCancel = UIBarButtonItem(image: UIImage(named: "Cancel_icon"), style: .plain, target: self, action: #selector(cancelEditing))
        leftButtonItemCalendar = UIBarButtonItem(image: UIImage(named: "Calendar_icon"), style: .plain, target: self, action: #selector(backToCalendar))
        rightButtonItemOk = UIBarButtonItem(image: UIImage(named: "Ok_icon"), style: .plain, target: self, action: #selector(saveLesson))
        rightbarItemEdit = UIBarButtonItem(image: UIImage(named: "Edit_icon"), style: .plain, target: self, action: #selector(editButtonTapped))
        
        noneSubjectsLabel.font = UIFont.appMediumFont()
        addSubjectButton.titleLabel?.font = UIFont.appSemiBoldFont()
        
        CoreDataHelper.instance.save()
        
        standartLeftItem = navigationItem.leftBarButtonItem
        standartRightItem = rightbarItemEdit
        
        leftButtonItemCancel.setTitleTextAttributes(["NSFontAttributeName": UIFont.appMediumFont()], for: UIControlState())
        
        self.navigationController?.navigationBar.tintColor = UIColor.white//UIColor(red: 105/255, green: 141/255, blue: 169/225, alpha: 1.0)//colorForBar
        self.clearsSelectionOnViewWillAppear = true
        
        self.customNavigationItem.rightBarButtonItem = standartRightItem
        if tableView.numberOfRows(inSection: 0) == 0 { self.customNavigationItem.rightBarButtonItem = nil}
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.1
//        self.tableView.addGestureRecognizer(lpgr)
        
        customNavigationItem.leftBarButtonItem = leftButtonItemCalendar
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        if #available(iOS 9.0, *) {
//            if WCSession.isSupported() {
//                let session = WCSession.default()
//                session.delegate = self
//                session.activate()
//            }
//        }
    }
    
    @available(iOS 9.0, *)
    private func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        var notEvenLessons = [String]()
        var evenLessons = [String]()
        if Time.getDay() == -1 {
            replyHandler(["notEvenLessons": notEvenLessons as AnyObject, "evenLessons": evenLessons as AnyObject])
            return
        }
        
        let sourceEvenLessons = Day.allDays()[Time.getDay()].allEvenLessons()
        
        for (i, lesson) in Day.allDays()[Time.getDay()].allNotEvenLessons().enumerated() {
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
        
        replyHandler(["notEvenLessons": notEvenLessons as AnyObject, "evenLessons": evenLessons as AnyObject])
    }
    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) {
        
    }

    
    func saveLesson() {
        setEditing(false, animated: true)
        customNavigationItem.rightBarButtonItem = rightbarItemEdit
        
        if #available(iOS 9.0, *) {
            if WCSession.default().isReachable {
                let notEvenLessons = getNotEvenLessonsInString()
                WCSession.default().sendMessage(["notEvenLessons": notEvenLessons], replyHandler: nil, errorHandler: nil)
            }
        }
    }
    
    func backToCalendar() {
        dismiss(animated: true, completion: nil)
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
        setEditing(!tableView.isEditing, animated: true)
        if isEditing {
        } else {
        }
    }
    
    func handleLongPress(_ lgr: UILongPressGestureRecognizer) {
        let p = lgr.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: p)
        
        if indexPath != nil && ((currentLongPressingRow as NSIndexPath?)?.row == (indexPath! as NSIndexPath).row || currentLongPressingRow == nil) {
            currentLongPressingRow = indexPath
            let cell = tableView!.cellForRow(at: indexPath!)
            UIView.animate(withDuration: 0.2, animations: {
                if lgr.state == .ended {
                    cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                } else {
                    cell!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }
                }, completion: { b->Void in
                    if lgr.state == .ended {
                        self.currentLongPressingRow = nil
                    }
            })
        } else if (currentLongPressingRow != nil && ((currentLongPressingRow as NSIndexPath?)?.row != (indexPath as NSIndexPath?)?.row ||
            indexPath == nil)) {
            let cell = tableView!.cellForRow(at: currentLongPressingRow!)
            UIView.animate(withDuration: 0.2, animations: {
                cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.currentLongPressingRow = nil
            })
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tableView.numberOfRows(inSection: 0) == 0 {
            tableView.tableFooterView = addSubjectView
            addSubjectButton.setTitle("+ Добавить", for: UIControlState())
            tableView.tableHeaderView = blankListOfLessonsView
        } else {
            tableView.reloadData()
            tableView.beginUpdates()
            tableView.endUpdates()
            //tableView.contentInset = UIEdgeInsetsMake(-timeForWeekHeaderView.frame.height, 0, 0, 0)
            //tableView.tableHeaderView = timeForWeekHeaderView
        }
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            tableView.beginUpdates()
            tableView.rowHeight = 260
            tableView.endUpdates()
            customNavigationItem.rightBarButtonItem = rightButtonItemOk
            
            if tableView.numberOfRows(inSection: 0) == 1 {
                tableView.tableFooterView = nil
                customNavigationItem.leftBarButtonItem = nil
                self.customNavigationItem.setHidesBackButton(true, animated: true)
                if currentDay.allNotEvenLessons().last?.name == nil {
                    customNavigationItem.rightBarButtonItem?.isEnabled = false
                }
            } else {
//                tableView.tableFooterView = addSubjectView
                UIView.performWithoutAnimation({
                    self.addSubjectButton.setTitle("+ Добавить еще", for: UIControlState())
                    self.addSubjectButton.layoutIfNeeded()
                })
                self.customNavigationItem.setHidesBackButton(true, animated: true)
            }
            
            if currentDay.allNotEvenLessons().last?.name != nil {
                tableView.tableFooterView = addSubjectView
                UIView.performWithoutAnimation({
                    self.addSubjectButton.setTitle("+ Добавить еще", for: UIControlState())
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
            customNavigationItem.leftBarButtonItem = leftButtonItemCalendar
            customNavigationItem.rightBarButtonItem?.title = nil
            customNavigationItem.rightBarButtonItem = rightbarItemEdit
            self.customNavigationItem.setHidesBackButton(false, animated: true)
        }
    }
    
    func cancelEditing() {
        setEditing(false, animated: true)
        CoreDataHelper.instance.context.delete(currentDay.allNotEvenLessons().last!)
        CoreDataHelper.instance.save()
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        if tableView.numberOfRows(inSection: 0) == 0 {
            tableView.tableFooterView = addSubjectView
            customNavigationItem.rightBarButtonItem = nil
            tableView.tableHeaderView = blankListOfLessonsView
        } else {
            customNavigationItem.rightBarButtonItem = rightbarItemEdit
        }
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        SheduleParser.shedule[dayNumber][(destinationIndexPath as NSIndexPath).row] = SheduleParser.shedule[dayNumber][(sourceIndexPath as NSIndexPath).row]
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDay.allNotEvenLessons().count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            CoreDataHelper.instance.context.delete(currentDay.allNotEvenLessons()[(indexPath as NSIndexPath).row])
            CoreDataHelper.instance.save()
            tableView.reloadSections(IndexSet(integersIn: 0...0), with: .none)
            if tableView.numberOfRows(inSection: 0)+1 >= timeTable.count {
                tableView.tableFooterView = addSubjectView 
            }
            if tableView.numberOfRows(inSection: 0) == 0 {
                self.setEditing(false, animated: true)
                self.customNavigationItem.rightBarButtonItem = nil
                tableView.tableHeaderView = blankListOfLessonsView
                tableView.tableFooterView = addSubjectView
                addSubjectButton.setTitle("+ Добавить", for: UIControlState())
            } else {
                self.customNavigationItem.rightBarButtonItem = rightButtonItemOk
            }
        }
    }
    
    var shouldExpandCell = true
    
    @IBAction func addSubject(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.2, animations: {
            self.addSubjectButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { b->Void in
                UIView.animate(withDuration: 0.05, animations: {
                    self.addSubjectButton.transform = CGAffineTransform(scaleX: 1, y: 1)
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
        lesson.id = currentDay.lessons?.count as NSNumber?
        if currentDay.allNotEvenLessons().count != 0 {
            var newNumber = Int((currentDay.allNotEvenLessons().last?.number)!)
            newNumber += 1
            lesson.number = newNumber as NSNumber?
        } else {
            lesson.number = 1
        }
        lesson.day = currentDay
        lesson.type = "Лекция"
        lesson.isEven = false
        
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        
        
        currentDay.lessons!.add(lesson)
        CoreDataHelper.instance.save()
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
        
        //if tableView.numberOfRowsInSection(0) == 1 && !tableView.editing {
        setEditing(true, animated: true)
        //}
        
        
        
        let cell = tableView.cellForRow(at: IndexPath(row: Int(lesson.id!), section: 0)) as? SubjectTableViewCell
        cell?.lessonNameField.becomeFirstResponder()
        cell?.cardViewTrailingConstraint.constant = 8
        cell?.cardView2.isHidden = true
        cell?.mainView.isHidden = true
        cell?.headerView.layer.cornerRadius = 10
        cell?.cardView.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isEditing {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell") as? SubjectTableViewCell
            if cell != nil {
                if !shouldExpandCell && currentDay.allNotEvenLessons()[(indexPath as NSIndexPath).row].name == nil{
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = tableView.cellForRow(at: indexPath)
        if let subjectRow = row as? SubjectTableViewCell {
            UIView.animate(withDuration: 0.2, animations: {
                if subjectRow.leftSwipeGesture.direction == .left {
                    subjectRow.cardView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                } else {
                    subjectRow.cardView2.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }
                }, completion: { b->Void in
                    UIView.animate(withDuration: 0.05, animations: {
                        if subjectRow.leftSwipeGesture.direction == .left {
                            subjectRow.cardView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        } else {
                            subjectRow.cardView2.transform = CGAffineTransform(scaleX: 1, y: 1)
                        }
                        
                        }, completion: { b->Void in
                            self.performSegue(withIdentifier: "ShowSubjectInfo", sender: subjectRow)
                    })
            })
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell")
        if cell == nil {
            tableView.register(UINib(nibName: "SubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "SubjectCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell")
        }

        if let subjectCell = cell as? SubjectTableViewCell {
            let lesson = currentDay.allNotEvenLessons()[(indexPath as NSIndexPath).row]
            lesson.id = (indexPath as NSIndexPath).row as NSNumber?
            
            CoreDataHelper.instance.save()
            
            subjectCell.colorForToday = colorForBar
            subjectCell.id = (indexPath as NSIndexPath).row
            if lesson.number == nil {
                subjectCell.lessonNumber = (indexPath as NSIndexPath).row+1
            } else {
                subjectCell.lessonNumber = Int((lesson.number)!)
            }
            subjectCell.lesson = lesson
            subjectCell.navigationController = self
            subjectCell.lessonDelegate = self
            let lesson2 = currentDay.getEvenLesson((indexPath as NSIndexPath).row)
            if !isEditing {
                if lesson2 != nil {
                    subjectCell.lesson2 = lesson2
                } else {
                    subjectCell.cardView2.isHidden = true
                }
                subjectCell.visualView.isHidden = true
            }
            
            return subjectCell
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SubjectInfoTableViewController {
            destinationVC.refreshDelegate = self
            if let cell = sender as? SubjectTableViewCell {
                if cell.leftSwipeGesture.direction == .left {
                    destinationVC.lesson = cell.lesson
                } else {
                    destinationVC.lesson = cell.lesson2
                }
            }
        }
    }
    @IBAction func addButtonInHeaderPressed(_ sender: AnyObject) {
    }
    
    
    
    func refresh() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
