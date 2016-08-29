//
//  DeleteViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 26.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

protocol DeleteLessonDelegate: class {
    func delete()
}

class DeleteViewController: UIViewController {

    var lesson: Lesson!
    var currentDay: Day!
    
    weak var deleteDelegate: DeleteLessonDelegate!

    @IBAction func deleteLesson(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: { self.deleteDelegate.delete() })
        print(lesson.id!)
        var lessons = currentDay.allNotEvenLessons()
        lessons.removeAtIndex(Int(lesson.id!))
        var evenLessons = currentDay.allEvenLessons()
        
        if currentDay.getEvenLesson(Int(lesson.id!)) != nil {
            evenLessons.removeAtIndex(Int(lesson.id!))
        }
        lessons += evenLessons
        currentDay.lessons = NSMutableSet(array: lessons)
        CoreDataHelper.instance.save()
    }
}