//
//  SubjectTableViewCell.swift
//  MJournal
//
//  Created by Michael Nikolaev on 26.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var professorNameLabel: UILabel!
    
    @IBOutlet weak var startTimeHour: UILabel!
    @IBOutlet weak var startTimeMin: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var lessonNameField: UITextField!
    @IBOutlet weak var audienceNumberField: UITextField!
    @IBOutlet weak var lessonTypeButton: UIButton!
    
    @IBOutlet weak var lessonTypeHeightConstraint: NSLayoutConstraint!
    
    var lessonType = "ЛАБОРАТОРНАЯ РАБОТА"
    
    var colorForToday: UIColor! {
        didSet {
            headerView.backgroundColor = colorForToday
        }
    }
    
    var lesson: Lesson? {
        didSet {
            lessonNameField.text = lesson!.name
            lessonNameField.backgroundColor = getBakColorForTextFieldWhileEditing()
            var hour = lesson!.startTime
            var min = lesson!.startTime
            hour.removeRange(lesson!.startTime.endIndex.advancedBy(-3)..<lesson!.startTime.endIndex)
            min.removeRange(lesson!.startTime.startIndex..<lesson!.startTime.startIndex.advancedBy(3))
            startTimeHour.text = hour
            startTimeMin.text = min
            
            endTime.text = lesson!.endTime
            if lesson!.name == "" {
                lessonNameField.becomeFirstResponder()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lessonNameField.delegate = self
        audienceNumberField.delegate = self
    }
    
    func updateLessonType(notification: NSNotification) {
        if let extractInfo = notification.userInfo {
            lessonType = extractInfo["Type"] as! String
            lessonTypeButton.titleLabel!.text = lessonType
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text != "" {
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == lessonNameField || textField == audienceNumberField {
            textField.text = ""
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func willTransitionToState(state: UITableViewCellStateMask) {
        super.willTransitionToState(state)
        if state == .DefaultMask {
            professorNameLabel.hidden = false
        } else {
            professorNameLabel.hidden = true
        }
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
            lessonTypeHeightConstraint.constant = 20
            lessonTypeButton.layoutIfNeeded()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateLessonType), name: "ChosenType", object: nil)
            
        } else {
            lessonNameField.enabled = false
            lessonNameField.backgroundColor = colorForToday
            lessonNameField.borderStyle = .None
            
            audienceNumberField.enabled = false
            audienceNumberField.borderStyle = .None
            
            lessonTypeButton.enabled = false
            lessonTypeHeightConstraint.constant = 12
            lessonTypeButton.layoutIfNeeded()
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "ChosenType", object: nil)
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
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
}