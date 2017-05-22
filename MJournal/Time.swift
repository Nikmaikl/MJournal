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
    
    static func yesterDay(daysToAdd: Int, sinceDay: Date) -> Int {
        let yesterday = NSCalendar.current.date(byAdding: .day, value: daysToAdd, to: sinceDay)
        
        let components = NSCalendar.current.dateComponents([.day], from: yesterday! as Date)
        
        return components.day!
    }
    
    static func getYesterDay(daysToAdd: Int) -> Date {
        let yesterday = NSCalendar.current.date(byAdding: .day, value: daysToAdd, to: Date())
        
        return yesterday!
    }
    
    static func getYesterDayMonth(daysToAdd: Int, sinceDate: Date) -> Int {
        let yesterday = NSCalendar.current.date(byAdding: .day, value: daysToAdd, to: sinceDate)
        let components = NSCalendar.current.dateComponents([.month], from: yesterday! as Date)
        
        return components.month!
    }
    
    static func getFirstSchoolWeek() -> Int {
        let userCalendar = Calendar.current
        
        var dateComps = DateComponents()
        dateComps.year = Time.getYear()
        dateComps.month = 8
        dateComps.day = 1
        let date = userCalendar.date(from: dateComps)!
        var components = userCalendar.dateComponents([.weekOfYear], from: date)
        
        return components.weekOfYear!
    }
    
    static func getWeekNumber() -> Int {
        return getComponent(NSCalendar.Unit.weekOfMonth)
    }
    
    static func getWeekYearNumber() -> Int {
        return getComponent(NSCalendar.Unit.weekOfYear)-1
    }
    
    static func isEvenWeek() -> Bool {
        if (Time.getWeekYearNumber() - Time.getFirstSchoolWeek()) % 2 == 0 {
            return false //Правильно true
        }
        return true //Правильно false
    }
    
    static func daysForTheWeek() -> [NSMutableDictionary] {
        let calendar = NSCalendar.current
        let dateComponent = NSDateComponents()
        let dateStr          = "\(Time.getYear())-\(Time.getMonth())-\(Time.getFirstDay(weekNumber: Time.getWeekNumber()))"
        let formatter        = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let currDate         = formatter.date(from: dateStr)
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
