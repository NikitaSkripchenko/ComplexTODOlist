//
//  SaveNoteDBOperation.swift
//  Notes
//
//  Created by Nikita Skrypchenko on 30/07/2019.
//  Copyright © 2019 Nikita Skrypchenko. All rights reserved.
//

import Foundation
import CocoaLumberjack

class SaveNoteDBOperation: BaseDBOperation {
    
    private let note: Note
    
    init(note: Note,
         notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.add(note)
        notebook.saveToFile()
        
        DDLogDebug("Save notes to db completed")
        
        finish()
    }
}
