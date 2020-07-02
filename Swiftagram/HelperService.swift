//
//  HelperService.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 01/07/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import Foundation
import Firebase

class HelperService {
    
    static func uploadDataToServer(data: Data, caption: String, onSuccess: @escaping () -> Void) {
        // NSUUID
        let photoIdString = NSUUID().uuidString
        print("Photo Id String: \(photoIdString)")
        let storageRef = Storage.storage().reference(forURL: "gs://swiftagram-1234.appspot.com").child("posts").child(photoIdString)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        // put image data
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            // get download url for image from Firebase Storage
            storageRef.downloadURL { (url, error) in
                // convert that download url to string
                if let metaImageUrl = url?.absoluteString {
                    print(metaImageUrl)
                    self.sendDataToDatabase(photoUrl: metaImageUrl, caption: caption, onSuccess: onSuccess)
                }
            }
        }
    }
    
    static func sendDataToDatabase(photoUrl: String, caption: String, onSuccess: @escaping () -> Void) {
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.Post.REF_POSTS.child(newPostId!)
        guard let currentUser = Api.UserDet.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        // put that download url string in db
        newPostReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "caption": caption], withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            // reference for my posts
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId!)
            myPostRef.setValue(true, withCompletionBlock: {
                (error, ref) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
            })
            onSuccess()
        })
    }
    
}   // #65
