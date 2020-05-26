//
//  CameraViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class CameraViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var captionTextView: UITextView!
    @IBOutlet var shareOutlet: UIButton!
    
    var selectedImage: UIImage?
    
    // Delegate function
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    // Delegate function
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a caption..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    // progress hud
    let hud1 = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        Properties()
        
    }
    
    func Properties() {
        
        shareOutlet.layer.cornerRadius = 6
        
        captionTextView.backgroundColor = UIColor.white
        captionTextView.delegate = self     // text view delegate
        captionTextView.text = "Write a caption..."
        captionTextView.textColor = UIColor.lightGray
        
        // Add gesture for profile image present in screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
    }
    
    @objc func handleSelectPhoto() {
        
        let pickerController = UIImagePickerController()
        // To get access to selected media files, add delegate
        pickerController.delegate = self
        // present photo library
        pickerController.modalPresentationStyle = .fullScreen
        present(pickerController, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handlePost()
        
    }
    
    func handlePost() {
        
        if selectedImage != nil {
            self.shareOutlet.isEnabled = true
            shareOutlet.setTitleColor(UIColor.white, for: .normal)
            shareOutlet.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        } else {
            self.shareOutlet.isEnabled = false
            shareOutlet.setTitleColor(UIColor.lightText, for: .normal)
            shareOutlet.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        }
        
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        
        hud1.show(in: self.view)
        
        // selected image should be from image
        guard let imageSelected = self.selectedImage else {
            print("Avatar is nil")
            hud1.indicatorView = nil    // remove indicator
            hud1.textLabel.text = "Profile image can't be empty"
            hud1.dismiss(afterDelay: 2.0, animated: true)
            return
        }
        // image data from selected image in jpeg format
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        let photoIdString = NSUUID().uuidString
        print("Photo Id String: \(photoIdString)")
        let storageRef = Storage.storage().reference(forURL: "gs://swiftagram-1234.appspot.com").child("posts").child(photoIdString)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        // put image data
        storageRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            if error != nil {
                print(error!.localizedDescription)
                // progress hud
                self.hud1.show(in: self.view)
                self.hud1.indicatorView = nil    // remove indicator
                self.hud1.textLabel.text = error!.localizedDescription
                self.hud1.dismiss(afterDelay: 2.0, animated: true)
                return
            }
            // get download url for image from Firebase Storage
            storageRef.downloadURL { (url, error) in
                // convert that download url to string
                if let metaImageUrl = url?.absoluteString {
                    print(metaImageUrl)
                    self.sendDataToDatabase(photoUrl: metaImageUrl)
                }
            }
        }
    }
    
    func sendDataToDatabase(photoUrl: String) {
        
        let databaseRef = Database.database().reference().child("posts")
        let newPostId = databaseRef.childByAutoId().key
        let newPostReference = databaseRef.child(newPostId!)
        // put that download url string in db
        newPostReference.setValue(["photoUrl": photoUrl, "caption": captionTextView.text!], withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
                // progress hud
                self.hud1.show(in: self.view)
                self.hud1.indicatorView = nil    // remove indicator
                self.hud1.textLabel.text = error!.localizedDescription
                self.hud1.dismiss(afterDelay: 2.0, animated: true)
                return
            }
            self.hud1.show(in: self.view)
            self.hud1.indicatorView = nil    // remove indicator
            self.hud1.textLabel.text = "Success!"
            self.photo.image = UIImage(named: "Placeholder-image")
            self.selectedImage = nil
            self.captionTextView.textColor = UIColor.lightGray
            self.hud1.dismiss(afterDelay: 2.0, animated: true)
            self.tabBarController?.selectedIndex = 0
        })
        
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Selected image to display it in our profile image
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Store this img in an instance variable
            selectedImage = image
            // set profile image's imageView to selected image
            photo.image = image
        }
        print("Image selected from library")
        dismiss(animated: true, completion: nil)
    }
    
}   // #184
