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

    @IBAction func deleteLesson(_ sender: AnyObject) {
        dismiss(animated: true, completion: { self.deleteDelegate.delete() })
        
        var lessons = currentDay.allNotEvenLessons()
        
        lessons.remove(at: Int(lesson.id!))
        var evenLessons = currentDay.allEvenLessons()
        
        if currentDay.getEvenLesson(Int(lesson.id!)) != nil {
            evenLessons.remove(at: Int(lesson.id!))
        }
        lessons += evenLessons
        currentDay.lessons = NSMutableSet(array: lessons)
        CoreDataHelper.instance.save()
    }
}
