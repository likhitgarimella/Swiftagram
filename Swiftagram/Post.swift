//
//  Post.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 27/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import Foundation

class Post {
    
    var caption: String?
    var photoUrl: String?
    // var videoUrl: String?
    var uid: String?
    
    /// Remodel Post class, bcuz it currently doesn't have a post id property
    var id: String?
    
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    
    /*
    init(captionText: String, photoUrlString: String) {
        caption = captionText
        photoUrl = photoUrlString
    }
    
    init(captionText: String, videoUrlString: String) {
        caption = captionText
        videoUrl = videoUrlString
    }
    */
    
}

extension Post {
    
    // Photo
    static func transformPostPhoto(dict: [String: Any], key: String) -> Post {
        
        let post = Post()
        /// Remodel Post class, bcuz it currently doesn't have a post id property
        post.id = key
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.uid = dict["uid"] as? String
        
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        
        return post
        
    }
    
    // Video
    static func transformPostVideo() {
        
        
        
    }
    
}   // #65
