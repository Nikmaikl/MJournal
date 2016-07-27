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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class Setting {
    var icon: UIImageView!
    var name: String!
}
