//
//  HomeTableViewCell.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 28/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
// import Firebase

/// If a View needs data, it should ask controllers...

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
    
    // linking home VC & home table view cell
    var homeVC: HomeViewController?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    /// when this user property is set..
    /// we'll let the cell download the correspoding cell..
    var user: AppUser? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateView() {
        
        captionLabel.text = post?.caption
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        
        setupUserInfo()
        
        /// Unscalable way of liking posts.. old method..
        /*
        /// We need to make the cell/post aware be aware, that current user liked it..
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("likes").child(post!.id!).observeSingleEvent(of: .value, with: {
                snapshot in
                print(snapshot)
                if let _ = snapshot.value as? NSNull {
                    // current user didn't like the post
                    self.likeImageView.image = UIImage(named: "like")
                } else {
                    // current user liked the post
                    self.likeImageView.image = UIImage(named: "likeSelected")
                }
            })
        }
        */
        
        /// Update like
        updateLike(post: post!)
        
        /// Update like count -> Old
        /*
        Api.Post.REF_POSTS.child(post!.id!).observe(.childChanged, with: {
            snapshot in
            print(snapshot)
            if let value = snapshot.value as? Int {
                self.likeCountButton.setTitle("\(value) likes", for: .normal)
            }
        })
        */
        
        /// Update like count -> New
        Api.Post.observeLikeCount(withPostId: post!.id!) { (post) in
            self.likeCountButton.setTitle("\(value) likes", for: .normal)
        }
        
        /// Smoothly update like, when scrolling view -> New
        Api.Post.observePost(withId: post!.id!, completion: { (post) in
            self.updateLike(post: post)
        })
        
        /*  // Old method
        /// Smoothly update like, when scrolling view
        Api.Post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                self.updateLike(post: post)
            }
        })
        */
        
    }
    
    func updateLike(post: Post) {
        
        print(post.isLiked)
        /// we first checked if its true, and no one liked this post before..
        /// or if probably someone did, but the current user did not..
        /// then we display, non-selected like icon..
        /// otherwise, display likeSelected icon..
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        /// Below commented snippet can be put in 1 line.. as above..
        /* if post.isLiked == false {
            likeImageView.image = UIImage(named: "like")
        } else {
            likeImageView.image = UIImage(named: "likeSelected")
        } */
        
        // We now update like count
        /// Use optional chaining with guard
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            likeCountButton.setTitle("\(count) likes", for: .normal)
        } else {
            likeCountButton.setTitle("Be the first to like this", for: .normal)
        }
        
    }
    
    /// New setupUserInfo() func
    /// previously, our cell had to go look up the db for a user based on the uid...
    /// it now knows all that information already...
    func setupUserInfo() {
        
        nameLabel.text = user?.usernameString
        if let photoUrlString = user?.profileImageUrlString {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Placeholder-image"))
        }
        
    }
    
    /// Delete old setupUserInfo() func
    /*
    /// it's job is to use uid to download user info...
    /// and assign that to the profile image view & name label properties...
    /// Old setupUserInfo() func
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
    */
    
    /// This is only called when a cell is loaded in a memory...
    /// It's not called when a cell is reused later...
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = ""
        captionLabel.text = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(commentImageViewTouch))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(likeImageViewTouch))
        likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func likeImageViewTouch() {
        
        /* if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("likes").child(post!.id!).setValue(true)
        } */
        
        /*
        if let currentUser = Auth.auth().currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("likes").child(post!.id!).observeSingleEvent(of: .value, with: {
                
                snapshot in
                print(snapshot)
                if let _ = snapshot.value as? NSNull {
                    // If no value, on image touch, then set value to true, which gives a like
                    Api.User.REF_USERS.child(currentUser.uid).child("likes").child(self.post!.id!).setValue(true)
                    self.likeImageView.image = UIImage(named: "likeSelected")
                } else {
                    // If already a value, on image touch, then remove value, which removes a like
                    Api.User.REF_USERS.child(currentUser.uid).child("likes").child(self.post!.id!).removeValue()
                    self.likeImageView.image = UIImage(named: "like")
                }
                
            })
        }
        */  /// Unscalable way of liking posts.. old method..
        
        postRef = Api.Post.REF_POSTS.child(post!.id!)
        incrementLikes(forRef: postRef)
        
    }
    
    func incrementLikes(forRef ref: DatabaseReference) {
        
        ref.runTransactionBlock ({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String: AnyObject], let uid = Auth.auth().currentUser?.uid {
                // print("Value 1: \(currentData.value)")
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String: Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject
                post["likes"] = likes as AnyObject
                
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            // print("Value 2: \(snapshot?.value)")
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
            
        }
        
    }
    
    @objc func commentImageViewTouch() {
        
        if let id = post?.uid {
            homeVC?.performSegue(withIdentifier: "commentSegue", sender: id)
        }
        
    }
    
    /// We can erase all old data before a cell is reused...
    /// this method will be called right before a cell is reused...
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = UIImage(named: "Placeholder-image")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }

}   // #284
