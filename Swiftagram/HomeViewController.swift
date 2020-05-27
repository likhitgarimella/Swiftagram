//
//  HomeViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 24/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nav bar button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.systemTeal
        
        loadPosts()
        
        // var post = Post(captionText: "test", photoUrlString: "url1")
        // print(post.caption)
        // print(post.photoUrl)
        
    }
    
    func loadPosts() {
        
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            // print(snapshot.value)
            if let dict = snapshot.value as? [String: Any] {
                // print(dict)
                /// Unexpectedly found nil while unwrapping an Optional value...
                /// To resolve this issue...
                /// Add 'if let' instead of just 'let'...
                if let captionText = dict["caption"] as? String, let photoUrlString = dict["photoUrl"] as? String {
                    let post = Post(captionText: captionText, photoUrlString: photoUrlString)
                    self.posts.append(post)
                    print(self.posts)
                    self.tableView.reloadData()
                }
            }
        }
        
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = UIColor.gray
        return cell
    }
    
}   // #84
