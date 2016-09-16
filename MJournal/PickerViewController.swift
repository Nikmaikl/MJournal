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
    
    var shouldSelectTypeOfLesson = ""
    
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
        
        if presentationVC!.arrowDirection == .up {
            presentationVC!.sourceRect = upRect
        } else if presentationVC!.arrowDirection == .down {
            presentationVC!.sourceRect = downRect
        }
        
        if controller == "Shedule" {
            for (i, row) in shouldSelectRows.enumerated() {
                pickerView.selectRow(row, inComponent: i, animated: false)
            }
        } else {
            for (i, lessonType) in typeOfLesson.enumerated() {
                if shouldSelectTypeOfLesson == lessonType {
                    pickerView.selectRow(i, inComponent: 0, animated: false)
                }
            }
        }
        
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOfLesson[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let myTitle = typeOfLesson[row]
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = myTitle
        pickerLabel.font = UIFont.appSemiBoldFont(20)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfLesson.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate!.saveTypeLesson?(typeOfLesson[row])
    }
}
