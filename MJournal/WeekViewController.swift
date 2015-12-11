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
    
    var screenSize: CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    let defaultCornerRadius: CGFloat = 10.0
    let defaultSpace: CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numberOfItemsPerSmallerSide: CGFloat = 2
        let width = (min(screenSize.height, screenSize.width) - defaultSpace * 3) / numberOfItemsPerSmallerSide
        
        let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: width, height: 144)
        layout?.minimumLineSpacing = defaultSpace
        layout?.minimumInteritemSpacing = defaultSpace
        
        collectionView!.contentInset = UIEdgeInsets(top: defaultSpace, left: defaultSpace, bottom: defaultSpace, right: defaultSpace)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        highlightCurrentDay()
    }
    
    func highlightCurrentDay() {
        let currentCell = collectionView?.cellForItemAtIndexPath(currentDayIndex) as? DayCell
        currentCell?.mainView.colorForFill = UIColor.getColorForCell(withRow: currentDayIndex.row, alpha: 0.08)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let moreInfo = segue.destinationViewController as? DaySheduleViewController {
            moreInfo.dayNumber = self.dayNumber
            moreInfo.colorForBar = self.colorForCell
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeekDays.days.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? DayCell

        cell?.day = WeekDays.days[indexPath.row]
        cell?.mainView.colorForBezel = UIColor.getColorForCell(withRow: indexPath.row, alpha: 1)
        
        return cell!
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? DayCell
        
        cell?.mainView?.colorForFill = UIColor.getColorForCell(withRow: indexPath.row, alpha: 0.6)
        cell?.mainView.setNeedsDisplay()
    }
    
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? DayCell
        
        highlightCurrentDay()
        
        if indexPath != currentDayIndex { cell?.mainView?.colorForFill = UIColor.whiteColor() }
        else { highlightCurrentDay() }
        cell?.mainView.setNeedsDisplay()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        let _ = collectionView.cellForItemAtIndexPath(indexPath) as? DayCell
        dayNumber = indexPath.row
        colorForCell = UIColor.getColorForCell(withRow: indexPath.row, alpha: 1)
        
        performSegueWithIdentifier("MoreInfo", sender: self)
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? DayCell
        
        cell?.mainView?.colorForFill = UIColor.whiteColor()
        cell?.mainView.setNeedsDisplay()
        
    }
}
