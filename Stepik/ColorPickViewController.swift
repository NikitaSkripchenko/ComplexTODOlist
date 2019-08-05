//
//  ColorPickViewController.swift
//  Stepik
//
//  Created by Nikita Skrypchenko  on 7/26/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit

class ColorPickViewController: UIViewController, ColorPickerDelegate {
    
    var currentPoint: CGPoint? = nil
    var color: UIColor? = nil
    weak var colorPickerPlateView: ColorPickerPlateView!
    var currentColor: UIColor? {
        didSet {
            guard currentColor != nil, currentColor != oldValue else { return }
            colorPickView.currentColor = currentColor!
            self.color = currentColor!
        }
    }
    
    func colorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        self.currentColor = color
        self.currentPoint = point
    }
    
    func currentColorDidSet(color: UIColor) {
        self.currentColor = color
    }
    
    var selectedColor:UIColor? = nil
    @IBOutlet weak var colorPickView: ColorPickView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        if let color = selectedColor{
            colorPickView.currentColor = color
        }
        colorPickView.currentColor = .white
        colorPickView.hsbColorPicker.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let noteEditViewController = segue.destination as? ViewController, segue.identifier == "UnwindToEditNote"{
            noteEditViewController.color = colorPickView.currentColor
            noteEditViewController.colorPickerView.selectedColor = colorPickView.currentColor
        }
    }
    
    @objc func cancel(){
    navigationController?.popViewController(animated: true)
    }
    
    @objc func done(){
        performSegue(withIdentifier: "UnwindToEditNote", sender: self)
    }
}
