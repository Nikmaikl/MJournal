//
//  SettingsTableViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 23.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit
import StoreKit
import CoreData

protocol SwitchedColorDelegate: class {
    func switchedColor()
}

class SettingsTableViewController: UITableViewController, SwitchedColorDelegate {
    
    var shouldShowMyProfile = false

    var mainSettings = ["Мое время занятий"]//["Мой профиль", "Мое время занятий"]
    var adSettings = ["Убрать рекламу за 69,00 ₽", "Восстановить покупки"]
    
    @IBOutlet weak var adButton: UIButton!
    @IBOutlet weak var restoreAdButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var resetAllDataButton: UIButton!
    
    var products = [SKProduct]()
    
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(shouldGoBack))
        
        reload()
        
        adButton.titleLabel?.font = UIFont.appSemiBoldFont(15)
        moreInfoButton.titleLabel?.font = UIFont.appSemiBoldFont(15)
        resetAllDataButton.titleLabel?.font = UIFont.appSemiBoldFont(15)
        restoreAdButton.titleLabel?.font = UIFont.appSemiBoldFont(13)
        
        clearsSelectionOnViewWillAppear = true
        
        resetColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (AppProducts.store.isProductPurchased(AppProducts.fullAccess)) {
            tableView.tableHeaderView?.isHidden = true
            tableView.tableHeaderView = nil
        } else {
            tableView.tableHeaderView?.isHidden = false
        }
        
    }

    @IBAction func resetAllData(_ sender: Any) {
        
    }
    
    internal func switchedColor() {
        resetColors()
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    func resetColors() {
        self.tableView.backgroundColor = UIColor.darkBackground()
        self.tableView.footerView(forSection: 0)?.contentView.backgroundColor = UIColor.darkBackground()
        if UserDefaults.standard.bool(forKey: "white_theme") {
            navigationController?.navigationBar.barStyle = .default
        } else {
            navigationController?.navigationBar.barStyle = .black
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.darkBackground()
        self.navigationController?.navigationBar.tintColor = UIColor.navigationBarTintColor()
        self.headerView.backgroundColor = UIColor.darkBackground()
        self.moreInfoButton.setTitleColor(UIColor.navigationBarTintColor(), for: UIControlState.normal)
        self.restoreAdButton.setTitleColor(UIColor.navigationBarTintColor(), for: UIControlState.normal)
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if AppProducts.store.isProductPurchased(AppProducts.fullAccess) {
            return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return mainSettings.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    @IBAction func buyFullAccess(_ sender: Any) {
        AppProducts.store.buyProduct(products[0])
    }
    
    func reload() {
        products = []
        
        AppProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
            }
        }
    }
    
    @IBAction func getMoreInfo(_ sender: Any) {
        
    }
    
    @IBAction func restoreProducts(_ sender: Any) {
        AppProducts.store.restorePurchases()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as? SwitchTableViewCell
            cell?.delegate = self
            return cell!
        }
        
        let mainSettingsCell = tableView.dequeueReusableCell(withIdentifier: "MainSettings", for: indexPath) as? SettingsTableViewCell
        
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.darkBackgroundSelectionCell()
            mainSettingsCell!.selectedBackgroundView = backgroundView
            
            mainSettingsCell?.nameLabel.text = mainSettings[(indexPath as NSIndexPath).row]
            var iconImage: UIImage!
            
            switch (indexPath as NSIndexPath).row {
            case 0:
                iconImage = UIImage(named: "Clock_icon")!
            case 1:
                iconImage = UIImage(named: "Clock_icon")!
            case 2:
                iconImage = UIImage(named: "School_icon")!
            default:
                return mainSettingsCell!
            }
            
            mainSettingsCell?.iconImageView.image =  iconImage
        
        return mainSettingsCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if indexPath.row == 0 {
         //   performSegue(withIdentifier: "GoToProfileSettings", sender: self)
        //} else if indexPath.row == 1 {
            performSegue(withIdentifier: "GoToSheduleSettings", sender: self)
        //}
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Общие"
        default:
            return nil
        }
    }
    
//    override func willMove(toParentViewController parent: UIViewController?) {
//        super.willMove(toParentViewController: parent)
//        if parent == nil {
//        
//        }
//        if parent == self.navigationController?.parent as? WeekCollectionViewController {
//            (parent as? WeekCollectionViewController)?.shouldChangeTheme = true
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.navigationController?.topViewController != self {
            if let weekVC = self.navigationController?.topViewController as? WeekCollectionViewController {
                weekVC.shouldChangeTheme = true
            }
        }
    }
}
