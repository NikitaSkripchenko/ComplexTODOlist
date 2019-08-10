//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Nikita Skrypchenko on 30/07/2019.
//  Copyright © 2019 Nikita Skrypchenko. All rights reserved.
//

import Foundation
import CocoaLumberjack

class LoadNotesDBOperation: BaseDBOperation {
    
    var result: [Note]?
    
    override init(notebook: FileNotebook) {
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.loadFromFile()
        result = notebook.notes
        
        DDLogDebug("Load notes from db completed")
        
        finish()
    }
}
