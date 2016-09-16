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

private let reuseIdentifier = "CellDay"

class WeekCollectionViewController: UICollectionViewController {

    var dayNumber: Int = 0
    var colorForCell: UIColor = UIColor.black
    let currentDayIndex = IndexPath(row: Time.getDay(), section: 0)
    
    var currentLongPressingRow:IndexPath? = nil
    
    var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    let defaultCornerRadius: CGFloat = 10.0
    let defaultSpace: CGFloat = 16.0
    
    var lpgr: UILongPressGestureRecognizer!
    
    var days = Day.allDays()
    
    @IBOutlet var bannerView: BannerCollectionReusableView!
    
    var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkBackground()
        
        Time.daysForTheWeek()
        
        navigationController?.navigationBar.titleTextAttributes = ["NSFontAttributeName": UIFont.appBoldFont()]
        
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.darkBackground()
        navigationController?.navigationBar.isTranslucent = false
        
        if days.count == 0 {
            for d in WeekDays.days {
                let day = Day(name: d)
                days.append(day)
                CoreDataHelper.instance.save()
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
    
//    @available(iOS 9.0, *)
//    private func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
//        var notEvenLessons = [String]()
//        var evenLessons = [String]()
//        for lesson in Day.allDays()[Time.getDay()].allNotEvenLessons() {
//            notEvenLessons.append(lesson.name!)
//        }
//        for lesson in Day.allDays()[Time.getDay()].allEvenLessons() {
//            evenLessons.append(lesson.name!)
//        }
//        replyHandler(["notEvenLessons": notEvenLessons as AnyObject, "evenLessons": evenLessons as AnyObject])
//    }
//    
//    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    
    func setupGoogleAdToolbar() {
        banner = GADBannerView(frame: CGRect(x: collectionView!.frame.width/2-kGADAdSizeBanner.size.width/2 ,y: 0, width: kGADAdSizeBanner.size.width, height: 44))
        banner.adUnitID = "ca-app-pub-9919730864492896/4325157365"
        banner.rootViewController = self
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        navigationController?.toolbar.setBackgroundImage(UIImage(),
                                                         forToolbarPosition: UIBarPosition.any,
                                                         barMetrics: UIBarMetrics.default)
        navigationController?.toolbar.setShadowImage(UIImage(),
                                                     forToolbarPosition: UIBarPosition.any)
        
        self.navigationController?.toolbar.backgroundColor = UIColor.darkBackground()
        self.navigationController?.toolbar.addSubview(banner)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        banner.load(request)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "bannerView", for: indexPath)
        // configure footer view
        return view
    }
    
    func handleLongPress(_ lgr: UILongPressGestureRecognizer) {
        let p = lgr.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: p)
        
        if indexPath != nil && ((currentLongPressingRow as NSIndexPath?)?.row == (indexPath! as NSIndexPath).row || currentLongPressingRow == nil) {
            currentLongPressingRow = indexPath
            let cell = collectionView!.cellForItem(at: indexPath!)
            UIView.animate(withDuration: 0.2, animations: {
                if lgr.state == .ended {
                    cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                } else {
                    cell!.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }
                }, completion: { b->Void in
                    if lgr.state == .ended {
                        self.currentLongPressingRow = nil
                    }
            })
        } else if (currentLongPressingRow != nil && ((currentLongPressingRow as NSIndexPath?)?.row != (indexPath as NSIndexPath?)?.row ||
        indexPath == nil)) {
            let cell = collectionView!.cellForItem(at: currentLongPressingRow!)
            UIView.animate(withDuration: 0.2, animations: {
                cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.currentLongPressingRow = nil
                })

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.alpha = 1.0
        self.navigationController?.navigationBar.tintColor = UIColor.white//UIColor(red: 105/255, green: 141/255, blue: 169/225, alpha: 1.0)//UIColor(red: 69/255, green: 121/255, blue: 188/255, alpha: 1.0)
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func highlightCurrentDay() {
        let currentCell = collectionView?.cellForItem(at: currentDayIndex) as? DayCell
        
        currentCell?.mainView.colorForFill = UIColor.getColorForCell(withRow: (currentDayIndex as NSIndexPath).row, alpha: 0.2)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController {
            if let moreInfo = navVC.childViewControllers[0] as? DaySheduleContainerViewController {
                moreInfo.dayNumber = self.dayNumber
                moreInfo.weekDayNumber = Time.daysForTheWeek()[dayNumber]["day"] as! Int
                moreInfo.currentDay = days[dayNumber]
                moreInfo.colorForBar = self.colorForCell
                if dayNumber == (currentDayIndex as NSIndexPath).row {
                    moreInfo.title = NSLocalizedString("Today", comment: "Today")
                } else {
                    moreInfo.title = NSLocalizedString(WeekDays.days[dayNumber], comment: "Day")
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeekDays.days.count
    }
    
    var dayForCell: Int!

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DayCell
        
        if (currentDayIndex as NSIndexPath).row == (indexPath as NSIndexPath).row {
            cell?.todayDay = true
        }
        
        
        if Time.getDay() > indexPath.row {
            dayForCell = (Time.getActualDay()-(abs(Time.getDay()-indexPath.row)))
        } else {
            dayForCell = (Time.getActualDay()+(abs(Time.getDay()-indexPath.row)))
        }
        
        cell?.dayNumber = Time.daysForTheWeek()[indexPath.row]["day"] as! Int
        cell?.dayId = (indexPath as NSIndexPath).row
        cell?.day = WeekDays.days[(indexPath as NSIndexPath).row]
        cell?.mainView.colorForBezel = UIColor.getColorForCell(withRow: (indexPath as NSIndexPath).row, alpha: 1)
        
        
        return cell!
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let _ = collectionView.cellForItem(at: indexPath) as? DayCell
        dayNumber = (indexPath as NSIndexPath).row
        colorForCell = UIColor.getColorForCell(withRow: (indexPath as NSIndexPath).row, alpha: 1)
        
        let cell = collectionView.cellForItem(at: indexPath)
        if let dayCell = cell as? DayCell {
            UIView.animate(withDuration: 0.2, animations: {
                dayCell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }, completion: { b->Void in
                    UIView.animate(withDuration: 0.05, animations: {
                        dayCell.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.performSegue(withIdentifier: "MoreInfo", sender: self)
                        }, completion: { b->Void in
                    })
            })
        }
        

    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? DayCell
        
        cell?.mainView?.colorForFill = UIColor.white
        cell?.mainView.setNeedsDisplay()
        
    }
}
