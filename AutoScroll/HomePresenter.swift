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
    
    /** Prints the current models RPost array to the console.*/
    func printPosts() {
        self.view.printPosts(model.getPosts())
    }
    
    func loadPosts(listing: String, count: Int) {
        RedAPI.shared.getPostsFromListing(listing, count: count) { posts in
            if posts != nil {
                self.model.setPosts(posts!)
                self.view.finishedLoadingPosts(succeeded: true)
            } else {
                self.view.finishedLoadingPosts(succeeded: false)
            }
        }
    }
    
    func loadPostMedia() {
        let posts = self.model.getPosts()
        for post in posts {
            post.setPreviewImage() {
                self.view.reloadTableView()
            }
        }
    }
    
    // MARK: get
    
    private func getPost(_ index: Int) -> RPost? {
        let posts = self.model.getPosts()
        if (index < posts.count ) {
            return posts[index]
        }
        return nil
    }
    
    func getPostCount() -> Int {
        return self.model.getPosts().count
    }
    
    func getPostImage(_ index: Int) -> UIImage? {
        return getPost(index)!.getImage()
    }
    func getPostTitle(_ index: Int) -> String {
        return getPost(index)!.getTitle()
    }
}
