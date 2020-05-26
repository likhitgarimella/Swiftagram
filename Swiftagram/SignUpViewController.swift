//
//  SignUpViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

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
        
        // dismiss keyboard
        view.endEditing(true)
        
        // progress hud
        let hud1 = JGProgressHUD(style: .dark)
        // hud1.textLabel.text = "Please Wait..."
        hud1.show(in: self.view)
        
        // validations
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = nameTextField.text else {
            print("Invalid Form Input")
            return
        }
        // selected image should be from image
        guard let imageSelected = self.image else {
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
        
        AuthService.signUp(username: username, email: email, password: password, imageData: imageData, onSuccess: {
            print("On Success")
            hud1.indicatorView = nil    // remove indicator
            hud1.textLabel.text = "Welcome!"
            hud1.dismiss(afterDelay: 2.0, animated: true)
            // segue to tab bar VC
            self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
        }) {errorString in
            // this will be the one which prints error due to auth, in console
            print(errorString!)
            hud1.indicatorView = nil    // remove indicator
            hud1.textLabel.text = errorString!
            hud1.dismiss(afterDelay: 2.0, animated: true)
        }
        
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
        
        signUpOutLet.isEnabled = false
        
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
        print("Image selected from library")
        dismiss(animated: true, completion: nil)
    }
    
}   // #194
