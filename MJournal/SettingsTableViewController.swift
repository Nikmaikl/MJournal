//
//  SettingsTableViewController.swift
//  MJournal
//
//  Created by Michael Nikolaev on 23.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var mainSettings = ["Время занятий", "Предметы", "Преподаватели", "Корпуса", "Типы занятий"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mainSettings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainSettings", forIndexPath: indexPath) as? SettingsTableViewCell
        
        cell?.nameLabel.text = mainSettings[indexPath.row]
        var iconImage: UIImage!
        
        switch indexPath.row {
        case 0:
            iconImage = UIImage(named: "Clock_icon")!
        case 1:
            iconImage = UIImage(named: "Books_icon")!
        case 2:
            iconImage = UIImage(named: "Professor_icon")!
        case 3:
            iconImage = UIImage(named: "School_icon")!
        case 4:
            iconImage = UIImage(named: "TypeOfLesson_icon")!
            
        default:
            return cell!
        }
        
        cell?.iconImageView.image =  iconImage

        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Общие"
        default:
            return nil
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
