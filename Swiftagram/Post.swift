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
    static func transformPostPhoto(dict: [String: Any]) -> Post {
        
        let post = Post()
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.uid = dict["uid"] as? String
        return post
        
    }
    
    // Video
    /* static func transformPostVideo() -> Post {
        
        
        
    } */
    
}   // #53
