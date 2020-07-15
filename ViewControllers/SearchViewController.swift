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
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
    }

}   // #28
