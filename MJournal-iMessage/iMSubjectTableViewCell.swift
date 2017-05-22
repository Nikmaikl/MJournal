//
//  iMSubjectTableViewCell.swift
//  MJournal
//
//  Created by Michael Nikolaev on 17.09.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class iMSubjectTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectTitle: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    var dayNumber: Int!
    
    var lesson: Lesson? {
        didSet {
            subjectTitle.text = lesson?.name
            startTimeLabel.text = lesson?.startTime
            endTimeLabel.text = lesson?.endTime
            self.backgroundColor = UIColor.getColorForCell(withRow: dayNumber, alpha: 1.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
