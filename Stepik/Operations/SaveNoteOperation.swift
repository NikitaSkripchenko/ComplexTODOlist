//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Nikita Skrypchenko on 30/07/2019.
//  Copyright © 2019 Nikita Skrypchenko. All rights reserved.
//

import Foundation

class SaveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        self.dbQueue = dbQueue
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)
        saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
        saveToBackend.addDependency(saveToDb)
        
        super.init()
        
        saveToDb.completionBlock = {
            if self.saveToDb.isFinished{
                switch self.saveToDb.result {
                case .success?:
                    self.result = true
                    print("saveToDb )", self.saveToDb.notes)
                    self.saveToBackend.notes = self.saveToDb.notes
                //                self.finish()
                case .failure?:
                    print("saveToDb failure)")
                    self.result = false
                    self.finish()
                case .none:
                    print("saveToDb none")
                    self.finish()
                }
            }
        }
        saveToBackend.completionBlock = {
            switch self.saveToBackend.result! {
            case .success:
                print("SaveNoteOperation saveToBackend \(self.saveToBackend.notes.count)", notebook.notes.count)
                self.result = true
                
            case .failure:
                print("saveToBackend failure)")
                self.result = false
            }
            self.finish()
            
        }
        self.dbQueue.maxConcurrentOperationCount = 1
        self.dbQueue.addOperations([saveToDb,saveToBackend], waitUntilFinished: true)
        
    }
    
    override func main() {

    }
}
