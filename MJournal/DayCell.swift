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
    @IBOutlet weak var dayImage: UIImageView!
    
    var day: String! {
        didSet {
            let dayImage = UIImage(named: self.day)
            self.dayName.text = day
            self.dayImage.image = dayImage
            self.dayImage.bounds.size = dayImage!.size
        }
    }
}
