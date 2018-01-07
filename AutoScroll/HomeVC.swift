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

    
    func finishedLoadingPosts(succeeded: Bool)

    /** Reloads the tableview that is displaying the reddit feed. */
    func reloadTableView()

}

class HomeVC: UIViewController {
    
    let homePresenter = HomePresenter()
    
    @IBOutlet weak var _tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        homePresenter.attachView(view: self)
        refreshAccessToken()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func accessTokenReceived() {
        print("access token received")
        loadInitialPosts()
    }
    func failedToReceiveAccessToken() {
        print("failed to receive access token")
    }
    
    private func loadInitialPosts() {
        print("loading initial posts")
        homePresenter.loadPosts(listing: Listings.hot, count: 15)
    }
    
    private func refreshAccessToken() {
        RedAPI.shared.refreshAccessToken { (succesful) in
            if (!succesful) {
                UIApplication.shared.open(URL(string:RedAPI.shared.kAuthURL)!, options: [:], completionHandler: nil)
            } else {
                self.accessTokenReceived()
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
    
    func finishedLoadingPosts(succeeded: Bool) {
        if (succeeded) {
            print("finished loading posts")
            homePresenter.loadPostMedia()
            DispatchQueue.main.async {
                self._tableview.reloadData()
            }
            homePresenter.printPosts()
        } else {
            
        }
    }
    
    func reloadTableView() {
        self._tableview.reloadData()
    }

}

