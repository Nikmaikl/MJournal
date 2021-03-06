//
//  String.swift
//  MJournal
//
//  Created by Michael Nikolaev on 09.09.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
