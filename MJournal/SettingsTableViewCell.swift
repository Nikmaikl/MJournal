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
    
    var setting: Setting! {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.font = UIFont.appMediumFont(17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        if (selected) {
//            self.backgroundColor = [UIColor colorWithRed:234.0f/255 green:202.0f/255 blue:255.0f/255 alpha:1.0f];
//        }
//        else {
//            self.backgroundColor = [UIColor clearColor];
//        }
    }

}
