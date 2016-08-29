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
    
    var id = -1
    
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
    
    
    var timeTable = NSUserDefaults.standardUserDefaults().valueForKey("Timetable") as! [[String]]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(red: 116, green: 121, blue: 121, alpha: 1.0)
        
        titleLabel.font = UIFont.appMediumFont()
        startTimeButton.titleLabel!.font = UIFont.appMediumFont()
        endTimeButtom.titleLabel!.font = UIFont.appMediumFont()
        
        for i in 1...23 {
            var hour = ""
            if i < 10 { hour = "0\(i)" }
            else { hour = "\(i)" }
            
            hours.append(hour)
        }
        for i in 0...10 {
            var minute = ""
            if i == 0 { minute = "0\(i+5)" }
            else { minute = "\(i*5+5)" }
            
            minutes.append(minute)
        }
    }
    
  
    @IBAction func timeButtonPressed(sender: UIButton) {
        let pickerVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("PickerVC") as? PickerViewController
        
        pressedButton = sender
//        pickerVC?.shouldSelectRows
        
        pickerVC!.modalPresentationStyle = .Popover
        pickerVC!.pickerDelegate = self
        pickerVC!.pickerDataSource = self
        pickerVC!.delegate = self
        
        if let popoverPC = pickerVC!.popoverPresentationController {
            popoverPC.sourceView = sender
            
            popoverPC.sourceRect = CGRectMake(CGRectGetMidX(sender.bounds), sender.bounds.height/2,0,0)
            
            popoverPC.delegate = self
//            popoverPC.permittedArrowDirections = .Up
            
            pickerVC!.preferredContentSize = CGSize(width: 120, height: 200)
        }
        
        navigationController.presentViewController(pickerVC!, animated: true, completion: {
            
        })
    }
    
    func saveTimetable(time: [String], id: Int) {
        timeTable[id][0] = time[0]
        timeTable[id][1] = time[1]
        NSUserDefaults.standardUserDefaults().setValue(timeTable, forKey: "Timetable")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var myTitle = ""
        if component == 1 {
            myTitle = minutes[row]
        } else {
            myTitle = hours[row]
        }
        return NSAttributedString(string: myTitle, attributes: [NSFontAttributeName:UIFont.appMediumFont()])
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 { return minutes.count}
        return hours.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var sourceText = pressedButton.titleLabel!.text!
        if component == 0 {
            sourceText.replaceRange(sourceText.startIndex..<sourceText.startIndex.advancedBy(2), with: hours[row])
                   } else {
            sourceText.replaceRange(sourceText.startIndex.advancedBy(3)..<sourceText.startIndex.advancedBy(3+2), with: minutes[row])
        }
        UIView.performWithoutAnimation({
            self.pressedButton.setTitle(sourceText, forState: .Normal)
            self.pressedButton.layoutIfNeeded()
        })
        
        saveTimetable([startTimeButton.titleLabel!.text!, endTimeButtom.titleLabel!.text!], id: id)

    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
