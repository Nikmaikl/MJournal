//
//  DayCellView.swift
//  MJournal
//
//  Created by Michael on 04.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit

class DayCellView: UIView {
    
    var colorForBezel: UIColor! = UIColor.white
    var colorForFill: UIColor! = UIColor.white {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let lineWidth = rect.width/44.0
        let cornerRadius = rect.width/16.0
        let tileRect = rect.insetBy(dx: lineWidth/1.0, dy: lineWidth/1.0)
        self.layer.cornerRadius = 20
        let path = UIBezierPath(roundedRect: tileRect, cornerRadius: CGFloat(cornerRadius))
        colorForFill.setFill()
        colorForBezel.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
    }
}
