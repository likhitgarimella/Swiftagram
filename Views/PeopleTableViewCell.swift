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
        
        followButton.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
        
    }
    
    @objc func followAction() {
        
        Api.Follow.REF_FOLLOWERS.child(user!.id!).child(Api.UserDet.CURRENT_USER!.uid).setValue(true)
        Api.Follow.REF_FOLLOWING.child(Api.UserDet.CURRENT_USER!.uid).child(user!.id!).setValue(true)
        
    }
    
    @objc func unFollowAction() {
        
        Api.Follow.REF_FOLLOWERS.child(user!.id!).child(Api.UserDet.CURRENT_USER!.uid).setValue(NSNull())
        Api.Follow.REF_FOLLOWING.child(Api.UserDet.CURRENT_USER!.uid).child(user!.id!).setValue(NSNull())
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }

}   // #66
