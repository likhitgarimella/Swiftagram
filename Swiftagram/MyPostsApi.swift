//
//  MyPostsApi.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/06/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import Foundation

import Firebase

/// Write your own Api, to conveniently observe database data...

class MyPostsApi {
    
    var REF_MY_POSTS = Database.database().reference().child("myPosts")

}
