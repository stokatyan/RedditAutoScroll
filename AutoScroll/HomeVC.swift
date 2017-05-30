//
//  ViewController.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/16/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

protocol HomeView {
    func DisplayPosts(_ posts: [RPost])
    func FinishedLoadingPosts(succeeded: Bool)
    func LoadInitialPosts()
    
    // MARK: Getting Acces Token
    func AccessTokenReceived()
    func FailedToReceivceAccess()
    func GettingAccesToken()
}

class HomeVC: UIViewController {
    
    let _homePresenter = HomePresenter()
    
    @IBOutlet weak var _tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        
        _homePresenter.AttachView(view: self)
        _homePresenter.getAccessToken()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension HomeVC: HomeView {
    func DisplayPosts(_ posts: [RPost]) {
        for post in posts {
            post.rPrint()
        }
    }
    func FinishedLoadingPosts(succeeded: Bool) {
        if (succeeded) {
            print("finished loading posts")
            _homePresenter.DisplayPosts()
        } else {
            
        }
    }
    func LoadInitialPosts() {
        print("loading initial posts")
        _homePresenter.LoadPosts(listing: Listings.hot, count: 5)
    }
    
    // MARK: Getting Acces Token
    func AccessTokenReceived() {
        print("access token received")
        LoadInitialPosts()
    }
    func FailedToReceivceAccess() {
        print("failed to receive access token")
    }
    func GettingAccesToken() {
        print("getting access token")
    }
}

