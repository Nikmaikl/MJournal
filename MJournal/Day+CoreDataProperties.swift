//
//  Day+CoreDataProperties.swift
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

extension Day {

    @NSManaged var name: String?
    @NSManaged var lessons: NSMutableSet?

}
