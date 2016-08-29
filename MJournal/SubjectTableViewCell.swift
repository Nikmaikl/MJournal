//
//  SubjectTableViewCell.swift
//  MJournal
//
//  Created by Michael Nikolaev on 26.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

@objc protocol PickerDelegate: class {
    optional func saveTypeLesson(type: String)
    optional func saveTime(time: String)
}

class SubjectTableViewCell: UITableViewCell, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, PickerDelegate {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var professorNameTextField: UITextField!
    
    @IBOutlet weak var startTimeHour: UILabel!
    @IBOutlet weak var startTimeMin: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var lessonNameField: UITextField!
    @IBOutlet weak var audienceNumberField: UITextField!
    @IBOutlet weak var lessonTypeButton: UIButton!
    
    @IBOutlet weak var numberOfLessonButton: UIButton!
    @IBOutlet weak var timeView: UIView!
    
    
    //Second Card
    
    @IBOutlet weak var headerView2: UIView!
    @IBOutlet weak var cardView2: UIView!
    
    @IBOutlet weak var placeLabel2: UILabel!
    @IBOutlet weak var professorNameTextField2: UITextField!
    
    @IBOutlet weak var startTimeHour2: UILabel!
    @IBOutlet weak var startTimeMin2: UILabel!
    @IBOutlet weak var endTime2: UILabel!
    
    @IBOutlet weak var lessonNameField2: UITextField!
    @IBOutlet weak var audienceNumberField2: UITextField!
    @IBOutlet weak var lessonTypeButton2: UIButton!
    @IBOutlet weak var timeView2: UIView!
    
    @IBOutlet weak var lessonType2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lessonType2TrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lessonName2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var audienceNumberField2HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var professor2CenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var professor2TrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var professor2LeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var professor2TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var professor2HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var visualView: UIVisualEffectView!
    
    @IBOutlet weak var cardsEqualWidth: NSLayoutConstraint!
    
    @IBOutlet weak var numberOfLesson: UIView!
    @IBOutlet weak var numberOfLessonLabel: UILabel!
    
    
    //End Of Second Card
    
    @IBOutlet weak var lessonTypeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lessonTypeTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lessonNameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var audienceNumberFieldHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var professorCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var professorTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var professorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var professorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var professorHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var cardViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewLeadingToTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cardView2WidthConstraint: NSLayoutConstraint!
    
    
    var navigationController: DaySheduleViewController!
    
    var id: Int!
    
    var colorForToday: UIColor! {
        didSet {
            headerView.backgroundColor = colorForToday
            headerView2.backgroundColor = headerView.backgroundColor
        }
    }
    
    var timeTable: [[String]]!
    
    weak var lessonDelegate: LessonDelegate?
    
    var lessonNumber: Int!
    
    var lesson: Lesson? {
        didSet {
            navigationController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("DaySheduleVC") as? DaySheduleViewController
            
            timeTable = NSUserDefaults.standardUserDefaults().valueForKey("Timetable") as! [[String]]
            
            lessonNameField.text = lesson!.name

            lessonNameField.font = UIFont.appSemiBoldFont()
            lessonNameField2.font = lessonNameField.font
            startTimeHour.font = UIFont.appSemiBoldFont()
            startTimeHour2.font = startTimeHour.font
            startTimeMin.font = UIFont.appSemiBoldFont(10)
            startTimeMin2.font = startTimeMin.font
            
            endTime.font = UIFont.appMediumFont(13)
            endTime2.font = endTime.font
            audienceNumberField.font = UIFont.appSemiBoldFont()
            audienceNumberField2.font = audienceNumberField.font
            professorNameTextField.font = UIFont.appMediumFont(14)
            professorNameTextField2.font = professorNameTextField.font
            
            lesson?.startTime = timeTable[lessonNumber-1][0]
            lesson?.endTime = timeTable[lessonNumber-1][1]
            
            
            if lesson!.number == nil {
                lesson?.number = lessonNumber
            }
            
            numberOfLessonLabel.text = "\(lesson!.number!)"
            
            lessonNameField.backgroundColor = getBakColorForTextFieldWhileEditing()
            lessonNameField2.backgroundColor = lessonNameField.backgroundColor
            
            setupLessonTime()
            
            audienceNumberField.text = lesson?.audience
            professorNameTextField.text = lesson?.professor
            lessonTypeButton.setTitle(lesson?.type?.uppercaseString, forState: .Normal)
            lessonTypeButton2.setTitle(lessonTypeButton.titleLabel!.text, forState: .Normal)
            
            numberOfLesson.backgroundColor = getBakColorForTextFieldWhileEditing()
            numberOfLessonLabel.textColor = UIColor.whiteColor()
            
            if lesson?.name != nil {
                mainView.hidden = false
            } else {
                mainView.hidden = false
            }
            
        }
    }
    
