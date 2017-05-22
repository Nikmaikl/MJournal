//
//  SubjectTableViewCell.swift
//  MJournal
//
//  Created by Michael Nikolaev on 26.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

@objc protocol PickerDelegate: class {
    @objc optional func saveTypeLesson(_ type: String)
}

protocol CardDelegate: class {
    func updateCards()
}

class SubjectTableViewCell: UITableViewCell, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, PickerDelegate, CardDelegate {
    
    @IBOutlet weak var mainView2: UIView!
    
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
    
    @IBOutlet weak var numberOfLessonContainerView: UIView!
    
    @IBOutlet weak var notificationIconImageView: UIImageView!
    
    
    @IBOutlet weak var roomTrailingToSuperViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var roomTrailingToProfessorConstraint: NSLayoutConstraint!
    
    
    //Second Card
    
    @IBOutlet weak var headerView2: UIView!
    @IBOutlet weak var cardView2: UIView!
    
    @IBOutlet weak var notificationImageView2: UIImageView!
    
    
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
    
    @IBOutlet weak var room2TrailingToSuperViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var room2TrailingToProfessorConstraint: NSLayoutConstraint!
    
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
            numberOfLessonContainerView.backgroundColor = colorForToday
        }
    }
    
    var timeTable: [[String]]!
    
    weak var lessonDelegate: LessonDelegate?
    
    var lessonNumber: Int!
    
    var lesson: Lesson? {
        didSet {
            navigationController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DaySheduleVC") as? DaySheduleViewController
            
            timeTable = UserDefaults.standard.value(forKey: "Timetable") as! [[String]]
            
            lessonNameField.text = lesson!.name
            
            lessonNameField.font = UIFont.appSemiBoldFont()
            lessonNameField2.font = lessonNameField.font
            startTimeHour.font = UIFont.appSemiBoldFont()
            startTimeHour2.font = startTimeHour.font
            startTimeMin.font = UIFont.appSemiBoldFont(10)
            startTimeMin2.font = startTimeMin.font
            
            endTime.font = UIFont.appMediumFont(13)
            endTime2.font = endTime.font
            audienceNumberField.font = UIFont.appRegularFont(14)
            audienceNumberField2.font = UIFont.appRegularFont(13)
            professorNameTextField.font = UIFont.appMediumFont(14)
            professorNameTextField2.font = professorNameTextField.font
            
            placeLabel.font = UIFont.appSemiBoldFont(14)
            placeLabel2.font = UIFont.appSemiBoldFont(14)
            
            lesson?.startTime = timeTable[lessonNumber-1][0]
            lesson?.endTime = timeTable[lessonNumber-1][1]
            
            
            if lesson!.number == nil {
                lesson?.number = lessonNumber as NSNumber?
            }
            
            numberOfLessonLabel.text = "\(lesson!.number!)"
            
            lessonNameField.backgroundColor = getBakColorForTextFieldWhileEditing()
            lessonNameField2.backgroundColor = lessonNameField.backgroundColor
            
            setupLessonTime()
            
            if lesson?.audience != nil {
                audienceNumberField.text = lesson?.audience
            } else {
                //                audienceNumberField.text = "нет."
            }
            professorNameTextField.text = lesson?.professor
            lessonTypeButton.setTitle(lesson?.type?.uppercased(), for: UIControlState())
            lessonTypeButton2.setTitle(lessonTypeButton.titleLabel!.text, for: UIControlState())
            
            numberOfLesson.backgroundColor = getBakColorForTextFieldWhileEditing()
            numberOfLessonLabel.textColor = UIColor.white
            
            if lesson?.name != nil {
                mainView.isHidden = false
            } else {
                mainView.isHidden = false
            }
            
            if lesson?.notes != nil && lesson?.notes != "" {
                notificationIconImageView.isHidden = false
            } else {
                notificationIconImageView.isHidden = true
            }
            
            if !isEditing {
                lessonNameField.backgroundColor = UIColor.clear
                lessonNameField2.backgroundColor = UIColor.clear
            }
            
            self.contentView.backgroundColor = UIColor.darkBackground()
            
            if UserDefaults.standard.bool(forKey: "white_theme") {
                mainView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                timeView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                
                mainView2.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                timeView2.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            } else {
                mainView.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
                timeView.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
                
                mainView2.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
                timeView2.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0)
            }
        }
    }
    
    var lesson2: Lesson? {
        didSet {
            if lesson2?.name != nil {
                lessonNameField2.text = lesson2!.name
                audienceNumberField2.text = lesson2!.audience
                professorNameTextField2.text = lesson2!.professor
                visualView.isHidden = true
                cardView2.isHidden = false
                self.cardView2.alpha = 0.2
                cardViewTrailingConstraint.constant = 35
                
                if lesson2?.notes != nil && lesson2?.notes != "" {
                    notificationImageView2.isHidden = false
                } else {
                    notificationImageView2.isHidden = true
                }
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
        
        leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwiped))
        leftSwipeGesture.direction = .left
        self.addGestureRecognizer(leftSwipeGesture)
        
        cardView2.alpha = 0.2
        leftSwipeGesture.delegate = self
        timeView2.alpha = 0
        
        if lesson != nil {
            lesson?.startTime = timeTable[id][0]
            lesson?.endTime = timeTable[id][1]
            
            if lesson?.notes != nil && lesson?.notes != "" {
                notificationIconImageView.isHidden = false
            } else {
                notificationIconImageView.isHidden = true
            }
        }
        if lesson2 != nil {
            lesson2?.startTime = lesson?.startTime
            lesson2?.endTime = lesson?.endTime
            
            if lesson2?.notes != nil && lesson2?.notes != "" {
                notificationImageView2.isHidden = false
            } else {
                notificationImageView2.isHidden = true
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if Time.isEvenWeek() && lesson2 != nil {
            hideCardViewItems()
            self.cardViewTrailingConstraint.isActive = false
            self.cardViewLeadingConstraint.isActive = false
            self.cardViewWidthConstraint.constant = self.superview!.frame.width-35-35
            self.cardView2WidthConstraint.constant = self.superview!.frame.width-35-35
            self.cardViewWidthConstraint.isActive = true
            self.cardView2WidthConstraint.isActive = true
            self.cardViewLeadingToTrailingConstraint.isActive = true
            cardView.setNeedsLayout()
            cardView2.setNeedsLayout()
            
            timeView2.isHidden = false
            placeLabel2.isHidden = false
            professorNameTextField2.isHidden = false
            lessonNameField2.isHidden = false
            audienceNumberField2.isHidden = false
            lessonTypeButton2.isHidden = false
            
            self.leftSwipeGesture.direction = .right
        }
    }
    
    internal func updateCards() {
        if lesson != nil {
            if lesson?.notes != nil && lesson?.notes != "" {
                notificationIconImageView.isHidden = false
            } else {
                notificationIconImageView.isHidden = true
            }
        }
        if lesson2 != nil {
            if lesson2?.notes != nil && lesson2?.notes != "" {
                notificationImageView2.isHidden = false
            } else {
                notificationImageView2.isHidden = true
            }
        }
    }
    
    func setupLessonTime() {
        var hour = lesson!.startTime!
        var min = lesson!.startTime!
        hour.removeSubrange(lesson!.startTime!.characters.index(lesson!.startTime!.endIndex, offsetBy: -3)..<lesson!.startTime!.endIndex)
        min.removeSubrange(lesson!.startTime!.startIndex..<lesson!.startTime!.characters.index(lesson!.startTime!.startIndex, offsetBy: 3))
        startTimeHour.text = hour
        startTimeHour2.text = hour
        startTimeMin.text = min
        startTimeMin2.text = min
        endTime.text = lesson!.endTime
        endTime2.text = endTime.text
    }
    
    func saveTypeLesson(_ type: String) {
        if navigationController.title == "Четная неделя" {
            lesson2?.type = type
            lessonTypeButton2.setTitle(type.uppercased(), for: UIControlState())
        } else {
            lesson?.type = type
            lessonTypeButton.setTitle(type.uppercased(), for: UIControlState())
        }
        CoreDataHelper.instance.save()
    }
    
    func showCardView2() {
        self.cardsEqualWidth.isActive = false
        
        self.cardViewTrailingConstraint.isActive = false
        self.cardViewLeadingConstraint.isActive = false
        self.cardViewWidthConstraint.constant = cardView.frame.width
        self.cardView2WidthConstraint.constant = cardView.frame.width
        self.cardViewWidthConstraint.isActive = true
        self.cardView2WidthConstraint.isActive = true
        self.cardViewLeadingToTrailingConstraint.isActive = true
        navigationController.title = "Четная неделя"
        navigationController.tableView.tableFooterView = nil
        timeView2.isHidden = false
        placeLabel2.isHidden = false
        professorNameTextField2.isHidden = false
        lessonNameField2.isHidden = false
        audienceNumberField2.isHidden = false
        lessonTypeButton2.isHidden = false
    }
    
    func leftSwiped(_ swipe: UISwipeGestureRecognizer) {
        if lesson2 == nil && !isEditing { return }
        if leftSwipeGesture.direction == .left {
            showCardView2()
        } else {
            self.cardView2WidthConstraint.isActive = false
            self.cardViewWidthConstraint.isActive = false
            self.cardViewLeadingToTrailingConstraint.isActive = false
            self.cardsEqualWidth.isActive = true
            self.cardViewTrailingConstraint.isActive = true
            self.cardViewLeadingConstraint.isActive = true
            
            cardsEqualWidth.isActive = true
            navigationController.title = "Нечетная неделя"
            
            timeView.isHidden = false
            placeLabel.isHidden = false
            professorNameTextField.isHidden = false
            lessonNameField.isHidden = false
            audienceNumberField.isHidden = false
            lessonTypeButton.isHidden = false
            if isEditing {
                navigationController.tableView.tableFooterView = navigationController.addSubjectView
            }
            timeView2.isHidden = true
            placeLabel2.isHidden = true
            professorNameTextField2.isHidden = true
            lessonNameField2.isHidden = true
            audienceNumberField2.isHidden = true
            lessonTypeButton2.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .allowAnimatedContent, animations: {
            self.layoutIfNeeded()
            if self.leftSwipeGesture.direction == .left {
                self.hideCardViewItems()
            } else {
                self.timeView2.alpha = 0
                self.cardView2.alpha = 0.2
                self.cardView.alpha = 1
            }
            }, completion: { Void in
                if self.leftSwipeGesture.direction == .left {
                    self.leftSwipeGesture.direction = .right
                } else {
                    self.leftSwipeGesture.direction = .left
                }
        })
    }
    
    func hideCardViewItems() {
        self.timeView2.alpha = 1
        self.cardView2.alpha = 1
        self.cardView.alpha = 0.2
        self.timeView.isHidden = true
        self.placeLabel.isHidden = true
        self.professorNameTextField.isHidden = true
        self.lessonNameField.isHidden = true
        self.audienceNumberField.isHidden = true
        self.lessonTypeButton.isHidden = true
    }
    
    func showCardView2Items() {
        self.timeView2.alpha = 1
        self.cardView2.alpha = 1
        self.cardView.alpha = 0.2
        self.timeView.isHidden = true
        self.placeLabel.isHidden = true
        self.professorNameTextField.isHidden = true
        self.lessonNameField.isHidden = true
        self.lessonNameField2.isHidden = false
        self.audienceNumberField.isHidden = true
        self.lessonTypeButton.isHidden = true
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    
    @IBAction func plusButtonPressed(_ sender: AnyObject) {
        if navigationController.title != "Четная неделя" {
            self.showCardView2()
            leftSwipeGesture.direction = .right
            cardView2.alpha = 1.0
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.visualView.alpha = 0.0
            }, completion: { Void in
                self.visualView.isHidden = true
                self.visualView.alpha = 1.0
                self.lessonNameField2.becomeFirstResponder()
                self.navigationController.tableView.tableFooterView = nil
                self.navigationController.customNavigationItem.rightBarButtonItem?.isEnabled = false
        })
        
        lesson2 = Lesson()
        lesson2!.startTime = lesson!.startTime
        lesson2!.endTime = lesson?.endTime
        lesson2!.id = lesson!.id
        lesson2!.day = navigationController.currentDay
        lesson2!.type = "Лекция"
        lesson2!.isEven = true
        
        
        navigationController.currentDay.lessons!.add(lesson2!)
        CoreDataHelper.instance.save()
    }
    
    
    @IBAction func editingTextFieldChanged(_ sender: AnyObject) {
        if lessonNameField.text?.characters.count != 0 {
            
            mainView.isHidden = false
            headerView.layer.cornerRadius = 0
            cardView.backgroundColor = UIColor.white
            navigationController.tableView.beginUpdates()
            navigationController.tableView.endUpdates()
            
            
            //if lessonNameField.text != "" && audienceNumberField.text != "" && professorNameTextField.text != "" {
            if sender as! NSObject == lessonNameField {
                lesson?.name = lessonNameField.text
            } else if sender as! NSObject == audienceNumberField {
                lesson?.audience = audienceNumberField.text
            } else if sender as! NSObject == professorNameTextField {
                lesson?.professor = professorNameTextField.text
            }
            
            lesson?.type = lessonTypeButton.titleLabel!.text
            CoreDataHelper.instance.save()
            
            navigationController.customNavigationItem.rightBarButtonItem?.isEnabled = true
            
            if lesson2 == nil {
                cardView2.isHidden = false
                visualView.isHidden = false
                cardView2.alpha = 1.0
                cardViewTrailingConstraint.constant = 35
            }
            
            if Int((navigationController.currentDay.allNotEvenLessons().last?.number)!)+1 >= timeTable.count {
                navigationController.tableView.tableFooterView = nil
            } else {
                UIView.performWithoutAnimation({
                    self.navigationController.addSubjectButton.setTitle("+ Добавить еще", for: UIControlState())
                    self.navigationController.addSubjectButton.layoutIfNeeded()
                })
                navigationController.tableView.tableFooterView = navigationController.addSubjectView
            }
        } else {
            navigationController.customNavigationItem.rightBarButtonItem?.isEnabled = false
            if lesson2 == nil {
                cardView2.isHidden = true
                //                cardViewTrailingConstraint.constant = 8
            }
        }
    }
    
    @IBAction func editingTextField2Changed(_ sender: AnyObject) {
        if lessonNameField2.text != "" {
            lesson2?.name = lessonNameField2.text
            lesson2?.audience = audienceNumberField2.text
            lesson2?.type = lessonTypeButton2.titleLabel!.text
            lesson2?.professor = professorNameTextField2.text
            CoreDataHelper.instance.save()
            navigationController.customNavigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        if textField == lessonNameField || textField == audienceNumberField || textField == professorNameTextField {
        if textField == lessonNameField || textField == lessonNameField2 {
            textField.text = ""
            navigationController.customNavigationItem.rightBarButtonItem?.isEnabled = false
            navigationController.tableView.tableFooterView = nil
        }
        //        }
        if lesson2 == nil {
            cardView2.isHidden = true
            cardViewTrailingConstraint.constant = 8
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if lesson == nil { return }
        
        if editing {
            
            notificationIconImageView.isHidden = true
            notificationImageView2.isHidden = true
            startedEditing()
            
            roomTrailingToProfessorConstraint.isActive = false
            roomTrailingToSuperViewConstraint.isActive = true
            room2TrailingToProfessorConstraint.isActive = false
            room2TrailingToSuperViewConstraint.isActive = true
            
        } else {
            if lesson2?.notes == nil || (lesson2?.notes)! == "" {
                notificationImageView2.isHidden = true
            } else {
                notificationImageView2.isHidden = false
            }
            
            if lesson?.notes != nil && lesson?.notes != "" {
                notificationIconImageView.isHidden = false
            } else {
                notificationIconImageView.isHidden = true
            }
            
            roomTrailingToSuperViewConstraint.isActive = false
            roomTrailingToProfessorConstraint.isActive = true
            room2TrailingToSuperViewConstraint.isActive = false
            room2TrailingToProfessorConstraint.isActive = true
            
            timeView.isHidden = false
            placeLabel.isHidden = false
            professorNameTextField.isHidden = false
            lessonNameField.isHidden = false
            audienceNumberField.isHidden = false
            lessonTypeButton.isHidden = false
            
            numberOfLessonButton.isEnabled = false
            
            lessonNameField.isEnabled = false
            lessonNameField2.isEnabled = false
            lessonNameField.backgroundColor = colorForToday
            lessonNameField2.backgroundColor = colorForToday
            lessonNameField.borderStyle = .none
            lessonNameField2.borderStyle = .none
            
            audienceNumberField.isEnabled = false
            audienceNumberField2.isEnabled = false
            audienceNumberField.borderStyle = .none
            audienceNumberField2.borderStyle = .none
            
            lessonTypeButton.isEnabled = false
            lessonTypeButton2.isEnabled = false
            lessonTypeButton.backgroundColor = UIColor(red: 237/255, green: 168/255, blue: 84/255, alpha: 1.0)
            lessonTypeButton2.backgroundColor = UIColor(red: 237/255, green: 168/255, blue: 84/255, alpha: 1.0)
            lessonTypeButton.setTitleColor(UIColor.white, for: UIControlState())
            lessonTypeButton2.setTitleColor(UIColor.white, for: UIControlState())
            lessonTypeButton.layer.borderWidth = 0
            lessonTypeButton2.layer.borderWidth = 0
            lessonTypeButton.layer.cornerRadius = 0
            lessonTypeButton2.layer.cornerRadius = 0
            
            lessonTypeHeightConstraint.constant = 12
            lessonType2HeightConstraint.constant = 12
            lessonTypeTrailingConstraint.isActive = false
            lessonType2TrailingConstraint.isActive = false
            
            
            lessonNameHeightConstraint.constant = 30
            lessonName2HeightConstraint.constant = 30
            headerViewHeightConstraint.constant = 40
            headerView2HeightConstraint.constant = 40
            audienceNumberFieldHeightConstraint.constant = 20
            audienceNumberField2HeightConstraint.constant = 20
            
            professorHeightConstraint.constant = 20
            professor2HeightConstraint.constant = 20
            
            professorNameTextField.borderStyle = .none
            professorNameTextField2.borderStyle = .none
            professorNameTextField.isEnabled = false
            professorNameTextField2.isEnabled = false
            
            professorTopConstraint.isActive = false
            professor2TopConstraint.isActive = false
            professorLeadingConstraint.isActive = false
            professor2LeadingConstraint.isActive = false
            professorCenterConstraint.isActive = true
            professor2CenterConstraint.isActive = true
            
            if lesson2 == nil {
                cardView2.isHidden = true
                cardViewTrailingConstraint.constant = 8
                
            } else {
                if Time.isEvenWeek() {
                    return
                } else {
                    cardView2.isHidden = false
                    cardView2.alpha = 0.2
                    cardViewTrailingConstraint.constant = 35
                }
            }
            
            
            if leftSwipeGesture.direction != .right {
                cardView.alpha = 1.0
                timeView2.isHidden = true
                placeLabel2.isHidden = true
                professorNameTextField2.isHidden = true
                lessonNameField2.isHidden = true
                audienceNumberField2.isHidden = true
                lessonTypeButton2.isHidden = true
            } else {
                cardView2.alpha = 1.0
            }
        }
    }
    
    func startedEditing() {
        if navigationController.tableView.numberOfRows(inSection: 0)+1 >= Int((navigationController.currentDay.allNotEvenLessons().last?.number)!)-1 {
            navigationController.tableView.tableFooterView = nil
        }
        
        numberOfLessonContainerView.isHidden = true
        numberOfLessonButton.isEnabled = true
        
        lessonNameField.isEnabled = true
        lessonNameField2.isEnabled = true
        lessonNameField.backgroundColor = getBakColorForTextFieldWhileEditing()
        lessonNameField2.backgroundColor = getBakColorForTextFieldWhileEditing()
        lessonNameField.borderStyle = .roundedRect
        lessonNameField2.borderStyle = .roundedRect
        
        audienceNumberField.isEnabled = true
        audienceNumberField2.isEnabled = true
        audienceNumberField.borderStyle = .roundedRect
        audienceNumberField2.borderStyle = .roundedRect
        
        lessonTypeButton.isEnabled = true
        lessonTypeButton2.isEnabled = true
        lessonTypeButton.backgroundColor = UIColor.white
        lessonTypeButton2.backgroundColor = UIColor.white
        lessonTypeButton.setTitleColor(UIColor.black, for: UIControlState())
        lessonTypeButton2.setTitleColor(UIColor.black, for: UIControlState())
        lessonTypeButton.layer.borderWidth = 0.5
        lessonTypeButton2.layer.borderWidth = 0.5
        lessonTypeButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        lessonTypeButton2.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        lessonTypeButton.layer.cornerRadius = 5
        lessonTypeButton.layer.masksToBounds = false
        lessonTypeButton2.layer.cornerRadius = 5
        lessonTypeButton2.layer.masksToBounds = false
        
        
        lessonTypeHeightConstraint.constant = 44
        lessonType2HeightConstraint.constant = 44
        lessonTypeTrailingConstraint.isActive = true
        lessonType2TrailingConstraint.isActive = true
        
        lessonNameHeightConstraint.constant = 44
        lessonName2HeightConstraint.constant = 44
        audienceNumberFieldHeightConstraint.constant = 44
        audienceNumberField2HeightConstraint.constant = 44
        
        headerViewHeightConstraint.constant = 60
        headerView2HeightConstraint.constant = 60
        
        professorHeightConstraint.constant = 44
        professor2HeightConstraint.constant = 44
        
        
        professorNameTextField.borderStyle = .roundedRect
        professorNameTextField2.borderStyle = .roundedRect
        professorNameTextField.isEnabled = true
        professorNameTextField2.isEnabled = true
        
        professorCenterConstraint.isActive = false
        professor2CenterConstraint.isActive = false
        professorLeadingConstraint.isActive = true
        professor2LeadingConstraint.isActive = true
        professorTopConstraint.isActive = true
        professor2TopConstraint.isActive = true
        
        cardViewTrailingConstraint.constant = 35
        
        if lesson2 == nil {
            cardView2.isHidden = false
            visualView.isHidden = false
            cardView2.alpha = 1.0
        } else {
            cardView2.isHidden = false
            visualView.isHidden = true
        }
        
        //        if lesson?.audience == "" {
        //            audienceNumberField.text = ""
        //        }
    }
    
    func getBakColorForTextFieldWhileEditing() -> UIColor {
        var hue: CGFloat = 0.0
        var sat: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        colorForToday.getHue(&hue, saturation: &sat, brightness: &b, alpha: &a)
        return UIColor(hue: hue, saturation: sat, brightness: b-0.2, alpha: a)
    }
    
    @IBAction func lessonTypePressed(_ sender: UIButton) {
        navigationController.editingLessonTypeID = id
        let pickerVC = navigationController.storyboard?.instantiateViewController(withIdentifier: "PickerVC") as? PickerViewController
        
        pickerVC?.modalPresentationStyle = .popover
        pickerVC?.delegate = self
        pickerVC?.controller = "Subject"
        pickerVC?.shouldSelectRows.append(0)
        
        let newTypeLessonStr = (lessonTypeButton.titleLabel!.text!).lowercased()
        
        pickerVC?.shouldSelectTypeOfLesson = newTypeLessonStr.capitalizingFirstLetter()
        
        if let popoverPC = pickerVC!.popoverPresentationController {
            popoverPC.sourceView = lessonTypeButton
            
            popoverPC.sourceRect = CGRect(x: self.lessonTypeButton.bounds.midX, y: self.lessonTypeButton.bounds.height,width: 0,height: 0)
            
            popoverPC.delegate = self
            pickerVC!.preferredContentSize = CGSize(width: 280, height: 250)
        }
        
        navigationController.present(pickerVC!, animated: true, completion: {
            if let popoverPC = pickerVC!.popoverPresentationController {
                if popoverPC.arrowDirection == .up {
                    popoverPC.sourceRect = CGRect(x: self.lessonTypeButton.bounds.midX, y: self.lessonTypeButton.bounds.height,width: 0,height: 0)
                } else if popoverPC.arrowDirection == .down {
                    popoverPC.sourceRect = CGRect(x: self.lessonTypeButton.bounds.midX, y: self.lessonTypeButton.bounds.height-10,width: 0,height: 0)
                }
            }
        })
    }
    
    @IBAction func numberOfLessonPressed(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.2, animations: {
            self.numberOfLesson.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { b->Void in
                UIView.animate(withDuration: 0.2, animations: {
                    self.numberOfLesson.transform = CGAffineTransform(scaleX: 1, y: 1)
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
                        
                        self.numberOfLessonLabel.text = "\(self.lessonNumber!)"
                        self.lesson?.number = self.lessonNumber as NSNumber?
                        self.lesson?.startTime = self.timeTable[self.lessonNumber-1][0]
                        self.lesson?.endTime = self.timeTable[self.lessonNumber-1][1]
                        self.setupLessonTime()
                        CoreDataHelper.instance.save()
                })
                
        })
        
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    func shouldChangeLessonTyoe(_ notification: Notification) {
        let type = (notification as NSNotification).userInfo!["Type"] as? String
        lessonTypeButton.setTitle((type)?.uppercased(), for: UIControlState())
        lesson?.type = type
        CoreDataHelper.instance.save()
    }
    
    
    override func resignFirstResponder() -> Bool {
        return true
    }
}
