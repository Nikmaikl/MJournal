//
//  Lesson.swift
//  MJournal
//
//  Created by Michael Nikolaev on 04.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit
import CoreData

class Lesson: NSManagedObject {
    
    class var entityDescr: NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: "Lesson", in: CoreDataHelper.instance.context)!
    }
    
    convenience init() {
        self.init(entity: Lesson.entityDescr, insertInto: CoreDataHelper.instance.context)
    }
    
//    class func allLessons() -> [Lesson] {
//        let request = NSFetchRequest(entityName: "Lesson")
//        
//        
//        var results: [AnyObject]?
//        do {
//            results = try CoreDataHelper.instance.context.executeFetchRequest(request)
//        } catch _ {
//            results = nil
//        }
//        
//        return results as! [Lesson]
//    }
}
