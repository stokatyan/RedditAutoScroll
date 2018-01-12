//
//  HomePresenter.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/28/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

class HomePresenter {
    
    var view: HomeView!
    private let model = Feed()
    
    func attachView(view: HomeVC) {
        self.view = view
    }
    
    /** Called when the user initially logs in and obtains a valid access token. */
    func initialLoginSucceeded() {
        print("access token received")
        updateFeed(from: Listings.hot, count: 30)
    }
    
    /** Loads the preview image for each post after the entire feed has been loaded. */
    func loadPostMedia() {
        let posts = self.model.getPosts()
        for post in posts {
            post.setPreview() {
                self.view.reloadTableView()
            }
        }
    }
    
    /** Prints the current models RPost array to the console.*/
    func printPosts() {
        self.view.printPosts(model.getPosts())
    }
    
    /**
     Updates the feed model with posts from a reddit listing, and then updates the displayed feed.
     - parameter listing: the listing (hot, trendining, etc ..) to get posts from.
     - parameter count: the maximum number of posts to get. */
    func updateFeed(from listing: String, count: Int) {
        RedAPI.shared.getPostsFromListing(listing, count: count) { posts in
            if posts != nil {
                self.model.setPosts(posts!)
                print("finished getting posts")
                self.loadPostMedia()
                self.view.reloadTableView()
                self.printPosts()
            } else {
                
            }
        }
    }
    
    // MARK: get
    
    /**
     Gets a particular post from the feed model.
     - parameter index: the particular post to get from the model's array of posts. */
    func getPost(_ index: Int) -> RPost? {
        let posts = self.model.getPosts()
        if (index < posts.count ) {
            return posts[index]
        }
        return nil
    }
    
    /** Gets the number of posts in the feed. */
    func getPostCount() -> Int {
        return self.model.getPosts().count
    }
}
