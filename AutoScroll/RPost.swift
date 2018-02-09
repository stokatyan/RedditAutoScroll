//
//  RPost.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/24/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit
import AVFoundation

enum PreviewType {
    case unknown
    case jpg
    case gif
    case link
    case subreddit
    case video
    case youtube
}

class RPost: NSObject {
    
    /** The index of the post's location in a feed. */
    let index: Int
    
    private let kGifSuffix = ".gif"
    private let kJpgSuffix = ".jpg"
    private let kPngSuffix = ".png"
    private let kGifvSuffix = ".gifv"
    private let kYoutubePrefix = "https://www.youtube.com/"
    private let kSubredditPrefix = "https://www.reddit.com/"
    private let kGfycatPrefix = "https://gfycat.com/"
    
    private let kStatusKeyPath = "status"
    
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
    
    private var previewGif: FLAnimatedImage?
    private var previewImage: UIImage?
    private var previewVideo: AVPlayer?
    private var previewVideoItem: AVPlayerItem?
    private var previewDownloadCallback: (() -> Void)?
    
    private var _sourceWidth = 0
    private var _sourceHeight = 0
    var sourceWidth: Int {
        get {
            return _sourceWidth
        }
    }
    var sourceHeight: Int {
        get {
            return _sourceHeight
        }
    }
    
    private var previewLink: String?
    private var m_previewType = PreviewType.unknown
    var postPreviewType: PreviewType {
        get {
            return m_previewType
        }
    }
    
    /**
     Initializes an RPost form a json.
     - parameter json: the json describing the posts features.
     - parameter index: the index of the post's location in a feed. */
    init (_ json: JSON, index: Int = 0) {
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
        self.index = index

        super.init()
        setPreviewLink()
    }
    
    // MARK: KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        guard let keyPath = keyPath else {
            return
        }
        
        switch keyPath {
        case kStatusKeyPath:
            if let callback = previewDownloadCallback {
                callback()
            }
        default:
            break
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
    func getPreviewImage() -> UIImage? {
        return previewImage
    }
    
    /** - returns: the preview gif for this post. */
    func getPreviewGif() -> FLAnimatedImage? {
        return previewGif
    }
    
    /** - returns: the preview video for this post. */
    func getPreviewVideo() -> AVPlayer? {
        return previewVideo
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
        } else if (postUrl.suffix(kPngSuffix.count) == kPngSuffix) {
            m_previewType = .jpg
        } else if (postUrl.suffix(kGifSuffix.count) == kGifSuffix) {
            m_previewType = .gif
        } else if (postUrl.suffix(kGifvSuffix.count) == kGifvSuffix) {
            m_previewType = .video
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
     - parameter callback: the callback that is exectuted after the preview image is downloaded. */
    private func downloadPreviewContent(url: URL, callback: @escaping () -> ()) {
        if (m_previewType == .video) {
            previewDownloadCallback = {
                callback()
            }
            downloadPreviewVideo()
            return
        }
        
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
    
    /** Downloads the preview video and initializes the `previewVideo` AVPlayer */
    func downloadPreviewVideo() {
        let videoURL = NSURL(string: previewLink!)
        previewVideo = AVPlayer(url: videoURL! as URL)
        previewVideo?.addObserver(self, forKeyPath: kStatusKeyPath, options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    /** Downloads and sets the preview from `previewLink`. */
    func setPreview(callback: @escaping (Bool) -> ()) {
        if (previewLink == nil) {
            return
        }
        downloadPreviewContent(url: URL(string: previewLink!)!) {
            switch self.m_previewType {
            case .jpg:
                callback(true)
                break
            case .gif:
                callback(true)
                break
            case .video:
                callback(true)
                break
            default:
                callback(false)
            }
            
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
        case .video:
            getDimensionsOfPreviewSource()
            setPreviewLinkForVideo()
            break
        default:
            setPreviewLinkForDefaultImage()
            break
        }
        
    }
    
    /** Gets the dimensions of the source image. */
    private func getDimensionsOfPreviewSource() {
        if let images = _preview?["images"] as? [JSON] {
            if let source = images.first?["source"] as? JSON {
                guard
                    let width = source["width"] as? Int,
                    let height = source["height"] as? Int else {
                    return
                }
                _sourceWidth = width
                _sourceHeight = height
            }
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
    
    /** Sets the preview link for the gif to the url. */
    private func setPreviewLinkForGif() {
        previewLink = _url
    }
    
    /** Sets the preview link for the video to the url. */
    private func setPreviewLinkForVideo() {
        if let url = _url {
            previewLink = url.replacingOccurrences(of: ".gifv", with: ".mp4")
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
        print("----------")
    }
    
}
