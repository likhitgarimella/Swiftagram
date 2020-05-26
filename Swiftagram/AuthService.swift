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
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        print("Sign in")
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        }
        
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        print("Sign up")
        // Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                onError(error!.localizedDescription)
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
                    print(error!.localizedDescription)
                    return
                }
                // get download url for image from Firebase Storage
                storageProfileRef.downloadURL { (url, error) in
                    // convert that download url to string
                    if let metaImageUrl = url?.absoluteString {
                        print(metaImageUrl)
                        self.setUserInformation(profileImageUrl: metaImageUrl, username: username, email: email, uid: uid, onSuccess: onSuccess)
                    }
                }
            }
            
        })
        
    }
    
    static func setUserInformation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        
        let databaseRef = Database.database().reference().child("users").child(uid)
        // put that download url string in db
        databaseRef.setValue(["name": username, "email": email, "profileImgUrl": profileImageUrl])
        onSuccess()
        
    }
    
}   // #78
