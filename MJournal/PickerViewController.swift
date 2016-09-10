//
//  PickerViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 16.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIViewControllerTransitioningDelegate {
    
    var typeOfLesson = ["Лекция", "Семинар", "Практическое занятие", "Лабораторная работа", "МФК"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var upRect, downRect: CGRect!
    
    weak var delegate: PickerDelegate?
    
    var pickerDelegate: UIPickerViewDelegate?
    var pickerDataSource: UIPickerViewDataSource?
    
    var shouldSelectRows = [Int]()
    
    var controller: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = self
        
        if pickerDelegate == nil || pickerDataSource == nil {
            pickerView.delegate = self
            pickerView.dataSource = self
        } else {
            pickerView.delegate = pickerDelegate
            pickerView.dataSource = pickerDataSource
        }
        
        let presentationVC = self.popoverPresentationController
        
        if presentationVC!.arrowDirection == .Up {
            presentationVC!.sourceRect = upRect
        } else if presentationVC!.arrowDirection == .Down {
            presentationVC!.sourceRect = downRect
        }
        
        if controller == "Shedule" {
            for (i, row) in shouldSelectRows.enumerate() {
                pickerView.selectRow(row, inComponent: i, animated: false)
            }
        } else {
            for (i, row) in shouldSelectRows.enumerate() {
                pickerView.selectRow(row, inComponent: i, animated: false)
            }
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil

    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOfLesson[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let myTitle = typeOfLesson[row]
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = myTitle
        pickerLabel.font = UIFont.appSemiBoldFont(20)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfLesson.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate!.saveTypeLesson?(typeOfLesson[row])
    }
}
