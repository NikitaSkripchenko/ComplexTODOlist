//
//  ViewController.swift
//  Stepik
//
//  Created by iosdev on 6/26/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let note = Note(title: "s", content: "sa", priority: .base, uid: "123", color: .red)
        let noteBook = FileNotebook()
        noteBook.add(note)
        noteBook.saveToFile()
        // Do any additional setup after loading the view.
    }
    
    
   


}

