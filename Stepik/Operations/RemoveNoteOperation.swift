//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Nikita Skrypchenko on 31/07/2019.
//  Copyright © 2019 Nikita Skrypchenko. All rights reserved.
//

import Foundation
import CocoaLumberjack

class RemoveNoteOperation: AsyncOperation {
    
    private let note: Note
    private var saveToBackend: SaveNotesBackendOperation
    private let removeFromDb: RemoveNoteDBOperation
    private(set) var result: Bool? = false

    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        self.note = note
        
        removeFromDb = RemoveNoteDBOperation(note: note, notebook: notebook)
        saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
        
        super.init()
        
        removeFromDb.completionBlock = {
            self.saveToBackend.notes = self.removeFromDb.notes
        }
        saveToBackend.addDependency(removeFromDb)
        dbQueue.addOperations([removeFromDb, saveToBackend], waitUntilFinished: true)
    }
    
    override func main() {
        switch saveToBackend.result! {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
