//
//  SettingsTableViewCell.swift
//  MJournal
//
//  Created by Michael Nikolaev on 26.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var setting: Setting!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont.appMediumFont(17)
        self.backgroundColor = UIColor.darkBackground()
        nameLabel.textColor = UIColor.navigationBarTintColor()
    }

}
