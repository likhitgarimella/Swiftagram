//
//  SignUpViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // Outlets
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpOutLet: UIButton!
    @IBOutlet var backToSignInOutLet: UIButton!
    
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
    
    @IBAction func haveAccountSignInPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Colors()
        hideKeyboardWhenTappedAround()
        CornerRadius()
        LeftPadding()
        
    }

}   // #68
