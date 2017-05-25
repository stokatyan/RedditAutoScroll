//
//  RPost.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/24/17.
//  Copyright © 2017 com.example. All rights reserved.
//

//  Data associated with a post on Reddit

import Foundation

class RPost {
    
    private let _id: String?
    private var _num_comments: String?
    private var _over_18: String?
    private let _permalink: String?
    private var _score: String?
    private let _subreddit: String?
    private let _title: String?
    
    private var images = [JSON]()
    
    
    init (json: JSON) {
        _id = json["id"] as? String
        _num_comments = json["num_comments"] as? String
        _over_18 = json["over_18"] as? String
        _permalink = json["permalink"] as? String
        _score = json["score"] as? String
        _subreddit = json["subreddit"] as? String
        _title = json["title"] as? String
    }
    
}
