//
//  SettingsTableViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 23.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var mainSettings = ["Время занятий"]//, "Преподаватели", "Корпуса"]
    var adSettings = ["Убрать рекламу за 69,00 ₽", "Восстановить покупки"]
    
    @IBOutlet weak var adButton: UIButton!
    @IBOutlet weak var restoreAdButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adButton.titleLabel?.font = UIFont.appSemiBoldFont(15)
        restoreAdButton.titleLabel?.font = UIFont.appSemiBoldFont(13)
//        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        tableView.tableHeaderView?.isHidden = true
        clearsSelectionOnViewWillAppear = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return mainSettings.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                iconImage = UIImage(named: "Professor_icon")!
            case 2:
                iconImage = UIImage(named: "School_icon")!
            default:
                return mainSettingsCell!
            }
            
            mainSettingsCell?.iconImageView.image =  iconImage
            
            return mainSettingsCell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Общие"
        default:
            return nil
        }
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)!
//        selectedCell.contentView.backgroundColor = UIColor.redColor()
//    }
//
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        let cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//        cellToDeSelect.contentView.backgroundColor = UIColor.clearColor()
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
