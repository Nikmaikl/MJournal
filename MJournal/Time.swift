//
//  Time.swift
//  MJournal
//
//  Created by Michael on 06.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import Foundation

class Time {
    private static var weekDay = Time.getComponent(NSCalendarUnit.Weekday)
    private static var hour = Time.getComponent(NSCalendarUnit.Hour)
    private static var minute = Time.getComponent(NSCalendarUnit.Minute)
    
    static func getDay() -> Int {
        return getComponent(NSCalendarUnit.Weekday)
    }
    
    static func getHour() -> Int {
        return getComponent(NSCalendarUnit.Hour)
    }
    
    static func getMinute() -> Int {
        return getComponent(NSCalendarUnit.Minute)
    }
    
    private class func getComponent(unit: NSCalendarUnit) -> Int {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        if unit == NSCalendarUnit.Weekday {
            return calendar.component(unit, fromDate: date)-2
        }
        
        return calendar.component(unit, fromDate: date)
    }
}