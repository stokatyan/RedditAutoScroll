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
    func FinishedLoadingPosts()
    func LoadInitialPosts()
    
    // MARK: Getting Acces Token
    func AccessTokenReceived()
    func FailedToReceivceAccess()
    func GettingAccesToken()
}

class HomeVC: UIViewController {
    
    let _homePresenter = HomePresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        _homePresenter.AttachView(view: self)
        _homePresenter.getAccessToken()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HomeVC: HomeView {
    func DisplayPosts(_ posts: [RPost]) {
        
    }
    func FinishedLoadingPosts() {
        
    }
    func LoadInitialPosts() {
        
    }
    
    // MARK: Getting Acces Token
    func AccessTokenReceived() {
        
    }
    func FailedToReceivceAccess() {
        
    }
    func GettingAccesToken() {
        
    }
}

