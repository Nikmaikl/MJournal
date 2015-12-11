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
    
    private class func getRooms() -> NSMutableDictionary {
        let file = NSMutableDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Rooms", ofType: "plist")!)!
        return file
    }
}