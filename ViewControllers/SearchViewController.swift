//
//  SearchViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 15/07/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
    }
    
    func doSearch() {
        if let searchText = searchBar.text {
            Api.UserDet.queryUsers(withText: searchText) { (user) in
                
            }
        }
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text)
    }
    
}   // #50
