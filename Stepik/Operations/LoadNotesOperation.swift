//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Nikita Skrypchenko on 30/07/2019.
//  Copyright © 2019 Nikita Skrypchenko. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    
    private var loadFromBackend: LoadNotesBackendOperation
    private var loadFromDb: LoadNotesDBOperation
    
    private(set) var result: [Note]? = []
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        loadFromBackend = LoadNotesBackendOperation()
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        
        super.init()
        
        loadFromBackend.completionBlock = {
            switch self.loadFromBackend.result! {
            case .success(let notes):
                notebook.replaceAll(notes: notes)
                
                self.result = notes
            case .failure:
                backendQueue.addOperation(self.loadFromDb)
            }
        }
        
        addDependency(loadFromBackend)
        addDependency(loadFromDb)
        
        dbQueue.addOperation(loadFromBackend)
    }
    
    override func main() {
        if let notes = loadFromDb.result {
            result = notes
        }
        
        finish()
    }
}