//
//  HSBColorPicker.swift
//  Stepik
//
//  Created by iosdev on 7/13/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit

internal protocol ColorPickerDelegate : NSObjectProtocol {
    func colorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State)
    func currentColorDidSet(color: UIColor)
}

class HSBColorPicker: UIView {

    weak internal var delegate: ColorPickerDelegate?
    
    var currentPoint: CGPoint? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var brightness: Float = 0.8 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func setUp() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0.0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: 4) {
            let saturation = CGFloat(rect.height - y) / rect.height
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: 4) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: CGFloat(brightness), alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x: x, y: y, width: 4,height: 4))
            }
        }
        if currentPoint == nil {
            currentPoint = .init(x: self.bounds.midX, y: self.bounds.midY)
        }
        
        guard let currentPoint = currentPoint else { return }
        
        let path = UIBezierPath(arcCenter: currentPoint, radius: 10, startAngle: 0, endAngle: .pi*2, clockwise: true)
        let color = getColorAtPoint(point: currentPoint)
        self.delegate?.currentColorDidSet(color: color)
        color.setFill()
        path.fill()
        
        path.move(to: .init(x: currentPoint.x - 10, y: currentPoint.y))
        path.addLine(to: .init(x: currentPoint.x - 15, y: currentPoint.y))
        path.move(to: .init(x: currentPoint.x, y: currentPoint.y - 10))
        path.addLine(to: .init(x: currentPoint.x, y: currentPoint.y - 15))
        path.move(to: .init(x: currentPoint.x + 10, y: currentPoint.y))
        path.addLine(to: .init(x: currentPoint.x + 15, y: currentPoint.y))
        path.move(to: .init(x: currentPoint.x, y: currentPoint.y + 10))
        path.addLine(to: .init(x: currentPoint.x, y: currentPoint.y + 15))
        UIColor.black.setStroke()
        path.stroke()
    }
    
    func getColorAtPoint(point:CGPoint) -> UIColor {
        var normalizedX: CGFloat {
            switch point.x {
            case ..<0:
                return 0
            case 0..<self.bounds.width:
                return point.x
            case self.bounds.width...:
                return self.bounds.width
            default:
                fatalError()
            }
        }
        
        var normalizedY: CGFloat {
            switch point.y {
            case ..<0:
                return 0
            case 0..<self.bounds.height:
                return point.y
            case self.bounds.height...:
                return self.bounds.height
            default:
                fatalError()
            }
        }
        let saturation = CGFloat(self.bounds.height - normalizedY) / self.bounds.height
        let brightness = CGFloat(self.brightness)
        let hue = normalizedX / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        self.currentPoint = point
        let color = getColorAtPoint(point: point)
        self.delegate?.colorPickerTouched(sender: self, color: color, point: point, state: gestureRecognizer.state)
    }

}
