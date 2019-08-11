//
//  SaveNoteDBOperation.swift
//  Notes
//
//  Created by Nikita Skrypchenko on 30/07/2019.
//  Copyright © 2019 Nikita Skrypchenko. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum SaveNoteDBResult {
    case success
    case failure(NetworkError)
}

class SaveNoteDBOperation: BaseDBOperation {
    var result: SaveNoteDBResult?
    private let note: Note
    var notes: [Note] = []
    
    init(note: Note,
         notebook: FileNotebook) {
        self.note = note
        self.notes = notebook.notes
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.add(note)
        notebook.saveToFile()
        result = .success
        self.notes = notebook.notes
        DDLogDebug("Save notes to db completed")
        
        finish()
    }
}
