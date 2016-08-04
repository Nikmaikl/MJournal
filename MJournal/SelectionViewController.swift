//
//  SelectionViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 30.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var readyButton: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    
    var selectedRow:Int? = 0
    var sourceRow = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        sourceRow = TypesOfLesson.types[3]
        
        self.view.backgroundColor = UIColor.clearColor()
        self.modalTransitionStyle = .CoverVertical
        self.modalPresentationStyle = .OverCurrentContext
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TypesOfLesson.types[row]
    }
    
    @IBAction func readyButtonPressed(sender: AnyObject) {
        if let extractSelectedRow = selectedRow {
            NSNotificationCenter.defaultCenter().postNotificationName("ChosenType", object: nil, userInfo:["Type":TypesOfLesson.types[extractSelectedRow]])
        }
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ChosenType", object: nil)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func editButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func undoButtonPressed(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("ChosenType", object: nil, userInfo:["Type":self.sourceRow])
        NSNotificationCenter.defaultCenter().removeObserver(self.presentingViewController!, name: "ChosenType", object: nil)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TypesOfLesson.types.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
    }
}