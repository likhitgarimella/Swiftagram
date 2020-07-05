//
//  ProfileViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
// import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileCollectionView: UICollectionView!
    
    var user: AppUser!
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        
        fetchUser()
        
        fetchMyPosts()
        
    }
    
    func fetchUser() {
        
        /// observeCurrentUser
        Api.UserDet.observeCurrentUser { (user) in
            self.user = user
            self.title = user.usernameString
            self.profileCollectionView.reloadData()
        }
        
    }
    
    func fetchMyPosts() {
        
        guard let currentUser = Api.UserDet.CURRENT_USER else {
            return
        }
        Api.MyPosts.REF_MYPOSTS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            print(snapshot)
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                // print(post.id)
                self.posts.append(post)
                self.profileCollectionView.reloadData()
            })
        })
        
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
        }
        return headerViewCell
        
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    // spacing b/w rows in coll view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        /// spacing distance = 2
        return 2
    }
    
    // spacing b/w columns in coll view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// shrink by 1 point for each cell, so that spacing becomes 2 b/w cell-to-cell
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
    
}   // #109
