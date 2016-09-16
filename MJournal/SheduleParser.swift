//
//  SheduleParser.swift
//  MJournal
//
//  Created by Michael on 05.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import Foundation

class SheduleParser {
    
    static var shedule = SheduleParser.getShedule()
    
    fileprivate class func getShedule() -> [NSMutableArray] {
        var result = [NSMutableArray]()
        let arr = NSMutableArray(contentsOfFile: Bundle.main.path(forResource: "Shedule", ofType: "plist")!)
        
        for a in arr! {
            result.append(a as! NSMutableArray)
        }
        
        return result
    }
}
