//
//  SecondOnboardingViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 20.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class SecondOnboardingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var timeArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .default)
        
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.darkBackground()
        navigationController?.navigationBar.isTranslucent = false
        
        titleLabel.font = UIFont.appMediumFont(20)
        mainButton.titleLabel?.font = UIFont.appSemiBoldFont()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        for i in 0 ..< 12 {
            timeArray.append(40+i*5)
        }
        
        pickerView.selectRow(timeArray.count-2, inComponent: 0, animated: true)
        UserDefaults.standard.set(timeArray[timeArray.count-2], forKey: "OneLessonTime")
        UserDefaults.standard.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let myTitle = NSAttributedString(string: "\(timeArray[row]) минут", attributes: [NSFontAttributeName:UIFont.appMediumFont(),NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(timeArray[row], forKey: "OneLessonTime")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func mainButtonPressed(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.2, animations: {
            self.mainButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }, completion: { b->Void in
                UIView.animate(withDuration: 0.05, animations: {
                    self.mainButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: { b->Void in
                        self.performSegue(withIdentifier: "NextStep", sender: nil)
                })
        })
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

}
