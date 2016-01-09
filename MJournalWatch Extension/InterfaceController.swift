//
//  InterfaceController.swift
//  MJournalWatch Extension
//
//  Created by Michael on 07.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        table.setNumberOfRows(WeekDays.days.count, withRowType: "DayType")
        for (i, day) in WeekDays.days.enumerate() {
            let controller = table.rowControllerAtIndex(i) as? DayRowController
            controller?.image.setImage(UIImage(named: day))
            controller?.name.setText(day)
        }
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        
        pushControllerWithName("More_Info", context: rowIndex)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}

class DayRowController: NSObject {
    @IBOutlet var image: WKInterfaceImage!
    @IBOutlet var name: WKInterfaceLabel!
}
