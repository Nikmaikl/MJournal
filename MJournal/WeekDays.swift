//
//  WeekDays.swift
//  MJournal
//
//  Created by Michael on 04.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import Foundation

class WeekDays {
    static var days = WeekDays.getDays()
    
    private class func getDays() -> Array<String> {
        return Array(arrayLiteral: "Monday", "Tuesday", "Wednesday",
            "Thursday", "Friday", "Saturday")
    }
}