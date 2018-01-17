//
//  Feed.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/28/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import Foundation

class Feed {
    
    private var _posts = [RPost]()
    
    // MARK: Filters
    
    func filterPosts(previewType: PreviewType) {
        var filteredPosts = [RPost]()
        
        for post in _posts {
            if (post.postPreviewType == previewType) {
                filteredPosts.append(post)
            }
        }
        _posts = filteredPosts
    }
    
    // MARK: get
    
    func getPosts() -> [RPost] {
        return _posts
    }
        
    // MARK: set
    
    func setPosts(_ posts: [RPost]) {
        _posts = posts
    }
    
}
