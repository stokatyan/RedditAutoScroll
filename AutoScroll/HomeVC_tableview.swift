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
    static let video = "Post_tvCell_Video"
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func initializeTableView() {
        _tableview.dataSource = self
        _tableview.delegate = self
        _tableview.register(UINib(nibName: CellType.regular, bundle: nil), forCellReuseIdentifier: CellType.regular)
        _tableview.register(UINib(nibName: CellType.regular, bundle: nil), forCellReuseIdentifier: CellType.video)
        _tableview.estimatedRowHeight = 140
        _tableview.rowHeight = UITableViewAutomaticDimension
        _tableview.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homePresenter.getPostCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let redditPost = homePresenter.getPost(indexPath.row) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.regular, for: indexPath) as! Post_tvCell
        cell.displayContents(of: redditPost)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let redditPost = cell as? Post_tvCell else {
            return
        }
        
        redditPost.removePreviewContent()
    }
    
}
