//
//  HeaderProfileCollectionReusableView.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 22/06/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    func updateView() {
        
        Api.User.REF_CURRENT_USER?.observeSingleEvent(of: .value, with: {
            snapshot in
            print(snapshot)
        })
        
    }
        
}   // #23
