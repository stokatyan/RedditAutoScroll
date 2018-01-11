//
//  RPost.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/24/17.
//  Copyright © 2017 com.example. All rights reserved.
//

//  Data associated with a post on Reddit

import UIKit

enum PreviewType {
    case unknown
    case jpg
    case gif
    case link
    case subreddit
    case youtube
}

class RPost {
    
    static let DEFAULT_HEIGHT: Double = 44
    
    let kGifSuffix = ".gifv"
    let kJpgSuffix = ".jpg"
    let kYoutubePrefix = "https://www.youtube.com/"
    let kSubredditPrefix = "https://www.reddit.com/"
    let kGfycatPrefix = "https://gfycat.com/"
    
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
    private var previewGif: FLAnimatedImage?
    private var previewLink: String?
    private var m_previewType = PreviewType.unknown
    
    
    /**
     Initializes an RPost form a json.
     - parameter json: the json describing the posts features. */
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
    
    // MARK: get
    
    /** Gets the preview image data from a URL. */
    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    /** - returns: the preview image for this post. */
    func getPreviewImage() -> UIImage? {
        return previewImage
    }
    
    /** - returns: the preview git for this post. */
    func getPreviewGif() -> FLAnimatedImage? {
        return previewGif
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
    
    // MARK: Preview Handling
    
    /** Sets `previewImageType` based on the post url. */
    func determinePreviewType() {
        guard let postUrl = _url else {
            return
        }
        
        if (postUrl.suffix(kJpgSuffix.count) == kJpgSuffix) {
            m_previewType = .jpg
        } else if (postUrl.suffix(kGifSuffix.count) == kGifSuffix) {
            m_previewType = .gif
        } else if (postUrl.prefix(kYoutubePrefix.count) == kYoutubePrefix) {
            m_previewType = .youtube
        } else if (postUrl.prefix(kSubredditPrefix.count) == kSubredditPrefix) {
            m_previewType = .subreddit
        } else if (postUrl.prefix(kGfycatPrefix.count) == kGfycatPrefix) {
            m_previewType = .gif
        }
    }
    
    /**
     Downloads the preview content from the given url and then executes a callback.
     - parameter url: the url containing the preview content.
     - parameter callback: the callback that is exectuted after the preview image is downloaded.*/
    private func downloadPreviewContent(url: URL, callback: @escaping () -> ()) {
        
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil
                else {
                    print(error!.localizedDescription)
                    return
            }
            
            DispatchQueue.main.async() { () -> Void in
                switch self.m_previewType {
                case .jpg:
                    self.previewImage = UIImage(data: data)
                case .gif:
                    self.previewGif = FLAnimatedImage(gifData: data)
                default:
                    callback()
                }
            }
        }
        
    }
    
    /** Downloads and sets the preview from `previewLink`. */
    func setPreviewImage(callback: @escaping () -> ()) {
        if (previewLink == nil) {
            return
        }
        downloadPreviewContent(url: URL(string: previewLink!)!) {
            callback()
        }
    }
    
    /** Finds and sets the appropriate `previewImageLink` depending on `previewImageType`. */
    func setPreviewLink() {
        determinePreviewType()

        switch m_previewType {
        case .jpg:
            setPreviewLinkForDefaultImage()
            break
        case .gif:
            setPreviewLinkForGif()
            break
        default:
            setPreviewLinkForDefaultImage()
            break
        }
        
        
    }
    
    /** Sets the preview link based on the preview images. */
    private func setPreviewLinkForDefaultImage() {
        if let images = _preview?["images"] as? [JSON] {
            if let resolutions = images.first?["resolutions"] as? [JSON] {
                previewLink = resolutions[resolutions.count/2]["url"] as? String
                if (previewLink != nil) {
                    previewLink = previewLink!.replacingOccurrences(of: "&amp;", with: "&")
                }
            }
        }
    }
    
    /** Sets the preview link to the post url that contains the gif. */
    private func setPreviewLinkForGif() {
        if let gifUrl = _url {
            previewLink = "https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"//gifUrl //
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
        if (_url != nil) {print("_url: \(_url!)")}

        print(m_previewType.hashValue)
        print("----------")
    }
    
}
