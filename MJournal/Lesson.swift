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