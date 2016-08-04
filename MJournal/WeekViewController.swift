//
//  WeekCollectionViewController.swift
//  MJournal
//
//  Created by Michael on 04.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CellDay"

class WeekCollectionViewController: UICollectionViewController {

    var dayNumber: Int = 0
    var colorForCell: UIColor = UIColor.blackColor()
    let currentDayIndex = NSIndexPath(forRow: Time.getDay(), inSection: 0)
    
    var currentLongPressingRow:NSIndexPath? = nil
    
    var screenSize: CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    let defaultCornerRadius: CGFloat = 10.0
    let defaultSpace: CGFloat = 16.0
    
    var lpgr: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numberOfItemsPerSmallerSide: CGFloat = 2
        let width = (min(screenSize.height, screenSize.width) - defaultSpace * 3) / numberOfItemsPerSmallerSide
        
        let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: width, height: width)
        layout?.minimumLineSpacing = defaultSpace
        layout?.minimumInteritemSpacing = defaultSpace
        
        collectionView!.contentInset = UIEdgeInsets(top: defaultSpace, left: defaultSpace, bottom: defaultSpace, right: defaultSpace)
        
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.1
        self.collectionView!.addGestureRecognizer(lpgr)
    }
    
    func handleLongPress(lgr: UILongPressGestureRecognizer) {
        let p = lgr.locationInView(self.collectionView)
        let indexPath = self.collectionView?.indexPathForItemAtPoint(p)
        
        if indexPath != nil && (currentLongPressingRow?.row == indexPath!.row || currentLongPressingRow == nil) {
            currentLongPressingRow = indexPath
            let cell = collectionView!.cellForItemAtIndexPath(indexPath!)
            UIView.animateWithDuration(0.2, animations: {
                if lgr.state == .Ended {
                    cell!.transform = CGAffineTransformMakeScale(1, 1)
                } else {
                    cell!.transform = CGAffineTransformMakeScale(0.85, 0.85)
                }
                }, completion: { b->Void in
                    if lgr.state == .Ended {
                        self.currentLongPressingRow = nil
                    }
            })
        } else if (currentLongPressingRow != nil && (currentLongPressingRow?.row != indexPath?.row ||
        indexPath == nil)) {
            let cell = collectionView!.cellForItemAtIndexPath(currentLongPressingRow!)
            UIView.animateWithDuration(0.2, animations: {
                cell!.transform = CGAffineTransformMakeScale(1, 1)
                self.currentLongPressingRow = nil
                })

        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = .Black
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func highlightCurrentDay() {
        let currentCell = collectionView?.cellForItemAtIndexPath(currentDayIndex) as? DayCell
        
        currentCell?.mainView.colorForFill = UIColor.getColorForCell(withRow: currentDayIndex.row, alpha: 0.2)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let moreInfo = segue.destinationViewController as? DaySheduleViewController {
            moreInfo.dayNumber = self.dayNumber
            moreInfo.colorForBar = self.colorForCell
            if dayNumber == currentDayIndex.row {
                moreInfo.title = NSLocalizedString("Today", comment: "Today")
            } else {
                moreInfo.title = NSLocalizedString(WeekDays.days[dayNumber], comment: "Day")
            }
            
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeekDays.days.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? DayCell
        
        if currentDayIndex.row == indexPath.row {
            cell?.todayDay = true
        }
        
        cell?.day = WeekDays.days[indexPath.row]
        cell?.mainView.colorForBezel = UIColor.getColorForCell(withRow: indexPath.row, alpha: 1)

        
        return cell!
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let _ = collectionView.cellForItemAtIndexPath(indexPath) as? DayCell
        dayNumber = indexPath.row
        colorForCell = UIColor.getColorForCell(withRow: indexPath.row, alpha: 1)
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if let dayCell = cell as? DayCell {
            UIView.animateWithDuration(0.2, animations: {
                dayCell.transform = CGAffineTransformMakeScale(0.8, 0.8)
                }, completion: { b->Void in
                    UIView.animateWithDuration(0.05, animations: {
                        dayCell.transform = CGAffineTransformMakeScale(1, 1)
                        }, completion: { b->Void in
                            self.performSegueWithIdentifier("MoreInfo", sender: self)
                    })
            })
        }
        

    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? DayCell
        
        cell?.mainView?.colorForFill = UIColor.whiteColor()
        cell?.mainView.setNeedsDisplay()
        
    }
}
