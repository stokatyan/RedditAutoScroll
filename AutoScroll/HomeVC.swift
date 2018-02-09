//
//  ViewController.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/16/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

protocol HomeView {

    /** Reloads the tableview that is displaying the reddit feed. */
    func reloadTableView()
    
    /**
     Reloads the tableview at a particular cell that is displaying the reddit feed.
     - parameter index: the index of the cell to reload. */
    func reloadTableView(atIndex index: Int)

}

class HomeVC: UIViewController {
    
    let homePresenter = HomePresenter()
    
    @IBOutlet weak var _tableview: UITableView!

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        self.title = "Reddit Auto Scroll"
        homePresenter.attachView(view: self)
        refreshAccessToken()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Authentication
    
    /** Refreshes the users access token by either getting a new one or using the refresh token.  */
    private func refreshAccessToken() {
        RedAPI.shared.refreshAccessToken { (succesful) in
            if (!succesful) {
                UIApplication.shared.open(URL(string:RedAPI.shared.kAuthURL)!, options: [:], completionHandler: nil)
            } else {
                self.homePresenter.initialLoginSucceeded()
            }
        }
    }

}

// MARK: HomeView protocal

extension HomeVC: HomeView {
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self._tableview.reloadData()
        }
    }
    
    func reloadTableView(atIndex index: Int) {
        
        DispatchQueue.main.async {
            guard index < self._tableview.numberOfRows(inSection: 0) else {
                self._tableview.reloadData()
                return
            }
            
            self._tableview.reloadRows(at: [IndexPath(row: index, section: 0)], with: .left)
        }
    }

}

