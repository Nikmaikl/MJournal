//
//  SubjectInfoTableViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 28.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics

protocol RefreshLessonsDelegate: class {
    func refresh()
}

class SubjectInfoTableViewController: UIViewController, UITextViewDelegate, UIPopoverPresentationControllerDelegate, DeleteLessonDelegate {

    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var doneBarButton, trashBarButton: UIBarButtonItem!
    
    weak var refreshDelegate: RefreshLessonsDelegate!
    
    var lesson: Lesson? {
        didSet {
            self.title = lesson?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trashBarButton = UIBarButtonItem(image: UIImage(named: "Trash_can"), style: .Plain, target: self, action: #selector(trashIt))
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneIt))//(image: 
        
        noteTextField.delegate = self
        noteTextField.font = UIFont.appMediumFont(17)
        titleLabel.font = UIFont.appSemiBoldFont(17)
        
        self.noteTextField.alwaysBounceVertical = true
        self.noteTextField.text = lesson?.notes
        
        if noteTextField.text == "" {
            noteTextField.becomeFirstResponder()
            navigationItem.rightBarButtonItem = doneBarButton
        } else {
            navigationItem.rightBarButtonItem = trashBarButton
        }
    }
    
    func trashIt() {
        let deleteVC = navigationController!.storyboard?.instantiateViewControllerWithIdentifier("DeleteVC") as? DeleteViewController
        
        deleteVC?.modalPresentationStyle = .Popover
        deleteVC?.deleteDelegate = self
        deleteVC?.currentDay = lesson!.day
        deleteVC?.lesson = lesson
        
        if let popoverPC = deleteVC!.popoverPresentationController {
            let sourceView = navigationItem.rightBarButtonItem?.valueForKey("view") as? UIView
            popoverPC.sourceView = sourceView
            
            popoverPC.sourceRect = CGRectMake(CGRectGetMidX(sourceView!.bounds)-10, sourceView!.bounds.height,0,0)
            popoverPC.permittedArrowDirections = .Up
            
            popoverPC.delegate = self
            deleteVC!.preferredContentSize = CGSize(width: 280, height: 55)
        }
        
        navigationController!.presentViewController(deleteVC!, animated: true, completion: {
        })
    }
    
    func doneIt() {
        FIRAnalytics.logEventWithName("savedNote", parameters: ["text": noteTextField.text])
        noteTextField.resignFirstResponder()
        navigationItem.rightBarButtonItem = trashBarButton
    }
    
    func textViewDidChange(textView: UITextView) {
        lesson?.notes = textView.text
        CoreDataHelper.instance.save()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    @IBAction func rightBarButtonPressed(sender: AnyObject) {
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func delete() {
        navigationController?.popViewControllerAnimated(true)
        refreshDelegate.refresh()
    }
}
