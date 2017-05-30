//
//  HomeVC_tableview.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/29/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func initializeTableView() {
        _tableview.dataSource = self
        _tableview.delegate = self
        _tableview.register(UINib(nibName: "Post_tvCell", bundle: nil), forCellReuseIdentifier: "Post_tvCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post_tvCell", for: indexPath) as! Post_tvCell
        
        return cell
    }
    
}
