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
    private let _is_video: Int?
    private var _num_comments: Int?
    private var _over_18: Bool?
    private let _permalink: String?
    private var _preview: JSON?
    private var _score: Int?
    private let _subreddit: String?
    private let _title: String?
    private let _url: String?
    
    private var previewImage: UIImage?
    private var previewImageLink: String?
    
    /**
     Initializes an RPost form a json.
     - parameter json: th json describing the posts features. */
    init (_ json: JSON) {
        _id = json["id"] as? String
        _is_video = json["is_video"] as? Int
        _num_comments = json["num_comments"] as? Int
        _over_18 = json["over_18"] as? Bool
        _permalink = json["permalink"] as? String
        _preview = json["preview"] as? JSON
        _score = json["score"] as? Int
        _subreddit = json["subreddit"] as? String
        _title = json["title"] as? String
        _url = json["url"] as? String
        
        if (_url != nil) {
            print(_url!)
        }
        
        setPreviewLink()
    }
    
    /** Downloads the preview image for a post.  */
    private func downloadImage(url: URL, callback: @escaping () -> ()) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil
                else {
                    print(error!.localizedDescription)
                    return
            }
            DispatchQueue.main.async() { () -> Void in
                self.previewImage = UIImage(data: data)
                callback()
            }
        }
    }
    
    // MARK: get
    
    /** Gets the preview image data from a URL. */
    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    /** - returns: the preview image for this post. */
    func getImage() -> UIImage? {
        return previewImage
    }
    
    /** - returns: the title of this post. */
    func getTitle() -> String {
        if (_title == nil) {
            return ""
        }
        return _title!
    }
    
    /** - returns: the subreddit of this post. */
    func getSubreddit() -> String {
        if (_subreddit == nil) {
            return ""
        }
        return _subreddit!
    }
    
    // MARK: set
    
    /** Downloads and sets the preview image from `previewImageLink`. */
    func setPreviewImage(callback: @escaping () -> ()) {
        if (previewImageLink == nil) {
            return
        }
        downloadImage(url: URL(string: previewImageLink!)!) {
            callback()
        }
    }
    
    /** Finds and sets `previewImageLink` from `_preview`. */
    func setPreviewLink() {
        
        if let images = _preview?["images"] as? [JSON] {
            if let resolutions = images.first?["resolutions"] as? [JSON] {
                previewImageLink = resolutions[resolutions.count/2]["url"] as? String
                if (previewImageLink != nil) {
                    previewImageLink = previewImageLink!.replacingOccurrences(of: "&amp;", with: "&")
                }
            }
        }
    }
    
    // MARK: Debug
    
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
