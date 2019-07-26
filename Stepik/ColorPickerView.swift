//
//  ColorPickerView.swift
//  Stepik
//
//  Created by iosd3:v on 7/13/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit

class ColorPickView: UIView {
    let hsbColorPicker = HSBColorPicker()
    let currentColorIndicator = CurrentColorIndicator()
    let doneButton = UIButton(type: .system)
    let brightnessLabel = UILabel()
    let brightnessSlider = UISlider()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentPoint = CGPoint() {
        didSet {
            hsbColorPicker.currentPoint = currentPoint
        }
    }
    
    var currentColor = UIColor() {
        didSet {
            currentColorIndicator.currentColor = currentColor
            var hue: CGFloat = 0.0
            var saturation: CGFloat = 0.0
            var brightness: CGFloat = 0.0
            currentColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
            hsbColorPicker.brightness = Float(brightness)
            brightnessSlider.value = Float(brightness)
        }
    }
    
    func setupView(){
        self.backgroundColor = .white
        
        hsbColorPicker.layer.borderColor = UIColor.black.cgColor
        hsbColorPicker.layer.borderWidth = 1
        
        
        brightnessSlider.minimumValue = 0.0
        brightnessSlider.maximumValue = 1.0
        brightnessSlider.value = 0.8
        
        brightnessSlider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)
        
        brightnessLabel.text = "Brightness"
        brightnessLabel.textColor = .black
        brightnessLabel.textAlignment = .left
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }
    
    func setupLayout(){
        hsbColorPicker.translatesAutoresizingMaskIntoConstraints = false
        currentColorIndicator.translatesAutoresizingMaskIntoConstraints = false
        brightnessLabel.translatesAutoresizingMaskIntoConstraints = false
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(hsbColorPicker)
        self.addSubview(currentColorIndicator)
        self.addSubview(brightnessLabel)
        self.addSubview(brightnessSlider)
        self.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            currentColorIndicator.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            currentColorIndicator.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 8),
            currentColorIndicator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            currentColorIndicator.heightAnchor.constraint(equalTo: currentColorIndicator.widthAnchor),
            brightnessLabel.topAnchor.constraint(equalTo: currentColorIndicator.topAnchor),
            brightnessLabel.leftAnchor.constraint(equalTo: currentColorIndicator.rightAnchor, constant: 16),
            brightnessLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            brightnessSlider.topAnchor.constraint(equalTo: brightnessLabel.bottomAnchor, constant: 8),
            brightnessSlider.leftAnchor.constraint(equalTo: brightnessLabel.leftAnchor),
            brightnessSlider.rightAnchor.constraint(equalTo: brightnessLabel.rightAnchor),
            brightnessSlider.bottomAnchor.constraint(equalTo: currentColorIndicator.bottomAnchor),
            hsbColorPicker.topAnchor.constraint(equalTo: currentColorIndicator.bottomAnchor, constant: 16),
            hsbColorPicker.leftAnchor.constraint(equalTo: currentColorIndicator.leftAnchor),
            hsbColorPicker.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -8),
            doneButton.topAnchor.constraint(equalTo: hsbColorPicker.bottomAnchor, constant: 16),
            doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
    }
    
    @objc func doneButtonPressed(){
        self.removeFromSuperview()
    }
    @objc func sliderValueDidChange(sender: UISlider){
        self.hsbColorPicker.brightness = sender.value
    }
}
