//
//  Lesson.swift
//  MJournal
//
//  Created by Michael Nikolaev on 28.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import Foundation

class Lesson {
    var name: String!
    var startTime, endTime: String!
    var type, place: String?
    var professor: String?
    
    init(name: String, startTime: String, endTime: String, type: String?, place: String?, professor: String?) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
        self.place = place
        self.professor = professor
    }
}

class TypesOfLesson {
    static var types = ["Лекция", "Семинар", "Практическое занятие", "Лабораторная работа"]
}

class Data {
    static var lessons = Data.getLessons()
    
    class func getLessons() -> [[Lesson]] {
        return [[Lesson(name: "Физика", startTime: String(TimetableParser.timeTable["Regular"]![0]["Start"] as! String), endTime: String(TimetableParser.timeTable["Regular"]![0]["End"] as! String), type: nil, place: nil, professor: nil)]]
    }
}