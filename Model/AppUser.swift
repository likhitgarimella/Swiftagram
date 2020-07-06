//
//  User.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 28/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import Foundation

class AppUser {
    
    var emailString: String?
    var profileImageUrlString: String?
    var usernameString: String?
    
    var id: String?
    
    var isFollowing: String?
    
}

extension AppUser {
    
    static func transformUser(dict: [String: Any], key: String) -> AppUser {
        
        let user = AppUser()
        user.emailString = dict["email"] as? String
        user.profileImageUrlString = dict["profileImgUrl"] as? String
        user.usernameString = dict["name"] as? String
        
        user.id = key
        return user
        
    }
    
}   // #38
