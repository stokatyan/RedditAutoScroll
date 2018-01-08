//
//  HomeVC_tableview.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/29/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

struct CellType {
    static let regular = "Post_tvCell"
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func initializeTableView() {
        _tableview.dataSource = self
        _tableview.delegate = self
        _tableview.register(UINib(nibName: CellType.regular, bundle: nil), forCellReuseIdentifier: CellType.regular)
        _tableview.estimatedRowHeight = 140
        _tableview.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homePresenter.getPostCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.regular, for: indexPath) as! Post_tvCell
        
        if let redditPost = homePresenter.getPost(index) {
            cell.displayContents(of: redditPost)
        }
        
        return cell
    }
    
    
}
