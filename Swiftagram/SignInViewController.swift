//
//  SignInViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    // Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInOutLet: UIButton!
    @IBOutlet var signUpOutLet: UIButton!
    
    func Colors() {
        
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        signInOutLet.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        signUpOutLet.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        
    }
    
    func CornerRadius() {
        
        // Textfield Corner Radius Property
        emailTextField.layer.cornerRadius = 4
        passwordTextField.layer.cornerRadius = 4
        signInOutLet.layer.cornerRadius = 6
        signUpOutLet.layer.cornerRadius = 6
        
    }
    
    func LeftPadding() {
        
        // Create a padding view for Credits TextFields on LEFT
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: emailTextField.frame.height))
        emailTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: passwordTextField.frame.height))
        passwordTextField.leftViewMode = .always
        
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToSignUp", sender: self)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Colors()
        hideKeyboardWhenTappedAround()
        CornerRadius()
        LeftPadding()
        
    }

}   // #70
