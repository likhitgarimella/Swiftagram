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
    
}

extension AppUser {
    
    static func transformUser(dict: [String: Any]) -> AppUser {
        
        let user = AppUser()
        user.emailString = dict["email"] as? String
        user.profileImageUrlString = dict["profileImgUrl"] as? String
        user.usernameString = dict["name"] as? String
        return user
        
    }
    
}   // #32
