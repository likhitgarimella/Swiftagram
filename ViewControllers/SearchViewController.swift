//
//  SearchViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 15/07/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var peopleTableView: UITableView!
    
    var searchBar = UISearchBar()
    
    var users: [AppUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        peopleTableView.backgroundColor = UIColor.white
        
        searchBar.delegate = self
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
        doSearch()  // displaying when screen loads, to tell user what it is about
        
    }
    
    func doSearch() {
        if let searchText = searchBar.text?.lowercased() {  /// since, we are searching for lowercased
            /// remove & empty the array before any new search
            self.users.removeAll()
            self.peopleTableView.reloadData()
            Api.UserDet.queryUsers(withText: searchText) { (user) in
                self.isFollowing(userId: user.id!, completed: {
                    (value) in
                    user.isFollowing = value
                    self.users.append(user)
                    self.peopleTableView.reloadData()
                })
            }
        }
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        cell.backgroundColor = UIColor.white
        
        let user = users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
}   // #88
