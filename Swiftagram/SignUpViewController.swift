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
    
    // global variable for selected image
    var selectedImage: UIImage?
    
    // image that appears on screen as profile image for user
    // an Optional
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
        
        // validations
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Invalid Form Input")
            return
        }
        // selected image should be from image
        guard let imageSelected = self.image else {
            print("Avatar is nil")
            return
        }
        // image data from seleceted image in jpeg format
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        // Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            // unique user id
            guard let uid = user?.user.uid else {
                return
            }
            
            // Firebase Storage
            // reference url
            let storageRef = Storage.storage().reference(forURL: "gs://swiftagram-1234.appspot.com")
            let storageProfileRef = storageRef.child("profile_image").child(uid)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            // put image data
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
                if error != nil {
                    print(error!)
                    return
                }
                // get download url for image from Firebase Storage
                storageProfileRef.downloadURL { (url, error) in
                    // convert that download url to string
                    if let metaImageUrl = url?.absoluteString {
                        print(metaImageUrl)
                        // put that download url string in db
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
        handleTextField()
        ProfileImage()
        
    }
    
    func handleTextField() {
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        
        guard let username = nameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpOutLet.setTitleColor(UIColor.lightText, for: .normal)
            signUpOutLet.isEnabled = false
            return
        }
        
        signUpOutLet.setTitleColor(UIColor.white, for: .normal)
        signUpOutLet.isEnabled = true
        
    }
    
    func ProfileImage() {
        
        // Profile image properties
        profileImage.layer.cornerRadius = 50
        profileImage.layer.masksToBounds = true
        
        // Add gesture for profile image present in screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
    }
    
    @objc func handleSelectProfileImageView() {
        
        let pickerController = UIImagePickerController()
        // To get access to selected media files, add delegate
        pickerController.delegate = self
        // present photo library
        present(pickerController, animated: true, completion: nil)
        
    }

}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image selected from library")
        // Selected image to display it in our profile image
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            // set profile image's imageView to selected image
            profileImage.image = imageSelected
            // Store this img in an instance variable
            image = imageSelected
        }
        // Original image
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // set profile image's imageView to original image
            profileImage.image = imageOriginal
            // Store this img in an instance variable
            image = imageOriginal
        }
        dismiss(animated: true, completion: nil)
    }
    
}   // #208
