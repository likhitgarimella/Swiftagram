//
//  HomeViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // reference to store Post class info
    var posts = [Post]()
    
    // reference to store User class info
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nav bar button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.systemTeal
        
        Properties()
        
        loadPosts()
        
        // var post = Post(captionText: "test", photoUrlString: "url1")
        // print(post.caption)
        // print(post.photoUrl)
        
    }
    
    func Properties() {
        
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 515
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    func loadPosts() {
        
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            
            // print(snapshot.value)
            /// To check the status...
            print(Thread.isMainThread)
            // dict - snapshot
            if let dict = snapshot.value as? [String: Any] {
                
                let newPost = Post.transformPostPhoto(dict: dict)
                // print(dict)
                /// Unexpectedly found nil while unwrapping an Optional value...
                /// To resolve this issue...
                /// Add 'if let' instead of just 'let'...
                /* if let captionText = dict["caption"] as? String, let photoUrlString = dict["photoUrl"] as? String {
                    let post = Post(captionText: captionText, photoUrlString: photoUrlString)
                    self.posts.append(post)
                    print(self.posts)
                    self.tableView.reloadData()
                } */
                // self.fetchUser(uid: newPost.uid!)
                self.fetchUser(uid: newPost.uid!, completed: {
                    self.posts.append(newPost)
                    print(self.posts)
                    self.tableView.reloadData()
                })
                
            }
            
        }
        
    }
    
    /// it's job is to...
    /// given a user id, look up the corresponding user on db...
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
        })
        
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
            print("----------------")
        } catch let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
        
    }

}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.backgroundColor = UIColor.white
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        return cell
    }
    
}   // #130
