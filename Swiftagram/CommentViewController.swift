//
//  CommentViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 30/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class CommentViewController: UIViewController {
    
    @IBOutlet var facultyListTableView: UITableView!
    
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet var sendOutlet: UIButton!
    
    // dummy post id taken for example
    let postId = "-M8Poh6AuFNqkM9ITDlc"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func Properties() {
        
        facultyListTableView.backgroundColor = UIColor.white
        
    }
    
    func handleTextField() {
        
        commentTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        
        if let commentText = commentTextField.text, !commentText.isEmpty {
            sendOutlet.setTitleColor(UIColor.systemBlue, for: .normal)
            sendOutlet.isEnabled = true
            return
        }
        
        sendOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        sendOutlet.isEnabled = false
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Properties()
        hideKeyboardWhenTappedAround()
        empty()
        handleTextField()
        loadComments()
        
    }
    
    // displaying all comments for a post
    func loadComments() {
        
        let postCommentRef = Database.database().reference().child("post-comments").child(self.postId)
        postCommentRef.observe(.childAdded, with: {
            snapshot in
            print("snapshot key")
            print(snapshot.key)
            Database.database().reference().child("comments").child(snapshot.key).observe(.value, with: {
                snapshotComment in
                print("snapshot comment")
                print(snapshotComment.value)
            })
        })
        
    }
    
    // progress hud
    let hud1 = JGProgressHUD(style: .dark)
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        let databaseRef = Database.database().reference()
        let commentsRef = databaseRef.child("comments")
        // a unique id that is generated for every comment
        let newCommentId = commentsRef.childByAutoId().key
        let newCommentReference = commentsRef.child(newCommentId!)
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        // uid of a user
        let currentUserId = currentUser.uid
        // put that download url string in db
        newCommentReference.setValue(["uid": currentUserId, "commentText": commentTextField.text!], withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
                // progress hud
                self.hud1.show(in: self.view)
                self.hud1.indicatorView = nil    // remove indicator
                self.hud1.textLabel.text = error!.localizedDescription
                self.hud1.dismiss(afterDelay: 2.0, animated: true)
                return
            }
            // new node to map 'posts' & 'comments'
            let postCommentRef = databaseRef.child("post-comments").child(self.postId).child(newCommentId!)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error!.localizedDescription)
                    // progress hud
                    self.hud1.show(in: self.view)
                    self.hud1.indicatorView = nil    // remove indicator
                    self.hud1.textLabel.text = error!.localizedDescription
                    self.hud1.dismiss(afterDelay: 2.0, animated: true)
                    return
                }
            })
            // empty and disable after a comment is posted
            self.empty()
        })
        
    }
    
    // empty and disable after a comment is posted
    func empty() {
        
        self.commentTextField.text = ""
        self.sendOutlet.isEnabled = false
        self.sendOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        
    }
    
}   // #136
