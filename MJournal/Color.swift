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
            return UIColor(red: 105/255, green: 141/255, blue: 169/225, alpha: alpha)
        case "Tuesday":
            return UIColor(red: 159/255, green: 76/255, blue: 78/225, alpha: alpha)
        case "Wednesday":
            return UIColor(red: 141/255, green: 111/255, blue: 153/225, alpha: alpha)
        case "Thursday":
            return UIColor(red: 108/255, green: 129/255, blue: 96/225, alpha: alpha)
        case "Friday":
            return UIColor(red: 176/255, green: 174/255, blue: 124/225, alpha: alpha)
        case "Saturday":
            return UIColor(red: 76/255, green: 86/255, blue: 108/225, alpha: alpha)
        default:
            return UIColor.whiteColor()
        }
    }
}
