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
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }

}   // #49
