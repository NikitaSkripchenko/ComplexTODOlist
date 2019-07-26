//
//  ViewController.swift
//  Stepik
//
//  Created by iosdev on 6/26/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ViewController: UIViewController, ColorPickerDelegate {
    var fileNotebook: FileNotebook? = nil
    var note: Note? = nil
    
    func colorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        self.currentColor = color
        self.currentPoint = point
    }
    
    func currentColorDidSet(color: UIColor) {
        self.currentColor = color
    }
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var gistLabel: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBOutlet var datePickerConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var whiteView: ColorPlateView!
    @IBOutlet weak var redView: ColorPlateView!
    @IBOutlet weak var greenView: ColorPlateView!
    @IBOutlet weak var colorPickerView: ColorPickerPlateView!
    
    var currentPoint: CGPoint? = nil
    var colorChooser: ColorPickView?
    var currentColor: UIColor? {
        didSet {
            guard currentColor != nil, currentColor != oldValue else { return }
            colorChooser?.currentColor = currentColor!
            colorPickerView.selectedColor = currentColor!
        }
    }
    
    @IBAction func dateSwitcherValueChanged(_ sender: UISwitch) {
        self.datePicker.isHidden = !sender.isOn
        datePickerConstraint.isActive = !sender.isOn
    }
    
    @IBAction func whiteColorTapped(_ sender: Any) {
        redView.isSelected = false
        greenView.isSelected = false
        whiteView.isSelected = true
        colorPickerView.isSelected = false
    }
    
    @IBAction func redColorTapped(_ sender: Any) {
        redView.isSelected = true
        greenView.isSelected = false
        whiteView.isSelected = false
        colorPickerView.isSelected = false
    }
    
    @IBAction func greenColorTapped(_ sender: Any) {
        redView.isSelected = false
        greenView.isSelected = true
        whiteView.isSelected = false
        colorPickerView.isSelected = false
    }
    
    @IBAction func longTapHandler(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let colorPickerView = ColorPickView(frame: view.bounds)
            colorPickerView.translatesAutoresizingMaskIntoConstraints = true
            colorPickerView.autoresizingMask = .init(arrayLiteral: .flexibleHeight, .flexibleWidth)
            colorPickerView.currentColor = .white
            self.colorChooser = colorPickerView
            colorChooser?.hsbColorPicker.delegate = self
            if let currentPoint = currentPoint {
                colorPickerView.currentPoint = currentPoint
            }
            if currentColor != nil {
                colorPickerView.currentColor = currentColor!
            }
            view.addSubview(colorPickerView)
        }
        redView.isSelected = false
        greenView.isSelected = false
        whiteView.isSelected = false
        colorPickerView.isSelected = true
    }
    @IBAction func tapOnColorPicker(_ sender: Any) {
        redView.isSelected = false
        greenView.isSelected = false
        whiteView.isSelected = false
        colorPickerView.isSelected = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = note?.title
        self.gistLabel.text = note?.content
        
        redView.color = .red
        greenView.color = .green
        whiteView.color = .white
        
        if note?.color == redView.color {
            redView.isSelected = true
            greenView.isSelected = false
            whiteView.isSelected = false
            colorPickerView.isSelected = false
        } else if note?.color == greenView.color{
            redView.isSelected = false
            greenView.isSelected = true
            whiteView.isSelected = false
            colorPickerView.isSelected = false
        } else if note?.color == whiteView.color{
            redView.isSelected = false
            greenView.isSelected = false
            whiteView.isSelected = true
            colorPickerView.isSelected = false
        }else{
            currentColor = note?.color
            redView.isSelected = false
            greenView.isSelected = false
            whiteView.isSelected = false
            colorPickerView.isSelected = true
        }
       
        
        scrollView.keyboardDismissMode = .interactive
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHidden(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification) {
        if let kbRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let edgeInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: kbRect.height - view.safeAreaInsets.bottom, right: 0)
            scrollView.contentInset = edgeInsets
            scrollView.scrollIndicatorInsets = edgeInsets
        }
    }
}
