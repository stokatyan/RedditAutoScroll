//
//  ViewController.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/16/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

protocol HomeView {
    
    /**
     Prints the current models `RPost` array to the console.
     - parameter posts: the `RPost` array to print. */
    func printPosts(_ posts: [RPost])

    /** Reloads the tableview that is displaying the reddit feed. */
    func reloadTableView()

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
    
    func printPosts(_ posts: [RPost]) {
        for post in posts {
            post.rPrint()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self._tableview.reloadData()
        }
    }

}

