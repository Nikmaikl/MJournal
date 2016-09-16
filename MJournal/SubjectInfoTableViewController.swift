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
            //self.title = lesson?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trashBarButton = UIBarButtonItem(image: UIImage(named: "Trash_can"), style: .plain, target: self, action: #selector(trashIt))
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneIt))//(image: 
        
        noteTextField.delegate = self
        noteTextField.font = UIFont.appMediumFont(17)
        titleLabel.font = UIFont.appSemiBoldFont(17)
        
        self.noteTextField.alwaysBounceVertical = true
        self.noteTextField.text = lesson?.notes
        
        navigationItem.rightBarButtonItems = [doneBarButton, trashBarButton]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noteTextField.becomeFirstResponder()
    }
    
    func trashIt() {
        let deleteVC = navigationController!.storyboard?.instantiateViewController(withIdentifier: "DeleteVC") as? DeleteViewController
        
        deleteVC?.modalPresentationStyle = .popover
        deleteVC?.deleteDelegate = self
        deleteVC?.currentDay = lesson!.day
        deleteVC?.lesson = lesson
        
        if let popoverPC = deleteVC!.popoverPresentationController {
            let sourceView: UIView!
            if navigationItem.rightBarButtonItems?.count == 2 {
                sourceView = navigationItem.rightBarButtonItems?[1].value(forKey: "view") as? UIView
            } else {
                sourceView = navigationItem.rightBarButtonItems?[0].value(forKey: "view") as? UIView
            }

            popoverPC.sourceView = sourceView
            
            popoverPC.sourceRect = CGRect(x: sourceView!.bounds.midX-10, y: sourceView!.bounds.height,width: 0,height: 0)
            popoverPC.permittedArrowDirections = .up
            
            popoverPC.delegate = self
            deleteVC!.preferredContentSize = CGSize(width: 280, height: 55)
        }
        
        navigationController!.present(deleteVC!, animated: true, completion: {
        })
    }
    
    func doneIt() {
        FIRAnalytics.logEvent(withName: "savedNote", parameters: ["text": noteTextField.text as NSObject])
        noteTextField.resignFirstResponder()
        navigationItem.rightBarButtonItems?.removeFirst()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        lesson?.notes = textView.text
        CoreDataHelper.instance.save()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItems = [doneBarButton, trashBarButton]
    }
    
    @IBAction func rightBarButtonPressed(_ sender: AnyObject) {
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func delete() {
        navigationController?.popViewController(animated: true)
        refreshDelegate.refresh()
    }
}
