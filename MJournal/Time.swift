//
//  Time.swift
//  MJournal
//
//  Created by Michael on 06.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import Foundation

class Time {
    
    static func getDay() -> Int {
        return getComponent(NSCalendar.Unit.weekday)
    }
    
    static func getHour() -> Int {
        return getComponent(NSCalendar.Unit.hour)
    }
    
    static func getMinute() -> Int {
        return getComponent(NSCalendar.Unit.minute)
    }
    
    static func getActualDay() -> Int {
        return getComponent(NSCalendar.Unit.day)
    }
    
    static func getMonth() -> Int {
        return getComponent(NSCalendar.Unit.month)
    }
    
    static func getYear() -> Int {
        return getComponent(NSCalendar.Unit.year)
    }
    
    static func getWeekNumber() -> Int {
        return getComponent(NSCalendar.Unit.weekOfMonth)
    }
    
    static func isEvenWeek() -> Bool {
        if getComponent(NSCalendar.Unit.weekOfMonth) % 2 == 0 {
            return true
        }
        
        return false
    }
    
    static func daysForTheWeek() -> [NSMutableDictionary] {
        let calendar = NSCalendar.current
        let dateComponent = NSDateComponents()
        let dateStr          = "\(Time.getYear())-\(Time.getMonth())-\(Time.getFirstDay(weekNumber: Time.getWeekNumber()))"
        let formatter        = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let currDate         = formatter.date(from: dateStr)
        print(Time.getFirstDay(weekNumber: Time.getWeekNumber()))
        var dates = [NSMutableDictionary]()
        
        for i in 1...7
        {
            dateComponent.day = i
            let newDate = calendar.date(byAdding: dateComponent as DateComponents, to: currDate!)
            dates.append(["day": (calendar as NSCalendar).component(.day, from: newDate!), "month": (calendar as NSCalendar).component(.month, from: newDate!)])        }
        
        return dates
    }

    static func getFirstDay(weekNumber:Int)->Int{
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year], from: Date())//(.CalendarUnitYear | .CalendarUnitWeekOfYear | .CalendarUnitWeekday, fromDate: NSDate())
        
        components.calendar = calendar
        
        components.weekday = 2
        components.weekOfYear = weekNumber
        
        
        let firstDayOfWeek = components.date
        return (calendar as NSCalendar).component(.day, from: firstDayOfWeek!)
    }
    
    fileprivate class func getComponent(_ unit: NSCalendar.Unit) -> Int {
        let date = Date()
        let calendar = Calendar.current
        
        if unit == NSCalendar.Unit.weekday {
            return (calendar as NSCalendar).component(unit, from: date)-2
        }
        
        return (calendar as NSCalendar).component(unit, from: date)
    }
}
