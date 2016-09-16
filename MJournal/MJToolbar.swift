//
//  MJToolbar.swift
//  MJournal
//
//  Created by Michael Nikolaev on 21.08.16.
//  Copyright © 2016 Ocode. All rights reserved.
//

import UIKit

class MJToolbar: UIToolbar {

    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 52
        return size
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
