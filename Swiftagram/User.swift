//
//  User.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 28/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import Foundation

class User {
    
    var emailString: String?
    var profileImageUrlString: String?
    var usernameString: String?
    
}

extension User {
    
    static func transformUser(dict: [String: Any]) -> User {
        
        let user = User()
        user.emailString = dict["email"] as? String
        user.profileImageUrlString = dict["profileImgUrl"] as? String
        user.usernameString = dict["name"] as? String
        return user
        
    }
    
}   // #32
