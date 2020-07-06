//
//  PeopleTableViewCell.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 05/07/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    
    var user: AppUser? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        nameLabel.text = user?.usernameString
        if let photoUrlString = user?.profileImageUrlString {
            let photoUrl = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Placeholder-image"))
        }
        
        /// Smoothly update follow and following, when scrolling view -> New
        Api.Follow.isFollowing(userId: user!.id!) { (value) in
            if value {
                /// user already following, so on tapping should unfollow
                self.configureUnFollowButton()
            } else {
                /// user not following, so on tapping should follow
                self.configureFollowButton()
            }
        }
        
        /* if user!.isFollowing! {
            /// user already following, so on tapping should unfollow
            configureUnFollowButton()
        } else {
            /// user not following, so on tapping should follow
            configureFollowButton()
        } */
        
    }
    
    func configureFollowButton() {
        
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followButton.setTitle("Follow", for: .normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)
        
    }
    
    func configureUnFollowButton() {
        
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        followButton.setTitleColor(UIColor.black, for: .normal)
        followButton.backgroundColor = UIColor.clear
        followButton.setTitle("Following", for: .normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
        
    }
    
    @objc func followAction() {
        
        Api.Follow.followAction(withUser: user!.id!)
        configureUnFollowButton()
        
    }
    
    @objc func unFollowAction() {
        
        Api.Follow.unFollowAction(withUser: user!.id!)
        configureFollowButton()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }

}   // #108
