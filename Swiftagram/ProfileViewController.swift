//
//  ProfileViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileCollectionView: UICollectionView!
    
    var user: User!
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        profileCollectionView.dataSource = self
        
        fetchUser()
        
        fetchMyPosts()
        
    }
    
    func fetchUser() {
        
        /// observeCurrentUser
        Api.User.observeCurrentUser { (user) in
            self.user = user
            self.profileCollectionView.reloadData()
        }
        
    }
    
    func fetchMyPosts() {
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        Api.MyPosts.REF_MYPOSTS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            print(snapshot)
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                print(post.id)
                self.posts.append(post)
                self.profileCollectionView.reloadData()
            })
        })
        
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
        }
        return headerViewCell
        
    }
    
}   // #85
