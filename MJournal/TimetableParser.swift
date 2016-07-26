//
//  TimetableParser.swift
//  MJournal
//
//  Created by Michael on 06.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import Foundation

class TimetableParser {
    static var timeTable = TimetableParser.getTimetable()
    
    private class func getTimetable() -> NSMutableDictionary {
        let file = NSMutableDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Timetable", ofType: "plist")!)!

        return file
    }
    
    func getCurrentSubject(complition: (subj: String, nextSubj: String) -> Void) -> String {
        let subjects = TimetableParser.timeTable["Regular"] as! NSArray
        for (i, subj) in subjects.enumerate() {
            let end = subj["End"] as! String
            let endTime = end.characters.split{$0 == ":"}.map(String.init)
            if Int(endTime[0]) > Time.getHour() {
                complition(subj: SheduleParser.shedule[Time.getDay()][i] as! String,
                    nextSubj: SheduleParser.shedule[Time.getDay()][i+1] as! String)
                return ""
            }
        }
        
        return "Нет урока"
    }
}