//
//  Day.swift
//  MJournal
//
//  Created by Michael Nikolaev on 04.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit
import CoreData


class Day: NSManagedObject {

    class var entityDescr: NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: "Day", in: CoreDataHelper.instance.context)!
    }
    
    convenience init() {
        self.init(entity: Day.entityDescr, insertInto: CoreDataHelper.instance.context)
    }
    
    convenience init(name:String) {
        self.init()
        self.name = name
    }
    
    class func allDays() -> [Day] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        
        var results: [AnyObject]?
        do {
            results = try CoreDataHelper.instance.context.fetch(request)
        } catch _ {
            results = nil
        }
        
        return results as! [Day]
    }
    
//    func allLessons() -> [Lesson] {
//        let descriptor = NSSortDescriptor(key: "id", ascending: true)
//        return lessons?.sortedArrayUsingDescriptors([descriptor]) as! [Lesson]
//    }
    
    
    
    func allEvenLessons() -> [Lesson] {
        let descriptor = NSSortDescriptor(key: "id", ascending: true)
        let lessonsArray = lessons?.sortedArray(using: [descriptor]) as! [Lesson]
        var finalArray = [Lesson]()
        
        for lesson in lessonsArray {
            if (lesson.isEven == true) {
                finalArray.append(lesson)
            }
        }
        
        return finalArray
    }

    func getEvenLesson(_ id: Int) -> Lesson? {
        for lesson in allEvenLessons() {
            if Int(lesson.id!) == id {
                return lesson
            }
        }
        return nil
    }
    
    func getNotEvenLesson(_ id: Int) -> Lesson? {
        for lesson in allNotEvenLessons() {
            if Int(lesson.id!) == id {
                return lesson
            }
        }
        return nil
    }
    
    func allNotEvenLessons() -> [Lesson] {
        let descriptor = NSSortDescriptor(key: "id", ascending: true)
        let lessonsArray = lessons?.sortedArray(using: [descriptor]) as! [Lesson]
        var finalArray = [Lesson]()
        
        for lesson in lessonsArray {
            if (lesson.isEven == false) {
                finalArray.append(lesson)
            }
        }
        
        return finalArray
    }
}
