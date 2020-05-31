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
        
    }
    
    // progress hud
    let hud1 = JGProgressHUD(style: .dark)
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        let databaseRef = Database.database().reference()
        let commentsRef = databaseRef.child("comments")
        let newCommentId = commentsRef.childByAutoId().key
        let newCommentReference = databaseRef.child(newCommentId!)
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
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
            self.empty()
        })
        
    }
    
    func empty() {
        
        self.commentTextField.text = ""
        self.sendOutlet.isEnabled = false
        self.sendOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        
    }
    
}   // #98
