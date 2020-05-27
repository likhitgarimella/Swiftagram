//
//  Post.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 27/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import Foundation

class Post {
    
    var caption: String
    var photoUrl: String
    
    init(captionText: String, photoUrlString: String) {
        
        caption = captionText
        photoUrl = photoUrlString
        
    }
    
}   // #24
