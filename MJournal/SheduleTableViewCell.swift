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
            startTimeButton.setTitle(startTime, forState: .Normal)
        }
    }
    
    var endTime: String! {
        didSet {
            endTimeButtom.setTitle(endTime, forState: .Normal)
        }
    }
    
    private let pickerViewRows = 10000
    private var pickerViewMiddleHours: Int!
    private var pickerViewMiddleMinutes: Int!
    
    
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
        
        timeTable = NSUserDefaults.standardUserDefaults().valueForKey("Timetable") as! [[String]]
        
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
    
    func valueForRowInComponent(row: Int, component: Int) -> String {
        if component == 0 {
            return hours[row % hours.count]
        } else {
            return minutes[row % minutes.count]
        }
    }
    
    func rowForValue(value: Int, component: Int) -> Int {
        if component == 0 {
            return pickerViewMiddleHours + value
        } else {
            return pickerViewMiddleMinutes + value
        }
    }

    
    @IBAction func timeButtonPressed(sender: UIButton) {
        UIView.animateWithDuration(0.15, animations: {
            sender.transform = CGAffineTransformMakeScale(0.6, 0.6)
            }, completion: { b->Void in
                UIView.animateWithDuration(0.05, animations: {
                    sender.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: { b->Void in
                        let pickerVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("PickerVC") as? PickerViewController
                        
                        
                        self.pressedButton = sender
                        
                        pickerVC!.modalPresentationStyle = .Popover
                        pickerVC!.pickerDelegate = self
                        pickerVC!.pickerDataSource = self
                        pickerVC!.delegate = self
                        pickerVC?.controller = "Shedule"
                        
                        let buttonText = sender.titleLabel!.text!
                        let buttonTimeHours = buttonText.substringWithRange(buttonText.startIndex..<buttonText.startIndex.advancedBy(2))
                        let buttonTimeMinutes = buttonText.substringWithRange(buttonText.startIndex.advancedBy(3)..<buttonText.startIndex.advancedBy(5))
                        
                        if buttonTimeHours.characters.count == 2 {
                            if buttonTimeHours.substringWithRange(buttonText.startIndex..<buttonText.startIndex.advancedBy(1)) == "0" {
                                pickerVC?.shouldSelectRows.append(self.rowForValue(Int(buttonText.substringWithRange(buttonText.startIndex.advancedBy(1)..<buttonText.startIndex.advancedBy(2)))!-1, component: 0))
                            } else {
                                pickerVC?.shouldSelectRows.append(self.rowForValue(Int(buttonText.substringWithRange(buttonText.startIndex..<buttonText.startIndex.advancedBy(2)))!-1, component: 0))
                            }
                        } else {
                            pickerVC?.shouldSelectRows.append(self.rowForValue(Int(buttonText.substringWithRange(buttonText.startIndex..<buttonText.startIndex.advancedBy(1)))!-1, component: 0))
                        }
                        
                        if buttonTimeMinutes.substringWithRange(buttonTimeMinutes.startIndex..<buttonTimeMinutes.startIndex.advancedBy(1)) == "0" {
                            if buttonTimeMinutes.substringWithRange(buttonTimeMinutes.startIndex.advancedBy(1)..<buttonTimeMinutes.startIndex.advancedBy(2)) == "0" {
                                pickerVC?.shouldSelectRows.append(self.rowForValue(0, component: 1))
                            } else {
                                pickerVC?.shouldSelectRows.append(self.rowForValue((Int(buttonTimeMinutes.substringWithRange(buttonTimeMinutes.startIndex.advancedBy(1)..<buttonTimeMinutes.startIndex.advancedBy(2)))!%5)+1, component: 1))
                            }
                            
                        } else {
                            pickerVC?.shouldSelectRows.append(self.rowForValue(Int(buttonTimeMinutes)!/5, component: 1))
                        }
                        
                        if let popoverPC = pickerVC!.popoverPresentationController {
                            popoverPC.sourceView = sender
                            
                            popoverPC.sourceRect = CGRectMake(CGRectGetMidX(sender.bounds), sender.bounds.height/2,0,0)
                            
                            popoverPC.delegate = self
                            
                            pickerVC!.preferredContentSize = CGSize(width: 120, height: 200)
                        }
                        
                        self.navigationController.presentViewController(pickerVC!, animated: true, completion: {})
                })
        })
    }
    
    func saveTimetable(time: String, typeOfButton: Int, id: Int) {
        timeTable = NSUserDefaults.standardUserDefaults().valueForKey("Timetable") as! [[String]]
        timeTable[id][typeOfButton] = time
        NSUserDefaults.standardUserDefaults().setValue(timeTable, forKey: "Timetable")
        NSUserDefaults.standardUserDefaults().synchronize()
        print(NSUserDefaults.standardUserDefaults().valueForKey("Timetable") as! [[String]])
    }

    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        var myTitle = ""
//        if component == 1 {
//            myTitle = minutes[row]
//        } else {
//            myTitle = hours[row]
//        }
//        return NSAttributedString(string: myTitle, attributes: [NSFontAttributeName:UIFont.appBoldFont()])
//    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        var myTitle = ""
        if component == 1 {
            myTitle = valueForRowInComponent(row, component: 1)
        } else {
            myTitle = valueForRowInComponent(row, component: 0)
        }
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = myTitle
        pickerLabel.font = UIFont.appSemiBoldFont(20)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 { return pickerViewRows}
        return pickerViewRows
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var sourceText = pressedButton.titleLabel!.text!
        if component == 0 {
            var hour = hours[row%hours.count]
            if hour.characters.count == 1 {
                hour = "0"+hour
            }
            sourceText.replaceRange(sourceText.startIndex..<sourceText.startIndex.advancedBy(2), with: hour)
        } else {
            let minute = minutes[row%minutes.count]

            sourceText.replaceRange(sourceText.startIndex.advancedBy(3)..<sourceText.startIndex.advancedBy(3+2), with: minute)
        }
        
        UIView.performWithoutAnimation({
            self.pressedButton.setTitle(sourceText, forState: .Normal)
            self.pressedButton.layoutIfNeeded()
            
            if self.pressedButton == self.startTimeButton {
                self.saveTimetable(sourceText, typeOfButton: 0, id: self.id)
            } else {
                self.saveTimetable(sourceText, typeOfButton: 1, id: self.id)
            }
        })
        //        print(id)
        
        if component == 0 {
            let newRow = pickerViewMiddleHours + (row % hours.count)
            pickerView.selectRow(newRow, inComponent: 0, animated: false)
        } else {
            let newRow = pickerViewMiddleMinutes + (row % minutes.count)
            pickerView.selectRow(newRow, inComponent: 1, animated: false)
        }

    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
