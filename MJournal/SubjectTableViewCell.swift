//
//  SubjectTableViewCell.swift
//  MJournal
//
//  Created by Michael Nikolaev on 26.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

protocol SavingLessonDelegate: NSObjectProtocol {
    func saveLesson()
}

class SubjectTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var professorNameTextField: UITextField!
    
    @IBOutlet weak var startTimeHour: UILabel!
    @IBOutlet weak var startTimeMin: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var lessonNameField: UITextField!
    @IBOutlet weak var audienceNumberField: UITextField!
    @IBOutlet weak var lessonTypeButton: UIButton!
    
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
    
    var navigationController: DaySheduleViewController!
    
    var lessonType = "ЛАБОРАТОРНАЯ РАБОТА"
    
    
    var colorForToday: UIColor! {
        didSet {
            headerView.backgroundColor = colorForToday
        }
    }
    
    var lesson: Lesson? {
        didSet {
            lessonNameField.text = lesson!.name
            
            lessonNameField.font = UIFont.appSemiBoldFont()
            startTimeHour.font = UIFont.appSemiBoldFont()
            startTimeMin.font = UIFont.appSemiBoldFont(10)
            
            endTime.font = UIFont.appMediumFont(13)
            audienceNumberField.font = UIFont.appSemiBoldFont()
            professorNameTextField.font = UIFont.appMediumFont(14)
            
            
            lessonNameField.backgroundColor = getBakColorForTextFieldWhileEditing()
            var hour = lesson!.startTime!
            var min = lesson!.startTime!
            hour.removeRange(lesson!.startTime!.endIndex.advancedBy(-3)..<lesson!.startTime!.endIndex)
            min.removeRange(lesson!.startTime!.startIndex..<lesson!.startTime!.startIndex.advancedBy(3))
            startTimeHour.text = hour
            startTimeMin.text = min
            endTime.text = lesson!.endTime
            
            audienceNumberField.text = lesson?.audience
            professorNameTextField.text = lesson?.professor
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lessonNameField.delegate = self
        audienceNumberField.delegate = self
        professorNameTextField.delegate = self
    }
    
    func updateLessonType(notification: NSNotification) {
        if let extractInfo = notification.userInfo {
            lessonType = extractInfo["Type"] as! String
            lessonTypeButton.setAttributedTitle(NSAttributedString(string: lessonType.uppercaseString), forState: .Normal)
        }
    }
    @IBAction func editingTextFieldChanged(sender: AnyObject) {
        if lessonNameField.text != "" && audienceNumberField.text != "" && professorNameTextField.text != "" {
            lesson?.name = lessonNameField.text
            lesson?.audience = audienceNumberField.text
            lesson?.type = lessonTypeButton.titleLabel!.text
            lesson?.professor = professorNameTextField.text
            CoreDataHelper.instance.save()
            
            navigationController.navigationItem.rightBarButtonItem?.enabled = true
//            navigationController.addSubjectButton.titleLabel!.text = "+Добавить еще"

            if navigationController.tableView.numberOfRowsInSection(0)+1 > TimetableParser.timeTable.count {
                navigationController.tableView.tableFooterView = nil
            } else {
                navigationController.tableView.tableFooterView = navigationController.addSubjectView
            }
        } else if lessonNameField.text == "" || audienceNumberField.text == "" || professorNameTextField.text == "" {
            navigationController.navigationItem.rightBarButtonItem?.enabled = false
            navigationController.tableView.tableFooterView = nil
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
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == lessonNameField || textField == audienceNumberField || textField == professorNameTextField {
            textField.text = ""
            navigationController.navigationItem.rightBarButtonItem?.enabled = false
            navigationController.tableView.tableFooterView = nil
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if lesson == nil { return }
        lessonTypeButton.titleLabel!.text = lessonType
        if editing {
            lessonNameField.enabled = true
            lessonNameField.backgroundColor = getBakColorForTextFieldWhileEditing()
            lessonNameField.borderStyle = .RoundedRect
            
            audienceNumberField.enabled = true
            audienceNumberField.borderStyle = .RoundedRect
            
            lessonTypeButton.enabled = true
            lessonTypeButton.backgroundColor = UIColor.whiteColor()
            lessonTypeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            lessonTypeButton.layer.borderWidth = 0.5
            lessonTypeButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).CGColor
            lessonTypeButton.layer.cornerRadius = 5
            lessonTypeHeightConstraint.constant = 44
            lessonTypeTrailingConstraint.active = true
            lessonTypeButton.layoutIfNeeded()
            
            lessonNameHeightConstraint.constant = 44
            audienceNumberFieldHeightConstraint.constant = 44
            
            headerViewHeightConstraint.constant = 60
            
            professorHeightConstraint.constant = 44
            
            
            professorNameTextField.borderStyle = .RoundedRect
            professorNameTextField.enabled = true
            
            professorCenterConstraint.active = false
            professorLeadingConstraint.active = true
            professorTopConstraint.active = true
            
        } else {
            lessonNameField.enabled = false
            lessonNameField.backgroundColor = colorForToday
            lessonNameField.borderStyle = .None
            
            audienceNumberField.enabled = false
            audienceNumberField.borderStyle = .None
            
            lessonTypeButton.enabled = false
            lessonTypeButton.backgroundColor = UIColor(red: 237/255, green: 168/255, blue: 84/255, alpha: 1.0)
            lessonTypeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            lessonTypeButton.layer.borderWidth = 0
            lessonTypeButton.layer.cornerRadius = 0
            lessonTypeHeightConstraint.constant = 12
            lessonTypeTrailingConstraint.active = false
            lessonTypeButton.layoutIfNeeded()
            
            
            lessonNameHeightConstraint.constant = 30
            headerViewHeightConstraint.constant = 40
            audienceNumberFieldHeightConstraint.constant = 20
            
            professorHeightConstraint.constant = 20
            
            professorNameTextField.borderStyle = .None
            professorNameTextField.enabled = false
            
            professorTopConstraint.active = false
            professorLeadingConstraint.active = false
            professorCenterConstraint.active = true
            
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
        
        lessonTypeButton.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
    }
    
    
    override func resignFirstResponder() -> Bool {
        return true
    }
}