    var lesson2: Lesson? {
        didSet {
            if lesson2?.name != nil {
                lessonNameField2.text = lesson2!.name
                audienceNumberField2.text = lesson2!.audience
                professorNameTextField2.text = lesson2!.professor
                visualView.hidden = true
                showCardView2()
            } else {
                lessonNameField2.text = nil
                audienceNumberField2.text = nil
                professorNameTextField2.text = nil
            }
        }
    }
    
    var leftSwipeGesture: UISwipeGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        numberOfLesson.layer.masksToBounds = false
        
        lessonNameField.delegate = self
        audienceNumberField.delegate = self
        professorNameTextField.delegate = self
        
        lessonNameField2.delegate = self
        audienceNumberField2.delegate = self
        professorNameTextField2.delegate = self

        mainView.hidden = true

        leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwiped))
        leftSwipeGesture.direction = .Left
        self.addGestureRecognizer(leftSwipeGesture)
        
        cardView2.alpha = 0.2
        leftSwipeGesture.delegate = self
        timeView2.alpha = 0
        
        if lesson != nil {
            lesson?.startTime = timeTable[id][0]
            lesson?.endTime = timeTable[id][1]
        }
        if lesson2 != nil {
            lesson2?.startTime = lesson?.startTime
            lesson2?.endTime = lesson?.endTime
        }
    }
    
    func setupLessonTime() {
        var hour = lesson!.startTime!
        var min = lesson!.startTime!
        hour.removeRange(lesson!.startTime!.endIndex.advancedBy(-3)..<lesson!.startTime!.endIndex)
        min.removeRange(lesson!.startTime!.startIndex..<lesson!.startTime!.startIndex.advancedBy(3))
        startTimeHour.text = hour
        startTimeHour2.text = hour
        startTimeMin.text = min
        startTimeMin2.text = min
        endTime.text = lesson!.endTime
        endTime2.text = endTime.text
    }
    
    func saveTypeLesson(type: String) {
        if navigationController.title == "Четная неделя" {
            lesson2?.type = type
            lessonTypeButton2.setTitle(type.uppercaseString, forState: .Normal)
        } else {
            lesson?.type = type
            lessonTypeButton.setTitle(type.uppercaseString, forState: .Normal)
        }
        CoreDataHelper.instance.save()
    }
    
    func showCardView2() {
        self.cardsEqualWidth.active = false
        
        self.cardViewTrailingConstraint.active = false
        self.cardViewLeadingConstraint.active = false
        self.cardViewWidthConstraint.constant = cardView.frame.width
        self.cardView2WidthConstraint.constant = cardView.frame.width
        self.cardViewWidthConstraint.active = true
        self.cardView2WidthConstraint.active = true
        self.cardViewLeadingToTrailingConstraint.active = true
        navigationController.title = "Четная неделя"
        navigationController.tableView.tableFooterView = nil
        timeView2.hidden = false
        placeLabel2.hidden = false
        professorNameTextField2.hidden = false
        lessonNameField2.hidden = false
        audienceNumberField2.hidden = false
        lessonTypeButton2.hidden = false
    }
    
    func leftSwiped(swipe: UISwipeGestureRecognizer) {
        if lesson2 == nil && !editing { return }
        if leftSwipeGesture.direction == .Left {
            showCardView2()
        } else {
            self.cardView2WidthConstraint.active = false
            self.cardViewWidthConstraint.active = false
            self.cardViewLeadingToTrailingConstraint.active = false
            self.cardsEqualWidth.active = true
            self.cardViewTrailingConstraint.active = true
            self.cardViewLeadingConstraint.active = true
            
            cardsEqualWidth.active = true
            navigationController.title = "Нечетная неделя"
            
            timeView.hidden = false
            placeLabel.hidden = false
            professorNameTextField.hidden = false
            lessonNameField.hidden = false
            audienceNumberField.hidden = false
            lessonTypeButton.hidden = false
            if editing {
                navigationController.tableView.tableFooterView = navigationController.addSubjectView
            }
            timeView2.hidden = true
            placeLabel2.hidden = true
            professorNameTextField2.hidden = true
            lessonNameField2.hidden = true
            audienceNumberField2.hidden = true
            lessonTypeButton2.hidden = true
        }
        
        UIView.animateWithDuration(0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .AllowAnimatedContent, animations: {
            self.layoutIfNeeded()
            if self.leftSwipeGesture.direction == .Left {
                self.timeView2.alpha = 1
                self.cardView2.alpha = 1
                self.cardView.alpha = 0.2
                self.timeView.hidden = true
                self.placeLabel.hidden = true
                self.professorNameTextField.hidden = true
                self.lessonNameField.hidden = true
                self.audienceNumberField.hidden = true
                self.lessonTypeButton.hidden = true
            } else {
                self.timeView2.alpha = 0
                self.cardView2.alpha = 0.2
                self.cardView.alpha = 1
            }
            }, completion: { Void in
                if self.leftSwipeGesture.direction == .Left {
                    self.leftSwipeGesture.direction = .Right
                } else {
                    self.leftSwipeGesture.direction = .Left
                }
        })
    }

    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true
    }
    
    
    @IBAction func plusButtonPressed(sender: AnyObject) {
        if navigationController.title != "Четная неделя" {
            self.showCardView2()
            leftSwipeGesture.direction = .Right
            cardView2.alpha = 1.0
            return
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.visualView.alpha = 0.0
            }, completion: { Void in
                self.visualView.hidden = true
                self.visualView.alpha = 1.0
                self.lessonNameField2.becomeFirstResponder()
                self.navigationController.tableView.tableFooterView = nil
                self.navigationController.navigationItem.rightBarButtonItem?.enabled = false
        })
        
        lesson2 = Lesson()
        lesson2!.startTime = lesson!.startTime
        lesson2!.endTime = lesson?.endTime
        lesson2!.id = lesson!.id
        lesson2!.day = navigationController.currentDay
        lesson2!.type = "Лекция"
        lesson2!.isEven = true
        
        
        navigationController.currentDay.lessons!.addObject(lesson2!)
        CoreDataHelper.instance.save()
    }
    
    @IBAction func editingTextFieldChanged(sender: AnyObject) {
        if sender as! NSObject == lessonNameField && lessonNameField.text?.characters.count != 0 {
            navigationController.shouldExpandCell = true
            mainView.hidden = false
            headerView.layer.cornerRadius = 0
            cardView.backgroundColor = UIColor.whiteColor()
            navigationController.tableView.beginUpdates()
            navigationController.tableView.endUpdates()
            
//            navigationController.tableView.reloadRowsAtInfdexPaths([NSIndexPath(forRow: navigationController.currentDay.allLessons().count-1, inSection: 0)], withRowAnimation: .Automatic)
        }
        
        if lessonNameField.text != "" && audienceNumberField.text != "" && professorNameTextField.text != "" {
            lesson?.name = lessonNameField.text
            lesson?.audience = audienceNumberField.text
            lesson?.type = lessonTypeButton.titleLabel!.text
            lesson?.professor = professorNameTextField.text
            CoreDataHelper.instance.save()
            
            navigationController.navigationItem.rightBarButtonItem?.enabled = true
            lessonDelegate?.shouldSaveLesson!(id)
            
            if lesson2 == nil {
                cardView2.hidden = false
                visualView.hidden = false
                cardView2.alpha = 1.0
                cardViewTrailingConstraint.constant = 35
            }
            
            if Int((navigationController.currentDay.allNotEvenLessons().last?.number)!) >= timeTable.count {
                navigationController.tableView.tableFooterView = nil
            } else {
                UIView.performWithoutAnimation({
                    self.navigationController.addSubjectButton.setTitle("+ Добавить еще", forState: .Normal)
                    self.navigationController.addSubjectButton.layoutIfNeeded()
                })
                navigationController.tableView.tableFooterView = navigationController.addSubjectView
            }
        } else if lessonNameField.text == "" || audienceNumberField.text == "" || professorNameTextField.text == "" {
            navigationController.navigationItem.rightBarButtonItem?.enabled = false
            navigationController.tableView.tableFooterView = nil
            if lesson2 == nil {
                cardView2.hidden = true
                cardViewTrailingConstraint.constant = 8
            }
        }
    }
    
    @IBAction func editingTextField2Changed(sender: AnyObject) {
        if lessonNameField2.text != "" && audienceNumberField2.text != "" && professorNameTextField2.text != "" {
            lesson2?.name = lessonNameField2.text
            lesson2?.audience = audienceNumberField2.text
            lesson2?.type = lessonTypeButton2.titleLabel!.text
            lesson2?.professor = professorNameTextField2.text
            CoreDataHelper.instance.save()
            navigationController.navigationItem.rightBarButtonItem?.enabled = true
            
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text?.characters.count == 0 { return false }
        
        textField.resignFirstResponder()
        
        if textField == lessonNameField {
            lesson!.name = lessonNameField.text
            CoreDataHelper.instance.save()
            audienceNumberField.becomeFirstResponder()
        } else if textField == audienceNumberField {
            lesson!.audience = textField.text
            CoreDataHelper.instance.save()
            professorNameTextField.becomeFirstResponder()
        } else if textField == lessonNameField2 {
            lesson2!.name = textField.text
            CoreDataHelper.instance.save()
            audienceNumberField2.becomeFirstResponder()
        } else if textField == audienceNumberField2 {
            lesson2!.audience = textField.text
            CoreDataHelper.instance.save()
            professorNameTextField2.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
//        if textField == lessonNameField || textField == audienceNumberField || textField == professorNameTextField {
            textField.text = ""
            navigationController.navigationItem.rightBarButtonItem?.enabled = false
            navigationController.tableView.tableFooterView = nil
//        }
        if lesson2 == nil {
            cardView2.hidden = true
            cardViewTrailingConstraint.constant = 8
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if lesson == nil { return }
        
        if editing {
            
            if navigationController.tableView.numberOfRowsInSection(0)+1 >= Int((navigationController.currentDay.allNotEvenLessons().last?.number)!)-1 {
                navigationController.tableView.tableFooterView = nil
            }
            
            numberOfLessonButton.enabled = true
            
            lessonNameField.enabled = true
            lessonNameField2.enabled = true
            lessonNameField.backgroundColor = getBakColorForTextFieldWhileEditing()
            lessonNameField2.backgroundColor = getBakColorForTextFieldWhileEditing()
            lessonNameField.borderStyle = .RoundedRect
            lessonNameField2.borderStyle = .RoundedRect
            
            audienceNumberField.enabled = true
            audienceNumberField2.enabled = true
            audienceNumberField.borderStyle = .RoundedRect
            audienceNumberField2.borderStyle = .RoundedRect
            
            lessonTypeButton.enabled = true
            lessonTypeButton2.enabled = true
            lessonTypeButton.backgroundColor = UIColor.whiteColor()
            lessonTypeButton2.backgroundColor = UIColor.whiteColor()
            lessonTypeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            lessonTypeButton2.setTitleColor(UIColor.blackColor(), forState: .Normal)
            lessonTypeButton.layer.borderWidth = 0.5
            lessonTypeButton2.layer.borderWidth = 0.5
            lessonTypeButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).CGColor
            lessonTypeButton2.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).CGColor
            lessonTypeButton.layer.cornerRadius = 5
            lessonTypeButton.layer.masksToBounds = false
            lessonTypeButton2.layer.cornerRadius = 5
            lessonTypeButton2.layer.masksToBounds = false

            
            lessonTypeHeightConstraint.constant = 44
            lessonType2HeightConstraint.constant = 44
            lessonTypeTrailingConstraint.active = true
            lessonType2TrailingConstraint.active = true
            
            lessonNameHeightConstraint.constant = 44
            lessonName2HeightConstraint.constant = 44
            audienceNumberFieldHeightConstraint.constant = 44
            audienceNumberField2HeightConstraint.constant = 44
            
            headerViewHeightConstraint.constant = 60
            headerView2HeightConstraint.constant = 60
            
            professorHeightConstraint.constant = 44
            professor2HeightConstraint.constant = 44
            
            
            professorNameTextField.borderStyle = .RoundedRect
            professorNameTextField2.borderStyle = .RoundedRect
            professorNameTextField.enabled = true
            professorNameTextField2.enabled = true
            
            professorCenterConstraint.active = false
            professor2CenterConstraint.active = false
            professorLeadingConstraint.active = true
            professor2LeadingConstraint.active = true
            professorTopConstraint.active = true
            professor2TopConstraint.active = true

            if lesson2 == nil {
                cardView2.hidden = false
                visualView.hidden = false
                cardView2.alpha = 1.0
//                cardViewTrailingConstraint.constant = 35
            } else {
                cardView2.hidden = false
                visualView.hidden = true
//                cardViewTrailingConstraint.constant = 35
            }
            
        } else {
            //if navigationController.title == "Четная неделя"{
                
//                self.cardView2WidthConstraint.active = false
                self.cardViewWidthConstraint.active = false
                self.cardViewLeadingToTrailingConstraint.active = false
                self.cardViewTrailingConstraint.active = true
                self.cardViewLeadingConstraint.active = true
//                self.cardViewWidthConstraint.active = true
                
                self.cardView.alpha = 1.0
                self.cardView2.alpha = 0.2
                navigationController.title = "Нечетная неделя"
                self.leftSwipeGesture.direction = .Left
            
            timeView.hidden = false
            placeLabel.hidden = false
            professorNameTextField.hidden = false
            lessonNameField.hidden = false
            audienceNumberField.hidden = false
            lessonTypeButton.hidden = false
            //}
            
            numberOfLessonButton.enabled = false
            
            lessonNameField.enabled = false
            lessonNameField2.enabled = false
            lessonNameField.backgroundColor = colorForToday
            lessonNameField2.backgroundColor = colorForToday
            lessonNameField.borderStyle = .None
            lessonNameField2.borderStyle = .None
            
            audienceNumberField.enabled = false
            audienceNumberField2.enabled = false
            audienceNumberField.borderStyle = .None
            audienceNumberField2.borderStyle = .None
            
            lessonTypeButton.enabled = false
            lessonTypeButton2.enabled = false
            lessonTypeButton.backgroundColor = UIColor(red: 237/255, green: 168/255, blue: 84/255, alpha: 1.0)
            lessonTypeButton2.backgroundColor = UIColor(red: 237/255, green: 168/255, blue: 84/255, alpha: 1.0)
            lessonTypeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            lessonTypeButton2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            lessonTypeButton.layer.borderWidth = 0
            lessonTypeButton2.layer.borderWidth = 0
            lessonTypeButton.layer.cornerRadius = 0
            lessonTypeButton2.layer.cornerRadius = 0
            
            lessonTypeHeightConstraint.constant = 12
            lessonType2HeightConstraint.constant = 12
            lessonTypeTrailingConstraint.active = false
            lessonType2TrailingConstraint.active = false
            
            
            lessonNameHeightConstraint.constant = 30
            lessonName2HeightConstraint.constant = 30
            headerViewHeightConstraint.constant = 40
            headerView2HeightConstraint.constant = 40
            audienceNumberFieldHeightConstraint.constant = 20
            audienceNumberField2HeightConstraint.constant = 20
            
            professorHeightConstraint.constant = 20
            professor2HeightConstraint.constant = 20
            
            professorNameTextField.borderStyle = .None
            professorNameTextField2.borderStyle = .None
            professorNameTextField.enabled = false
            professorNameTextField2.enabled = false
            
            professorTopConstraint.active = false
            professor2TopConstraint.active = false
            professorLeadingConstraint.active = false
            professor2LeadingConstraint.active = false
            professorCenterConstraint.active = true
            professor2CenterConstraint.active = true
            
            if lesson2 == nil {
                cardView2.hidden = true
                cardViewTrailingConstraint.constant = 8
            } else {
                cardView2.hidden = false
                cardView2.alpha = 0.2
                cardViewTrailingConstraint.constant = 35
            }
            cardViewLeadingConstraint.constant = 8
            cardView.alpha = 1.0
            timeView2.hidden = true
            placeLabel2.hidden = true
            professorNameTextField2.hidden = true
            lessonNameField2.hidden = true
            audienceNumberField2.hidden = true
            lessonTypeButton2.hidden = true
        }
    }
    
    func getBakColorForTextFieldWhileEditing() -> UIColor {
        var hue: CGFloat = 0.0
        var sat: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        colorForToday.getHue(&hue, saturation: &sat, brightness: &b, alpha: &a)
        return UIColor(hue: hue, saturation: sat, brightness: b-0.2, alpha: a)
    }
    
    @IBAction func lessonTypePressed(sender: UIButton) {
        navigationController.editingLessonTypeID = id
        let pickerVC = navigationController.storyboard?.instantiateViewControllerWithIdentifier("PickerVC") as? PickerViewController

        pickerVC?.modalPresentationStyle = .Popover
        pickerVC?.delegate = self
        
        if let popoverPC = pickerVC!.popoverPresentationController {
            popoverPC.sourceView = lessonTypeButton
            
            popoverPC.sourceRect = CGRectMake(CGRectGetMidX(self.lessonTypeButton.bounds), self.lessonTypeButton.bounds.height,0,0)

            popoverPC.delegate = self
            pickerVC!.preferredContentSize = CGSize(width: 280, height: 250)
        }
        
        navigationController.presentViewController(pickerVC!, animated: true, completion: {
            if let popoverPC = pickerVC!.popoverPresentationController {
                if popoverPC.arrowDirection == .Up {
                    popoverPC.sourceRect = CGRectMake(CGRectGetMidX(self.lessonTypeButton.bounds), self.lessonTypeButton.bounds.height,0,0)
                } else if popoverPC.arrowDirection == .Down {
                    popoverPC.sourceRect = CGRectMake(CGRectGetMidX(self.lessonTypeButton.bounds), self.lessonTypeButton.bounds.height-10,0,0)
                }
            }
        })
    }
    
    @IBAction func numberOfLessonPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: {
                self.numberOfLesson.transform = CGAffineTransformMakeScale(0.5, 0.5)
            }, completion: { b->Void in
                UIView.animateWithDuration(0.2, animations: {
                    self.numberOfLesson.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: { b->Void in
                       
                        let previousLesson = self.navigationController.currentDay.getNotEvenLesson(Int((self.lesson?.id)!)-1)
                        let nextLesson = self.navigationController.currentDay.getNotEvenLesson(Int((self.lesson?.id)!)+1)
                        
                        if nextLesson != nil {
                            if self.lessonNumber+1 >= Int((nextLesson?.number)!) {
                                if previousLesson != nil {
                                    self.lessonNumber = Int((previousLesson?.number)!)+1
                                } else {
                                    self.lessonNumber = 1
                                }
                            } else {
                                self.lessonNumber = self.lessonNumber + 1
                            }
                        } else {
                            if self.lessonNumber+1 > self.timeTable.count {
                                if previousLesson != nil {
                                    self.lessonNumber = Int((previousLesson?.number)!)+1
                                } else {
                                    self.lessonNumber = 1
                                }
                            } else {
                                self.lessonNumber = self.lessonNumber + 1
                            }
                        }
                        
//                        let nextLesson = allNotEvenLessons[Int((self.lesson?.id!)!)+1] as? Lesson
//                        
//                        if self.lesson!.number == 1 {
//                            self.lessonNumber = self.lessonNumber + 1
//                        } else if self.lessonNumber+1 >= Int(.number!) {
//                            self.lessonNumber = Int((allNotEvenLessons[allNotEvenLessons.count-2].number)!)+1
//                        } else {
//                            self.lessonNumber = self.lessonNumber + 1
//                        }
                        self.numberOfLessonLabel.text = "\(self.lessonNumber)"
                        self.lesson?.number = self.lessonNumber
                        self.lesson?.startTime = self.timeTable[self.lessonNumber-1][0]
                        self.lesson?.endTime = self.timeTable[self.lessonNumber-1][1]
                        self.setupLessonTime()
                        CoreDataHelper.instance.save()
                })

        })


    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    func shouldChangeLessonTyoe(notification: NSNotification) {
        let type = notification.userInfo!["Type"] as? String
        lessonTypeButton.setTitle((type)?.uppercaseString, forState: .Normal)
        lesson?.type = type
        CoreDataHelper.instance.save()
    }

    
    override func resignFirstResponder() -> Bool {
        return true
    }
}