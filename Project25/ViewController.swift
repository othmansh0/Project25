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
 
 ------------------------------------------------------------------------------------------
 all multipeer services on iOS must declare a service type, which is a 15-digit string that uniquely identify your service. Those 15 digits can contain only the letters A-Z, numbers and hyphens, and it's usually preferred to include your company in there somehow
 
 This service type is used by both MCAdvertiserAssistant and MCBrowserViewController to make sure your users only see other users of the same app. They both also want a reference to your MCSession instance so they can take care of connections for you
 ------------------------------------------------------------------------------------------
 
 
 */


import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,MCSessionDelegate,MCBrowserViewControllerDelegate {
    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selfie Shate"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        
        // peer ID is used to create the session, along with the encryption option of .required
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        //tell us when something happens
        mcSession.delegate = self
        
    }
    //MARK: - Start Hosting
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        //Used when creating a session, telling others that we exist and handling invitations
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        
    }
    //MARK: - Join Session
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        
        //used when looking for sessions, showing users who is nearby and letting them join
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
        
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
        
        // we're going to add some code to the image picker's didFinishPickingMediaWithInfo method so that when an image is added it also gets sent out to peers.
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
    
    //to silent errors,required for protcol
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    //for multipeer browser
    //called when it finishes successfully
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    // called when user cancels
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    
    //When a user connects or disconnects from our session, the method session(_:peer:didChangeState:) is called so you know what's changed – is someone connecting, are they now connected, or have they just disconnected?
    //useful for debugging
    
    
    //When this method is called, you'll be told what peer changed state, and what their new state is. There are only three possible session states: not connected, connecting, and connected
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .connected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("unknown state received \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
            
        }
    }
    
}

