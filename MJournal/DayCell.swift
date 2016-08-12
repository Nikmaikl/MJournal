//
//  DayCell.swift
//  MJournal
//
//  Created by Michael on 04.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: DayCellView!
    @IBOutlet weak var dayName: UILabel!
    
    @IBOutlet weak var nowLabel: UILabel!
    
    var todayDay = false
    
    var day: String! {
        didSet {
            self.dayName.text = NSLocalizedString(self.day, comment: "Day")
            self.dayName.font = UIFont.appSemiBoldFont()
            if todayDay {
                self.nowLabel.hidden = false
            }
        }
    }
}
