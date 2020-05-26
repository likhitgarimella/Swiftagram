//
//  AuthService.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 26/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void) {
        
        print("Sign in")
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            onSuccess()
        }
        
    }
    
}   // #28
