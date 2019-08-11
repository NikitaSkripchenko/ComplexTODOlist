//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Nikita Skrypchenko on 30/07/2019.
//  Copyright © 2019 Nikita Skrypchenko. All rights reserved.
//
import Foundation

class LoadNotesOperation: AsyncOperation {
    private(set) var notes: [Note] = [Note]()
    private let notebook: FileNotebook
    private let loadFromDb: LoadNotesDBOperation
    private var loadFromBackend: LoadNotesBackendOperation
    private let saveDB: SaveNotesDBOperation
    private(set) var result: Bool? = false
    private let dbQueue: OperationQueue
    
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        print("init LoadNoteOperation")
        self.notebook = notebook
        self.dbQueue = dbQueue
        loadFromBackend = LoadNotesBackendOperation()
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        saveDB = SaveNotesDBOperation(notebook: notebook)
        super.init()
        
        loadFromBackend.completionBlock = {
            let networkResult = self.loadFromBackend.result
            print("load network result: \(String(describing: networkResult))")
            switch self.loadFromBackend.result {
            case .success(let backendNotes)?:
                print("loadFromBackend is: ", backendNotes.count)
                self.notes = backendNotes
                self.result = true
                self.dbQueue.addOperation(self.saveDB)
            case .failure?:
                self.result = false
            case .none:
                print("loadFromBackend none")
            }
            print("loadFromBackend must have loadFromDb")
            self.dbQueue.addOperation(self.loadFromDb)
        }
        
        loadFromDb.completionBlock = {
            print("Loadede from DB. notes count: \(self.notes.count )")
            self.notebook.replaceAll(notes: self.notes)
            print("Loadede from DB. notes count2: \(self.notes.count )")
            self.finish()
        }
        
        loadFromDb.addDependency(loadFromBackend)
        saveDB.addDependency(loadFromBackend)
        
        self.dbQueue.addOperation(loadFromBackend)
    }
    
    override func main() {
        print("main")
       
    }
}

