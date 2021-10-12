//
//  ViewController.swift
//  Project25
//
//  Created by othman shahrouri on 10/11/21.
//
/*
 Multipeer connectivity requires four new classes:

1.MCSession is the manager class that handles all multipeer connectivity for us.

2.MCPeerID identifies each user uniquely in a session.

3.MCAdvertiserAssistant is used when creating a session, telling others that we exist and handling invitations.

4.MCBrowserViewController is used when looking for sessions, showing users who is nearby and letting them join.

 We're going to use all four of them in our app, but only three need to be properties.
 
 */



import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selfie Shate"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
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
    
    //ask users whether they want to connect to an existing session with other people
    //or whether they want to create their own
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join as session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true )
    }
}

