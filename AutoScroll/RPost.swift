//
//  RPost.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/24/17.
//  Copyright © 2017 com.example. All rights reserved.
//

//  Data associated with a post on Reddit

import UIKit

class RPost {
    
    static let DEFAULT_HEIGHT: Double = 44
    
    private let _id: String?
    private var _num_comments: Int?
    private var _over_18: Bool?
    private let _permalink: String?
    private var _preview: JSON?
    private var _score: Int?
    private let _subreddit: String?
    private let _title: String?
    
    private var height: Double
    private var previewImage: UIImage?
    private var previewImageLink: String?
    
    
    init (_ json: JSON) {
        _id = json["id"] as? String
        _num_comments = json["num_comments"] as? Int
        _over_18 = json["over_18"] as? Bool
        _permalink = json["permalink"] as? String
        _preview = json["preview"] as? JSON
        _score = json["score"] as? Int
        _subreddit = json["subreddit"] as? String
        _title = json["title"] as? String
        
        height = RPost.DEFAULT_HEIGHT
        setHeight()
    }
    
    // MARK: get
    
    func getHeight() -> Double {
        return height
    }
    
    func getImage() -> UIImage? {
        return previewImage
    }
    
    func getTitle() -> String {
        if (_title == nil) {
            return ""
        }
        return _title!
    }
    
    // MARK: set
    
    func setHeight() {
        if let images = _preview?["images"] as? [JSON] {
            if let resolutions = images.first?["resolutions"] as? [JSON] {
                if let h = resolutions.last?["height"] as? Int {
                    height = Double(h)
                    previewImageLink = resolutions.last!["url"] as? String
                }
                
            }
        }
    }
    
    func setPreviewImage() {
        if (previewImageLink == nil) {
            return
        }
        print(previewImageLink!)
        if let filePath = Bundle.main.path(forResource: previewImageLink, ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) {
            previewImage = image
        }
    }
    
    func rPrint() {
        print("----------")
        if (_id != nil) {print("_id: \(_id!)")}
        if (_num_comments != nil) {print("_num_comments: \(_num_comments!)")}
        if (_over_18 != nil) {print("_over_18: \(_over_18!)")}
        if (_permalink != nil) {print("_permalink: \(_permalink!)")}
        if (_score != nil) {print("_score: \(_score!)")}
        if (_subreddit != nil) {print("_subreddit: \(_subreddit!)")}
        if (_title != nil) {print("_title: \(_title!)")}

        print("----------")
    }
    
}
