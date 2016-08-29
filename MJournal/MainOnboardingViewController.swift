//
//  MainOnboardingViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 20.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class MainOnboardingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        titleLabel.font = UIFont.appMediumFont(20)
        detailLabel.font = UIFont.appMediumFont()
        mainButton.titleLabel?.font = UIFont.appSemiBoldFont()
        detailLabel.text = "Для начала настройте время занятий\nЭто не займет много времени"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
