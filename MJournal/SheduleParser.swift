//
//  SheduleParser.swift
//  MJournal
//
//  Created by Michael on 05.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import Foundation

class SheduleParser {
    static var shedule = SheduleParser.loadShedule()
    
    private class func loadShedule() -> [NSArray] {
        var result = [NSArray]()
        let arr = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Shedule", ofType: "plist")!)
        
        for a in arr as! [NSArray] {
            result.append(a)
        }
        
        return result
    }
}