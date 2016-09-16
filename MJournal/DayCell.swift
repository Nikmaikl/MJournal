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
    
    @IBOutlet weak var numberOfDayLabel: UILabel!
    
    var todayDay = false
    
    var dayNumber: Int!
    var dayId:Int!
    
    @IBOutlet weak var placeHolderForDayNumber: UIView!
    
    @IBOutlet weak var placeHolderForDayNumberWidthConstraint: NSLayoutConstraint!
    
        @IBOutlet weak var placeHolderForDayNumberHeightConstraint: NSLayoutConstraint!
    
    var day: String! {
        didSet {
            self.dayName.text = NSLocalizedString(self.day, comment: "Day")
            self.dayName.font = UIFont.appMediumFont()
            self.numberOfDayLabel.font = UIFont.appSemiBoldFont(40)
            if todayDay {
                self.placeHolderForDayNumber.backgroundColor = UIColor.white
                placeHolderForDayNumberWidthConstraint.constant = 58
                placeHolderForDayNumberHeightConstraint.constant = 58
                self.placeHolderForDayNumber.layer.cornerRadius = 29
                numberOfDayLabel.textColor = UIColor.darkBackground()
            } else {
                self.placeHolderForDayNumber.backgroundColor = UIColor.clear
                numberOfDayLabel.textColor = UIColor.white
            }
            
            numberOfDayLabel.text = "\(dayNumber!)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
