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
        return post
        
    }
    
    // Video
    static func transformPostVideo() {
        
        
        
    }
    
}   // #58
