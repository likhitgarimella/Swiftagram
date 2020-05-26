//
//  CameraViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var captionTextView: UITextView!
    @IBOutlet var shareOutlet: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Properties()
        
    }
    
    func Properties() {
        
        captionTextView.backgroundColor = UIColor.white
        
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
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        
        
        
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
    
}   // #70
