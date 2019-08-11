//
//  SaveNotesDBOperation.swift
//  Stepik
//
//  Created by Nikita Skrypchenko  on 8/11/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import Foundation

class SaveNotesDBOperation: BaseDBOperation {
    
    override func main() {
        print("save notes to DB")
        notebook.saveToFile()
        finish()
    }
}
