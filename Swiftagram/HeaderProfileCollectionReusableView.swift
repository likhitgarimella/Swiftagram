//
//  HeaderProfileCollectionReusableView.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 22/06/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
import Firebase

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    func updateView() {
        
        /// Old code 1
        /* Api.User.REF_CURRENT_USER?.observeSingleEvent(of: .value, with: {
            snapshot in
            print(snapshot)
            
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict)
                self.nameLabel.text = user.usernameString
                if let photoUrlString = user.profileImageUrlString {
                    let photoUrl = URL(string: photoUrlString)
                    self.profileImage.sd_setImage(with: photoUrl)
                }
            }
            
        }) */
        
        /// Old code 2
        /* guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        Api.User.obersveUser(withId: currentUser.uid, completion: { (user) in
            self.nameLabel.text = user.usernameString
            if let photoUrlString = user.profileImageUrlString {
                let photoUrl = URL(string: photoUrlString)
                self.profileImage.sd_setImage(with: photoUrl)
            }
        }) */
        
        Api.User.observeCurrentUser { (user) in
            self.nameLabel.text = user.usernameString
            if let photoUrlString = user.profileImageUrlString {
                let photoUrl = URL(string: photoUrlString)
                self.profileImage.sd_setImage(with: photoUrl)
            }
        }
        
    }
        
}   // #63
