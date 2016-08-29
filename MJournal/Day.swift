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

    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName("Day", inManagedObjectContext: CoreDataHelper.instance.context)!
    }
    
    convenience init() {
        self.init(entity: Day.entity, insertIntoManagedObjectContext: CoreDataHelper.instance.context)
    }
    
    convenience init(name:String) {
        self.init()
        self.name = name
    }
    
    class func allDays() -> [Day] {
        let request = NSFetchRequest(entityName: "Day")
        
        
        var results: [AnyObject]?
        do {
            results = try CoreDataHelper.instance.context.executeFetchRequest(request)
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
        let lessonsArray = lessons?.sortedArrayUsingDescriptors([descriptor]) as! [Lesson]
        var finalArray = [Lesson]()
        
        for lesson in lessonsArray {
            if (lesson.isEven == true) {
                finalArray.append(lesson)
            }
        }
        
        return finalArray
    }

    func getEvenLesson(id: Int) -> Lesson? {
        for lesson in allEvenLessons() {
            if lesson.id == id {
                return lesson
            }
        }
        return nil
    }
    
    func getNotEvenLesson(id: Int) -> Lesson? {
        for lesson in allNotEvenLessons() {
            if lesson.id == id {
                return lesson
            }
        }
        return nil
    }
    
    func allNotEvenLessons() -> [Lesson] {
        let descriptor = NSSortDescriptor(key: "id", ascending: true)
        let lessonsArray = lessons?.sortedArrayUsingDescriptors([descriptor]) as! [Lesson]
        var finalArray = [Lesson]()
        
        for lesson in lessonsArray {
            if (lesson.isEven == false) {
                finalArray.append(lesson)
            }
        }
        
        return finalArray
    }
}
