//
//  PostCommentApi.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 18/06/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import Foundation
import Firebase

/// Write your own Api, to conveniently observe database data...

class PostCommentApi {
    
    var REF_POST_COMMENTS = Database.database().reference().child("post-comments")
    
    func observePostComments(withPostId id: String) {
        
        
        
    }
    
    /* func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
        
        REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
            
        })
        
    } */
    
}   // #38
