//
//  ViewController.swift
//  Stepik
//
//  Created by iosdev on 6/26/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        backgroundView.backgroundColor = .green
        #elseif STAGE
        backgroundView.backgroundColor = .green
        #else
        backgroundView.backgroundColor = .red
        #endif
        // Do any additional setup after loading the view.
    }

    #if DEBUG
    static let apiUrl = "alpha.api.someapi.com"
    #elseif STAGE
    static let apiUrl = "stage.api.someapi.com"
    #else
    static let apiUrl = "prod.api.someapi.com"
    #endif
    
   


}

