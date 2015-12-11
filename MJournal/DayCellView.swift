//
//  DayCellView.swift
//  MJournal
//
//  Created by Michael on 04.12.15.
//  Copyright © 2015 Ocode. All rights reserved.
//

import UIKit

class DayCellView: UIView {
    
    var colorForBezel: UIColor! = UIColor.whiteColor()
    var colorForFill: UIColor! = UIColor.whiteColor()
    
    override func drawRect(rect: CGRect) {
        let lineWidth = rect.width/84.0
        let cornerRadius = rect.width/16.0
        let tileRect = rect.insetBy(dx: lineWidth/1.0, dy: lineWidth/1.0)
        
        let path = UIBezierPath(roundedRect: tileRect, cornerRadius: CGFloat(cornerRadius))
        colorForFill.setFill()
        colorForBezel.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
        path.fill()
    }
    
    func fillWithColor(color: UIColor) {
        color.setFill()
    }
}