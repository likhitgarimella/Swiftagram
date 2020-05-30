//
//  CommentViewController.swift
//  Swiftagram
//
//  Created by Likhit Garimella on 30/05/20.
//  Copyright © 2020 Likhit Garimella. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet var facultyListTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func Properties() {
        
        facultyListTableView.backgroundColor = UIColor.white
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Properties()
        
    }

}   // #34
