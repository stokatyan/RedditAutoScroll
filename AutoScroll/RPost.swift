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
    private var _num_comments: Int?
    private var _over_18: Bool?
    private let _permalink: String?
    private var _score: Int?
    private let _subreddit: String?
    private let _title: String?
    
    private var images = [JSON]()
    
    
    init (_ json: JSON) {
        _id = json["id"] as? String
        _num_comments = json["num_comments"] as? Int
        _over_18 = json["over_18"] as? Bool
        _permalink = json["permalink"] as? String
        _score = json["score"] as? Int
        _subreddit = json["subreddit"] as? String
        _title = json["title"] as? String
        if let preview = json["preview"] as? JSON {
            setImages(preview)
        }
    }
    
    func setImages(_ preview: JSON) {
        guard let imgs = preview["images"] as? [JSON] else { return }
        images = imgs
    }
    
    func rPrint(_ showImages: Bool = false) {
        print("----------")
        if (_id != nil) {print("_id: \(_id!)")}
        if (_num_comments != nil) {print("_num_comments: \(_num_comments!)")}
        if (_over_18 != nil) {print("_over_18: \(_over_18!)")}
        if (_permalink != nil) {print("_permalink: \(_permalink!)")}
        if (_score != nil) {print("_score: \(_score!)")}
        if (_subreddit != nil) {print("_subreddit: \(_subreddit!)")}
        if (_title != nil) {print("_title: \(_title!)")}
        if (showImages) {
            for image in images {
                print(image)
            }
        }
        print("----------")
    }
    
}
