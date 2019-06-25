//
//  SheduleTableViewCell.swift
//  MJournal
//
//  Created by Michael Nikolaev on 13.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class SheduleTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate, PickerDelegate {
    
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButtom: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var pickerView = UIPickerView(frame: CGRect(x: 100, y: 100, width: 100, height: 200))

    var navigationController: UITableViewController!
    
    var hours = [String]()
    var minutes = [String]()
    
    var id: Int! {
        didSet {
            startTime = timeTable[id][0]
            endTime = timeTable[id][1]
        }
    }
    
    var pressedButton: UIButton!
    
    var startTime: String! {
        didSet {
            startTimeButton.setTitle(startTime, for: UIControl.State())
        }
    }
    
    var endTime: String! {
        didSet {
            endTimeButtom.setTitle(endTime, for: UIControl.State())
        }
    }
    
    fileprivate let pickerViewRows = 10000
    fileprivate var pickerViewMiddleHours: Int!
    fileprivate var pickerViewMiddleMinutes: Int!
    
    
    var timeTable: [[String]]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(red: 116, green: 121, blue: 121, alpha: 1.0)
        
        titleLabel.font = UIFont.appMediumFont()
        startTimeButton.titleLabel!.font = UIFont.appSemiBoldFont()
        endTimeButtom.titleLabel!.font = UIFont.appSemiBoldFont()
        
        timeTable = UserDefaults.standard.value(forKey: "Timetable") as! [[String]]
        
        for i in 1...23 {
            var hour = ""
            if i < 10 { hour = "\(i)" }
            else { hour = "\(i)" }
            
            hours.append(hour)
        }
        for i in 0...11 {
            var minute = ""
            if i == 0 { minute = "0\(i)" }
            else if i == 1 { minute = "0\(i*5)"}
            else { minute = "\(i*5)" }
            
            minutes.append(minute)
        }
        
        pickerViewMiddleHours = ((pickerViewRows / hours.count) / 2) * hours.count
        pickerViewMiddleMinutes = ((pickerViewRows / minutes.count) / 2) * minutes.count
    }
    
    func valueForRowInComponent(_ row: Int, component: Int) -> String {
        if component == 0 {
            return hours[row % hours.count]
        } else {
            return minutes[row % minutes.count]
        }
    }
    
    func rowForValue(_ value: Int, component: Int) -> Int {
        if component == 0 {
            return pickerViewMiddleHours + value
        } else {
            return pickerViewMiddleMinutes + value
        }
    }

    
    @IBAction func timeButtonPressed(_ sender: UIButton) {
                        let pickerVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PickerVC") as? PickerViewController
                        
                        self.pressedButton = sender
                        
                        pickerVC!.modalPresentationStyle = .popover
                        pickerVC!.pickerDelegate = self
                        pickerVC!.pickerDataSource = self
                        pickerVC!.delegate = self
                        pickerVC?.controller = "Shedule"
                        
                        let buttonText = sender.titleLabel!.text!
                        let buttonTimeHours = buttonText.substring(with: buttonText.startIndex..<buttonText.index(buttonText.startIndex, offsetBy: 2))
                        let buttonTimeMinutes = buttonText.substring(with: buttonText.index(buttonText.startIndex, offsetBy: 3)..<buttonText.index(buttonText.startIndex, offsetBy: 5))
                        
                        if buttonTimeHours.count == 2 {
                            if buttonTimeHours.substring(with: buttonText.startIndex..<buttonText.index(buttonText.startIndex, offsetBy: 1)) == "0" {
                                pickerVC?.shouldSelectRows.append(self.rowForValue(Int(buttonText.substring(with: buttonText.index(buttonText.startIndex, offsetBy: 1)..<buttonText.index(buttonText.startIndex, offsetBy: 2)))!-1, component: 0))
                            } else {
                                pickerVC?.shouldSelectRows.append(self.rowForValue(Int(buttonText.substring(with: buttonText.startIndex..<buttonText.index(buttonText.startIndex, offsetBy: 2)))!-1, component: 0))
                            }
                        } else {
                            pickerVC?.shouldSelectRows.append(self.rowForValue(Int(buttonText.substring(with: buttonText.startIndex..<buttonText.index(buttonText.startIndex, offsetBy: 1)))!-1, component: 0))
                        }
                        
                        if buttonTimeMinutes.substring(with: buttonTimeMinutes.startIndex..<buttonTimeMinutes.index(buttonTimeMinutes.startIndex, offsetBy: 1)) == "0" {
                            if buttonTimeMinutes.substring(with: buttonTimeMinutes.index(buttonTimeMinutes.startIndex, offsetBy: 1)..<buttonTimeMinutes.index(buttonTimeMinutes.startIndex, offsetBy: 2)) == "0" {
                                pickerVC?.shouldSelectRows.append(self.rowForValue(0, component: 1))
                            } else {
                                pickerVC?.shouldSelectRows.append(self.rowForValue((Int(buttonTimeMinutes.substring(with: buttonTimeMinutes.index(buttonTimeMinutes.startIndex, offsetBy: 1)..<buttonTimeMinutes.index(buttonTimeMinutes.startIndex, offsetBy: 2)))!%5)+1, component: 1))
                            }
                            
                        } else {
                            pickerVC?.shouldSelectRows.append(self.rowForValue(Int(buttonTimeMinutes)!/5, component: 1))
                        }
                        
                        if let popoverPC = pickerVC!.popoverPresentationController {
                            popoverPC.sourceView = sender
                            
                            popoverPC.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.height/2,width: 0,height: 0)
                            
                            popoverPC.delegate = self
                            
                            pickerVC!.preferredContentSize = CGSize(width: 120, height: 200)
                        }
                        
                        self.navigationController.present(pickerVC!, animated: true, completion: {})
    }
    
    func saveTimetable(_ time: String, typeOfButton: Int, id: Int) {
        timeTable = UserDefaults.standard.value(forKey: "Timetable") as! [[String]]
        timeTable[id][typeOfButton] = time
        UserDefaults.standard.setValue(timeTable, forKey: "Timetable")
        UserDefaults.standard.synchronize()
    }

    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        var myTitle = ""
        if component == 1 {
            myTitle = valueForRowInComponent(row, component: 1)
        } else {
            myTitle = valueForRowInComponent(row, component: 0)
        }
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = myTitle
        pickerLabel.font = UIFont.appSemiBoldFont(20)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 { return pickerViewRows}
        return pickerViewRows
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var sourceText = pressedButton.titleLabel!.text!
        if component == 0 {
            var hour = hours[row%hours.count]
            if hour.count == 1 {
                hour = "0"+hour
            }
            sourceText.replaceSubrange(sourceText.startIndex..<sourceText.index(sourceText.startIndex, offsetBy: 2), with: hour)
        } else {
            let minute = minutes[row%minutes.count]

            sourceText.replaceSubrange(sourceText.index(sourceText.startIndex, offsetBy: 3)..<sourceText.index(sourceText.startIndex, offsetBy: 3+2), with: minute)
        }
        
        UIView.performWithoutAnimation({
            self.pressedButton.setTitle(sourceText, for: UIControl.State())
            self.pressedButton.layoutIfNeeded()
            
            if self.pressedButton == self.startTimeButton {
                
                self.saveTimetable(sourceText, typeOfButton: 0, id: self.id)
                
                var buttonTimeHours = sourceText.substring(with: sourceText.startIndex..<sourceText.index(sourceText.startIndex, offsetBy: 2))
                var buttonTimeMinutes = sourceText.substring(with: sourceText.index(sourceText.startIndex, offsetBy: 3)..<sourceText.index(sourceText.startIndex, offsetBy: 5))
                if buttonTimeHours.count == 2 && buttonTimeHours.substring(with: buttonTimeHours.index(buttonTimeHours.startIndex, offsetBy: 0)..<buttonTimeHours.index(buttonTimeHours.startIndex, offsetBy: 1)) == "0"{
                    buttonTimeHours = buttonTimeHours.substring(with: buttonTimeHours.index(buttonTimeHours.startIndex, offsetBy: 1)..<buttonTimeHours.index(buttonTimeHours.startIndex, offsetBy: 2))
                }
                if buttonTimeMinutes.count == 2 && buttonTimeMinutes.substring(with: buttonTimeMinutes.index(buttonTimeMinutes.startIndex, offsetBy: 0)..<buttonTimeMinutes.index(buttonTimeMinutes.startIndex, offsetBy: 1)) == "0"{
                    buttonTimeHours = buttonTimeMinutes.substring(with: buttonTimeMinutes.index(buttonTimeMinutes.startIndex, offsetBy: 1)..<buttonTimeMinutes.index(buttonTimeMinutes.startIndex, offsetBy: 2))
                }
                
                var finalEndTime = Int(buttonTimeHours)! * 60 + Int(buttonTimeMinutes)!
                finalEndTime += UserDefaults.standard.integer(forKey: "OneLessonTime")
                
                buttonTimeHours = "\(finalEndTime/60)"
                buttonTimeMinutes = "\(finalEndTime%60)"
                
                if buttonTimeHours.count == 1 {
                    buttonTimeHours = "0" + buttonTimeHours
                }
                if buttonTimeMinutes.count == 1 {
                    buttonTimeMinutes = "0" + buttonTimeMinutes
                }
                endTime = buttonTimeHours+":"+buttonTimeMinutes
                self.endTimeButtom.titleLabel?.text = endTime
                self.saveTimetable(endTime, typeOfButton: 1, id: self.id)
            } else {
                self.saveTimetable(sourceText, typeOfButton: 1, id: self.id)
            }
        })
        
        if component == 0 {
            let newRow = pickerViewMiddleHours + (row % hours.count)
            pickerView.selectRow(newRow, inComponent: 0, animated: false)
        } else {
            let newRow = pickerViewMiddleMinutes + (row % minutes.count)
            pickerView.selectRow(newRow, inComponent: 1, animated: false)
        }

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
