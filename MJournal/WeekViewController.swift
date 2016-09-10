//
//  WeekCollectionViewController.swift
//  MJournal
//
//  Created by Michael on 04.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import WatchConnectivity

private let reuseIdentifier = "CellDay"

class WeekCollectionViewController: UICollectionViewController, WCSessionDelegate {

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
    
    var days = Day.allDays()
    
    @IBOutlet var bannerView: BannerCollectionReusableView!
    
    var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = ["NSFontAttributeName": UIFont.appBoldFont()]
        
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            forBarPosition: .Any,
            barMetrics: .Default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.darkBackground()
        navigationController?.navigationBar.translucent = false
        
        if days.count == 0 {
            for d in WeekDays.days {
                let day = Day(name: d)
                days.append(day)
                CoreDataHelper.instance.save()
            }
        }
        
        if #available(iOS 9.0, *) {
            if WCSession.isSupported() {
                let session = WCSession.defaultSession()
                session.delegate = self
                session.activateSession()
            }
        }
        
        let numberOfItemsPerSmallerSide: CGFloat = 2
        let width = (min(screenSize.height, screenSize.width) - defaultSpace * 3) / numberOfItemsPerSmallerSide
        
        let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: width, height: width)
        layout?.minimumLineSpacing = defaultSpace
        layout?.minimumInteritemSpacing = defaultSpace
        
        collectionView!.contentInset = UIEdgeInsets(top: defaultSpace, left: defaultSpace, bottom: defaultSpace, right: defaultSpace)
        
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.1
//        self.collectionView!.addGestureRecognizer(lpgr)

        setupGoogleAdToolbar()
    }
    
    @available(iOS 9.0, *)
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        var notEvenLessons = [String]()
        var evenLessons = [String]()
        for lesson in Day.allDays()[Time.getDay()].allNotEvenLessons() {
            notEvenLessons.append(lesson.name!)
        }
        for lesson in Day.allDays()[Time.getDay()].allEvenLessons() {
            evenLessons.append(lesson.name!)
        }
        replyHandler(["notEvenLessons": notEvenLessons, "evenLessons": evenLessons])
    }
    
    func setupGoogleAdToolbar() {
        banner = GADBannerView(frame: CGRectMake(collectionView!.frame.width/2-kGADAdSizeBanner.size.width/2 ,0, kGADAdSizeBanner.size.width, 44))
        banner.adUnitID = "ca-app-pub-9919730864492896/4325157365"
        banner.rootViewController = self
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        navigationController?.toolbar.setBackgroundImage(UIImage(),
                                                         forToolbarPosition: UIBarPosition.Any,
                                                         barMetrics: UIBarMetrics.Default)
        navigationController?.toolbar.setShadowImage(UIImage(),
                                                     forToolbarPosition: UIBarPosition.Any)
        
        self.navigationController?.toolbar.backgroundColor = UIColor.darkBackground()
        self.navigationController?.toolbar.addSubview(banner)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        banner.loadRequest(request)
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "bannerView", forIndexPath: indexPath)
        // configure footer view
        return view
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
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()//UIColor(red: 105/255, green: 141/255, blue: 169/225, alpha: 1.0)//UIColor(red: 69/255, green: 121/255, blue: 188/255, alpha: 1.0)
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
            moreInfo.currentDay = days[dayNumber]
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
