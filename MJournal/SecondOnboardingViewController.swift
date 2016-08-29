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
        self.navigationController?.navigationBar.barStyle = .Black
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            forBarPosition: .Any,
            barMetrics: .Default)
        
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.darkBackground()
        navigationController?.navigationBar.translucent = false
        
        titleLabel.font = UIFont.appMediumFont(20)
        mainButton.titleLabel?.font = UIFont.appSemiBoldFont()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        for i in 0 ..< 12 {
            timeArray.append(40+i*5)
        }
        
        pickerView.selectRow(timeArray.count-2, inComponent: 0, animated: true)
        NSUserDefaults.standardUserDefaults().setInteger(timeArray[timeArray.count-2], forKey: "OneLessonTime")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let myTitle = NSAttributedString(string: "\(timeArray[row]) минут", attributes: [NSFontAttributeName:UIFont.appMediumFont(),NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(timeArray[row], forKey: "OneLessonTime")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func mainButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("NextStep", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}
