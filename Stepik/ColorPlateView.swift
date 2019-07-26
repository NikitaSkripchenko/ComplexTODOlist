//
//  ColorPlateView.swift
//  Stepik
//
//  Created by iosdev on 7/13/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit

class ColorPlateView: UIView {
    
    @IBInspectable var color: UIColor = .white
    
    var isSelected: Bool = false {
        didSet {
            if isSelected != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if color == .white {
            isSelected = true
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        UIColor.black.setStroke()
        color.setFill()
        path.fill()
        
        if isSelected {
            let checkMarkPath = UIBezierPath(ovalIn: CGRect(x: 6/10 * rect.maxX, y: 1/10 * rect.maxX, width: 3/10 * rect.width, height: 3/10 * rect.height))
            checkMarkPath.move(to: CGPoint(x: 67/100 * rect.maxX, y: 25/100 * rect.maxX))
            checkMarkPath.addLine(to: CGPoint(x: 74/100 * rect.maxX, y: 34/100 * rect.maxX))
            checkMarkPath.addLine(to: CGPoint(x: 81/100 * rect.maxX, y: 17/100 * rect.maxX))
            checkMarkPath.stroke()
        }
        
        path.stroke()
    }
}
