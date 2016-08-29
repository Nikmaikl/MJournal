//
//  SubjectInfoTableViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 28.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

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
//            startTimeHour.text = hour
//            startTimeMin.text = min
//            endTime.text = lesson!.endTime
            
//            audienceNumberField.text = lesson?.audience
//            professorNameLabel.text = lesson?.professor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trashBarButton = UIBarButtonItem(image: UIImage(named: "Trash_can"), style: .Plain, target: self, action: #selector(trashIt))
        doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneIt))//(image: UIImage(named: "Trash_can"), style: .Plain, target: self, action: #selector(trashIt))

//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 40
        
        noteTextField.delegate = self
        noteTextField.font = UIFont.appMediumFont(14)
        titleLabel.font = UIFont.appSemiBoldFont(17)
        
        self.noteTextField.alwaysBounceVertical = true
        self.noteTextField.text = lesson?.notes
        
        if noteTextField.text == "" {
            noteTextField.becomeFirstResponder()
            navigationItem.rightBarButtonItem = doneBarButton
        } else {
            navigationItem.rightBarButtonItem = trashBarButton
        }
        
        
        
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 40
        
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
//        dismissViewControllerAnimated(true, completion: {
//            var lessons = self.lesson!.day!.allNotEvenLessons()
//            var evenLessons = self.lesson!.day!.allEvenLessons()
//            lessons.removeAtIndex(Int(self.lesson!.id!))
//            
//            evenLessons.removeAtIndex(Int(self.lesson!.id!))
//            lessons += evenLessons
//            self.lesson!.day!.lessons = NSMutableSet(array: lessons)
//            CoreDataHelper.instance.save()
//        })
    }
    
//    func textViewDidChange(textView: UITextView) {
//        let fixedWidth = textView.frame.size.width
//        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
//        var newFrame = textView.frame
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        textView.frame = newFrame;
//    }

    // MARK: - Table view data source



    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
