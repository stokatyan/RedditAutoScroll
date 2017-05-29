//
//  HomePresenter.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/28/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

class HomePresenter {
    
    var _view = HomeVC()
    
    func AttachView(view: HomeVC) {
        _view = view
    }
    
    func LoadPosts(listing: String, count: Int) {
        
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
