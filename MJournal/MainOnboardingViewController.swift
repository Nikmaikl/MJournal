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
}
