//
//  ViewController.swift
//  Project25
//
//  Created by othman shahrouri on 10/11/21.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selfie Shate"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        //all UIView subclasses have a method called viewWithTag(), which searches for any views inside itself (or indeed itself) with that tag number(we specified in inspector = 1000). We can find our image view just by using this method
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            //we found the imageView inside our cell
            imageView.image = images[indexPath.item]
        }
        return cell
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard  let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        images.insert(image, at: 0)
        collectionView.reloadData()
    }
    
    
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

