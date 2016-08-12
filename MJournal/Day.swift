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
    
    func allLessons() -> [Lesson] {
//        NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
//        NSArray *sorted = [yourSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
        let descriptor = NSSortDescriptor(key: "id", ascending: true)
        return lessons?.sortedArrayUsingDescriptors([descriptor]) as! [Lesson]
    }

}
