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
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.user.uid else {
                return
            }
            
            // Storage
            let storageRef = Storage.storage().reference(forURL: "gs://swiftagram-1234.appspot.com").child("profile_image").child(uid)
            if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
                
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    // Url where our data lives
                    metadata?.storageReference?.downloadURL(completion: { (url, err1) in
                        
                        if err1 != nil {
                            print(err1!)
                            return
                        } else {
                            // Successfully registered user
                            let ref = Database.database().reference()
                            let usersReference = ref.child("users").child(uid)
                            if let profileImageUrl = url?.absoluteString {
                                let values = ["name": name, "email": email, "profileImgUrl": profileImageUrl]
                                usersReference.setValue(values)
                            }
                        }
                    })
                    
                })
                
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
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            profileImage.image = image
            // Store this img in an instance variable
            selectedImage = image
        }
        // print(info)
        dismiss(animated: true, completion: nil)
    }
    
}   // #160
