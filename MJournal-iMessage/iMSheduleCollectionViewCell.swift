//
//  iMSheduleCollectionViewCell.swift
//  MJournal
//
//  Created by Michael Nikolaev on 17.09.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class iMSheduleCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sheduleTableView: UITableView!
    
    let days = ["Пнд", "Вт", "Ср", "Чт", "Пт", "Сб"]
    
    var dayNumber: Int! {
        didSet {
            sheduleTableView.delegate = self
            sheduleTableView.dataSource = self
            self.backgroundColor = UIColor.getColorForCell(withRow: dayNumber, alpha: 1.0)
            self.sheduleTableView.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Day.allDays()[dayNumber].allNotEvenLessons().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as? iMSubjectTableViewCell

        cell?.dayNumber = dayNumber
        
        if Time.isEvenWeek() && indexPath.row < Day.allDays()[dayNumber].allEvenLessons().count  {
            cell?.lesson = Day.allDays()[dayNumber].allEvenLessons()[indexPath.row]
        } else {
            cell?.lesson = Day.allDays()[dayNumber].allNotEvenLessons()[indexPath.row]
        }
        
        return cell!
    }
}
