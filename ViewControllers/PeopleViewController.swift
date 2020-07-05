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
        peopleTableView.backgroundColor = UIColor.white
        
    }
    
    func loadUsers() {
        
        Api.UserDet.observeUsers { (user) in
            self.users.append(user)
            self.peopleTableView.reloadData()
        }
        
    }
    
}

extension PeopleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        cell.backgroundColor = UIColor.white
        return cell
    }
    
}   // #50
