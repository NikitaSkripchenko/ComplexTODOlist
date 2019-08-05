//
//  NotesListViewController.swift
//  Stepik
//
//  Created by Nikita Skrypchenko  on 7/25/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {
    
    @IBOutlet weak var notesTable: UITableView!
    private let fileNotebook = (UIApplication.shared.delegate as! AppDelegate).fileNotebook
    
    private var notes: [Note] = []{
        didSet{
            notes.sort(by: {$0.title < $1.title})
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        notesTable.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
        notesTable.rowHeight = UITableView.automaticDimension
        notesTable.estimatedRowHeight = 76.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let loadNotesOperation = LoadNotesOperation(notebook: fileNotebook, backendQueue: OperationQueue(), dbQueue: OperationQueue())
        
        loadNotesOperation.completionBlock = {
            let loadedNotes = loadNotesOperation.result ?? []
            print("Downloading notes completed. Uploaded \(loadedNotes.count) notes")
            self.notes = loadedNotes
            
            OperationQueue.main.addOperation {
                print("Updating the table after loading data")
                self.notesTable.reloadData()
                super.viewWillAppear(animated)
            }
        }
        OperationQueue().addOperation(loadNotesOperation)
    }
    
    func setupNavigation(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editNotes))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButton
    }
    
    @objc func addNote(){
        performSegue(withIdentifier: "ShowNoteEditScreen", sender: nil)
    }
    
    @objc func editNotes(){
        notesTable.setEditing(!notesTable.isEditing, animated: true)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        navigationItem.leftBarButtonItem = doneButton
    }
    
    @objc func doneEditing(){
        notesTable.setEditing(!notesTable.isEditing, animated: true)
        setupNavigation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let noteEditViewController = segue.destination as? ViewController, segue.identifier == "ShowNoteEditScreen"{
            noteEditViewController.fileNotebook = fileNotebook
            if let cell = sender as? NoteTableViewCell, let indexPath = notesTable.indexPath(for: cell){
                noteEditViewController.note = notes[indexPath.row]
            }else{
                noteEditViewController.note = Note(title: "", content: "", priority: .base)
            }
        }
    }

}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        let note = notes[indexPath.row]
        cell.colorView.backgroundColor = note.color
        cell.nameLabel.text = note.title
        cell.gistLabel.text = note.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNoteEditScreen", sender: tableView.cellForRow(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let uid = notes[indexPath.row].uid
            let removeNote = RemoveNoteOperation(noteId: uid, notebook: fileNotebook, backendQueue: OperationQueue(), dbQueue: OperationQueue())
            
            removeNote.completionBlock = {
                OperationQueue.main.addOperation {
                    self.notes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    print("deleted")
                }
            }
            OperationQueue().addOperation(removeNote)
        }
    }
    
}
