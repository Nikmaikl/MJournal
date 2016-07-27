//
//  SubjectTableViewCell.swift
//  MJournal
//
//  Created by Michael Nikolaev on 26.07.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeOfLessonLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var professorNameLabel: UILabel!
    
    var colorForToday: UIColor! {
        didSet {
            headerView.backgroundColor = colorForToday
        }
    }
    
    var lesson: Lesson! {
        didSet {
            lessonNameLabel.text = lesson.name
            timeLabel.text = lesson.time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class Lesson {
    var name: String!
    var time: String!
    var type, place: String?
    var professor: String?
    
    init(name: String, time: String, type: String?, place: String?, professor: String?) {
        self.name = name
        self.time = time
        self.type = type
        self.place = place
        self.professor = professor
    }
}