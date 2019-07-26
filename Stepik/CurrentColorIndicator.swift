//
//  CurrentColorIndicator.swift
//  Stepik
//
//  Created by iosdev on 7/13/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit

class CurrentColorIndicator: UIView {

    var currentColor = UIColor() {
        didSet {
            currentColorView.backgroundColor = currentColor
            currentColorLabel.text = "#" + currentColor.toHex()
        }
    }
    let currentColorView = UIView()
    let currentColorLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        
        currentColorLabel.font = .systemFont(ofSize: 12)
        currentColorLabel.textColor = .white
        currentColorLabel.textAlignment = .center
        
        currentColorView.translatesAutoresizingMaskIntoConstraints = false
        currentColorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(currentColorView)
        self.addSubview(currentColorLabel)
        
        NSLayoutConstraint.activate([
            currentColorView.topAnchor.constraint(equalTo: self.topAnchor),
            currentColorView.leftAnchor.constraint(equalTo: self.leftAnchor),
            currentColorView.rightAnchor.constraint(equalTo: self.rightAnchor),
            currentColorLabel.topAnchor.constraint(equalTo: currentColorView.bottomAnchor, constant: 4),
            currentColorLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
            currentColorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            currentColorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            currentColorLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.18)
            ])
    }

}
extension UIColor {
    
    func toHex() -> String {
        guard let components = cgColor.components, components.count >= 3 else { return "FFFFFF" }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let result = String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        print(result)
        return result
    }
}

