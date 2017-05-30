//
//  HomePresenter.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/28/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

class HomePresenter {
    
    var _view: HomeVC!
    let _model = Feed()
    
    func AttachView(view: HomeVC) {
        _view = view
    }
    
    func DisplayPosts() {
        _view.DisplayPosts(_model.getPosts())
    }
    
    func LoadPosts(listing: String, count: Int) {
        RedAPI.shared.getPostsFromListing(listing, count: count) { posts in
            if posts != nil {
                self._model.setPosts(posts!)
                self._view.FinishedLoadingPosts(succeeded: true)
            } else {
                self._view.FinishedLoadingPosts(succeeded: false)
            }
        }
    }
    
    func getAccessToken() {
        RedAPI.shared.refreshAccessToken { (succesful) in
            if (!succesful) {
                UIApplication.shared.open(URL(string:RedAPI.shared.kAuthURL)!, options: [:], completionHandler: nil)
            } else {
                self._view.AccessTokenReceived()
            }
        }
    }
    
}
