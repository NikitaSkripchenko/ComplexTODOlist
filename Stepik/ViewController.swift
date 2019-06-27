//
//  ViewController.swift
//  Stepik
//
//  Created by iosdev on 6/26/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit
import CocoaLumberjack

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
        
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        DDLogVerbose("Verbose")
        DDLogDebug("Debug")
        DDLogInfo("Info")
        DDLogWarn("Warn")
        DDLogError("Error")
    }

    #if DEBUG
    static let apiUrl = "alpha.api.someapi.com"
    #elseif STAGE
    static let apiUrl = "stage.api.someapi.com"
    #else
    static let apiUrl = "prod.api.someapi.com"
    #endif
    
   


}
enum MyError: Error {
    case runtimeError(String)
}

extension Double {
    
    func reverseSinus() throws -> Double {
        if (abs(self) < Double.ulpOfOne) {
            throw MyError.runtimeError("sorry")
        }
        
        return sin(1 / self)
    }
    
}
