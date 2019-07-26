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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        notesTable.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
        notesTable.rowHeight = UITableView.automaticDimension
        notesTable.estimatedRowHeight = 76.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        notesTable.reloadData()
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
                noteEditViewController.note = fileNotebook.notes[indexPath.row]
            }else{
                noteEditViewController.note = Note(title: "", content: "", priority: .base)
            }
        }
    }

}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNotebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        let note = fileNotebook.notes[indexPath.row]
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
            let uid = fileNotebook.notes[indexPath.row].uid
            fileNotebook.remove(with: uid)
            notesTable.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
}
