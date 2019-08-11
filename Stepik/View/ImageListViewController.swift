//
//  ImageListViewController.swift
//  Stepik
//
//  Created by Nikita Skrypchenko  on 7/26/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {
    
    private let numberOfImagesInRow:CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    private let fileNotebook = (UIApplication.shared.delegate as! AppDelegate).fileNotebook
    private var imagePickerController = UIImagePickerController()
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func addImage(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName:"ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageNote")
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageNoteViewController = segue.destination as? ImageDetailViewController,
            segue.identifier == "ShowImageNoteScreen",
            let indexPath = sender as? IndexPath {
            imageNoteViewController.fileNotebook = fileNotebook
            imageNoteViewController.indexPath = indexPath.row
        }
    }

}

extension ImageListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imageNote = ImageNote(name: url.lastPathComponent)
            fileNotebook.add(imageNote)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileNotebook.imageNotes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageNote", for: indexPath) as! ImageCollectionViewCell
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        let note = fileNotebook.imageNotes[indexPath.row]
        DispatchQueue.global(qos: .background).async {
            let image = UIImage(contentsOfFile: note.path)
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (numberOfImagesInRow + 1)
        let availableSpace = collectionView.frame.width - paddingSpace
        let imageSpace = availableSpace / numberOfImagesInRow
        return CGSize(width: imageSpace, height: imageSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: location)
        if let index = indexPath {
            performSegue(withIdentifier: "ShowImageNoteScreen", sender: index)
        }
    }
}
