//
//  SignUpViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // Outlets
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpOutLet: UIButton!
    @IBOutlet var backToSignInOutLet: UIButton!
    @IBOutlet var profileImage: UIImageView!
    
    var selectedImage: UIImage?
    
    var image: UIImage? = nil
    
    func Colors() {
        
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        signUpOutLet.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        backToSignInOutLet.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        
    }
    
    func CornerRadius() {
        
        // Textfield Corner Radius Property
        nameTextField.layer.cornerRadius = 4
        emailTextField.layer.cornerRadius = 4
        passwordTextField.layer.cornerRadius = 4
        signUpOutLet.layer.cornerRadius = 6
        backToSignInOutLet.layer.cornerRadius = 6
        
    }
    
    func LeftPadding() {
        
        // Create a padding view for Credits TextFields on LEFT
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: nameTextField.frame.height))
        nameTextField.leftViewMode = .always
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: emailTextField.frame.height))
        emailTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: passwordTextField.frame.height))
        passwordTextField.leftViewMode = .always
        
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Invalid Form Input")
            return
        }
        guard let imageSelected = self.image else {
            print("Avatar is nil")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.user.uid else {
                return
            }
            // Storage
            let storageRef = Storage.storage().reference(forURL: "gs://swiftagram-1234.appspot.com")
            let storageProfileRef = storageRef.child("profile_image").child(uid)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storageProfileRef.downloadURL { (url, error) in
                    if let metaImageUrl = url?.absoluteString {
                        print(metaImageUrl)
                        let values = ["name": name, "email": email, "profileImgUrl": metaImageUrl]
                        let databaseRef = Database.database().reference().child("users").child(uid)
                        databaseRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                            if error == nil {
                                print("Done")
                            }
                        })
                    }
                }
            }
            
        })
        
    }
    
    @IBAction func haveAccountSignInPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Colors()
        hideKeyboardWhenTappedAround()
        CornerRadius()
        LeftPadding()
        ProfileImage()
        
    }
    
    func ProfileImage() {
        
        profileImage.layer.cornerRadius = 50
        profileImage.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
    }
    
    @objc func handleSelectProfileImageView() {
        
        let pickerController = UIImagePickerController()
        // To get access to selected media files
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }

}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image selected from library")
        // Selected photo to display it in our profile image
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = imageSelected
            // Store this img in an instance variable
            image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = imageOriginal
            // Store this img in an instance variable
            image = imageOriginal
        }
        // print(info)
        dismiss(animated: true, completion: nil)
    }
    
}   // #166
