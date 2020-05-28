//
//  HomeTableViewCell.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 28/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var likeImageView: UIImageView!
    @IBOutlet var commentImageView: UIImageView!
    @IBOutlet var shareImageView: UIImageView!
    @IBOutlet var likeCountButton: UIButton!
    @IBOutlet var captionLabel: UILabel!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        captionLabel.text = post?.caption
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        
       setupUserInfo()
        
    }
    
    /// it's job is to use uid to download user info...
    /// and assign that to the profile image view & name label properties...
    func setupUserInfo() {
        
        if let uid = post?.uid {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: Any] {
                    let user = User.transformUser(dict: dict)
                    self.nameLabel.text = user.usernameString
                    if let photoUrlString = user.profileImageUrlString {
                        let photoUrl = URL(string: photoUrlString)
                        // display placeholder image before image gets loaded
                        self.profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Placeholder-image"))
                    }
                }
            })
        }
        
    }
    
    /// This is only called when a cell is loaded in a memory...
    /// It's not called when a cell is reused later...
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = ""
        captionLabel.text = ""
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }

}   // #80
