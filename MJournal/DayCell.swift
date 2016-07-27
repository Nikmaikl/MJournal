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
//    @IBOutlet weak var dayImage: UIImageView!
    
    @IBOutlet weak var nowLabel: UILabel!
    
    var todayDay = false
    
    var day: String! {
        didSet {
            let dayImage = UIImage(named: self.day)
            self.dayName.text = NSLocalizedString(self.day, comment: "Day")
//            self.dayImage.image = dayImage
//            self.dayImage.bounds.size = dayImage!.size
            if todayDay {
                self.nowLabel.hidden = false
            }
        }
    }
}
