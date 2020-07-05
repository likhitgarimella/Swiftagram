//
//  PeopleViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 05/07/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    @IBOutlet weak var peopleTableView: UITableView!
    
    var users: [AppUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        loadUsers()
        
    }
    
    func loadUsers() {
        
        Api.UserDet.observeUsers { (user) in
            self.users.append(user)
            self.peopleTableView.reloadData()
        }
        
    }
    
}   // #35
