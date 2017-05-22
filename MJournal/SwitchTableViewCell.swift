//
//  SwitchCollectionViewCell.swift
//  MJournal
//
//  Created by Michael Nikolaev on 07.02.17.
//  Copyright © 2017 Ocode. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var titleLbl: UILabel!
    
    var delegate: SwitchedColorDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.font = UIFont.appMediumFont(17)
        
        switcher.setOn(UserDefaults.standard.bool(forKey: "white_theme"), animated: false)
        self.backgroundColor = UIColor.darkBackground()
        self.titleLbl.textColor = UIColor.navigationBarTintColor()
    }
    
    @IBAction func swichTheme(_ sender: Any) {
        if switcher.isOn {
            UserDefaults.standard.set(true, forKey: "white_theme")
            self.backgroundColor =  UIColor.white
            self.titleLbl.textColor = UIColor(red: 31/255, green: 31/255, blue: 31/225, alpha: 1.0)
        } else {
            UserDefaults.standard.set(false, forKey: "white_theme")
            self.backgroundColor =   UIColor(red: 31/255, green: 31/255, blue: 31/225, alpha: 1.0)
            self.titleLbl.textColor = UIColor.white
        }
        delegate.switchedColor()
    }
}
