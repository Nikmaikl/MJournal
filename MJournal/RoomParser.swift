//
//  RoomParser.swift
//  MJournal
//
//  Created by Michael on 06.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import Foundation

class RoomParser {
    static var rooms = RoomParser.getRooms()
    
    fileprivate class func getRooms() -> NSMutableDictionary {
        let file = NSMutableDictionary(contentsOfFile: Bundle.main.path(forResource: "Rooms", ofType: "plist")!)!
        return file
    }
}
