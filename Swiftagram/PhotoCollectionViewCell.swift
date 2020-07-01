//
//  PhotoCollectionViewCell.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 01/07/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        
        
    }
    
}   // #28
