//
//  ColorPlateView.swift
//  Stepik
//
//  Created by iosdev on 7/13/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import Foundation
import UIKit

class ColorPickerPlateView: UIView {

    var isSelected: Bool = false{
        didSet{
            if isSelected != oldValue{
                setNeedsDisplay()
            }
        }
    }
    
    var selectedColor: UIColor? = nil{
        didSet{
            if selectedColor != oldValue{
                setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        UIColor.black.setStroke()
        
        if let selectedColor = selectedColor{
            selectedColor.setFill()
            path.fill()
        }else{
            let context = UIGraphicsGetCurrentContext()
            for y: CGFloat in stride(from: 0.0, to: rect.height, by: 1){
                let saturation = CGFloat(rect.height - y) / rect.height
                for x: CGFloat in stride(from: 0.0, to: rect.width, by: 1){
                    let hue = x / rect.width
                    let color = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
                    context!.setFillColor(color.cgColor)
                    context!.fill(CGRect(x: x, y: y, width: 1, height: 1))
                }
            }
        }
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
