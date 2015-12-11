//
//  Color.swift
//  MJournal
//
//  Created by Michael on 06.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit

extension UIColor {
    class func getColorForCell(withRow row: Int, alpha: CGFloat) -> UIColor {
        switch WeekDays.days[row] {
        case "Monday":
            return UIColor(red: 62/255, green: 165/255, blue: 224/225, alpha: alpha)
        case "Tuesday":
            return UIColor(red: 190/255, green: 34/255, blue: 53/225, alpha: alpha)
        case "Wednesday":
            return UIColor(red: 143/255, green: 70/255, blue: 206/225, alpha: alpha)
        case "Thursday":
            return UIColor(red: 73/255, green: 121/255, blue: 18/225, alpha: alpha)
        case "Friday":
            return UIColor(red: 190/255, green: 180/255, blue: 53/225, alpha: alpha)
        case "Saturday":
            return UIColor(red: 140/255, green: 138/255, blue: 140/225, alpha: alpha)
        default:
            return UIColor.whiteColor()
        }
    }
}
