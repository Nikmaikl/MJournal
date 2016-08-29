//
//  Lesson+CoreDataProperties.swift
//  MJournal
//
//  Created by Michael Nikolaev on 04.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Lesson {

    @NSManaged var name: String?
    @NSManaged var startTime: String?
    @NSManaged var endTime: String?
    @NSManaged var type: String?
    @NSManaged var place: String?
    @NSManaged var professor: String?
    @NSManaged var notes: String?
    @NSManaged var day: Day?
    @NSManaged var audience: String?
    @NSManaged var id: NSNumber?
    @NSManaged var isEven: NSNumber?
    @NSManaged var number: NSNumber?
}
