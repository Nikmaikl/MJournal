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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.view.backgroundColor = UIColor.clearColor()
        self.modalTransitionStyle = .CoverVertical
        self.modalPresentationStyle = .OverCurrentContext
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TypesOfLesson.types[row]
    }
    
    @IBAction func readyButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName("ChosenType", object: nil, userInfo:["Type":TypesOfLesson.types[0]])
        })
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TypesOfLesson.types.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        if sender = readyButton {
//            if let destVC = segue.destinationViewController as? SubjectTableViewCell {
////                destVC.
//            }
//        }
    }
 

}
