//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Nikita Skrypchenko on 30/07/2019.
//  Copyright © 2019 Nikita Skrypchenko. All rights reserved.
//

import Foundation
import CocoaLumberjack

class RemoveNoteDBOperation: BaseDBOperation {
    
    private let note: Note
    var notes: [Note]
    
    init(note: Note, notebook: FileNotebook) {
        print("RemoveNoteDBOperation", note.uid)
        self.note = note
        self.notes = notebook.notes
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: note.uid)
        notebook.saveToFile()
        print("RemoveNoteDBOperation", notebook.notes.count)
        
        self.notes = notebook.notes
        finish()
    }
}
