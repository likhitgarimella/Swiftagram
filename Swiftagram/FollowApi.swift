//
//  FollowApi.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 05/07/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import Foundation
import Firebase

class FollowApi {
    
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    func followAction(withUser id: String) {
        REF_FOLLOWERS.child(id).child(Api.UserDet.CURRENT_USER!.uid).setValue(true)
        REF_FOLLOWING.child(Api.UserDet.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id: String) {
        REF_FOLLOWERS.child(id).child(Api.UserDet.CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Api.UserDet.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
}   // #28
